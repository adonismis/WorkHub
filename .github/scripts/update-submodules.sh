#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SUBMODULE_READ_TOKEN:-}" ]]; then
  echo '::error::Set the WORKHUB_SUBMODULE_READ_TOKEN repository secret.'
  exit 1
fi

branch=automation/update-submodules
target_ref="refs/heads/$branch"

for path in ilwct_server savs ruiyang-em.com ilwct_life; do
  if [[ $(git ls-files -s -- "$path") != "160000 "* ]]; then
    echo "::error::$path is not tracked as a submodule."
    exit 1
  fi
  sha=$(GH_TOKEN="$SUBMODULE_READ_TOKEN" gh api \
    "repos/adonismis/$path/git/ref/heads/main" --jq .object.sha)
  if [[ ! "$sha" =~ ^[0-9a-f]{40}$ ]]; then
    echo "::error::Invalid commit SHA for $path."
    exit 1
  fi
  git update-index --cacheinfo "160000,$sha,$path"
done

if git diff --cached --quiet; then
  echo 'WorkHub already records the latest submodule commits.'
  exit 0
fi

remote_ref=$(git ls-remote --refs origin "$target_ref")
remote_sha=${remote_ref%%$'\t'*}
staged_tree=$(git write-tree)
base_sha=$(git rev-parse HEAD)
push_needed=true

# Keep the PR branch intact when it already has this update on the current base.
if [[ -n "$remote_sha" ]]; then
  git fetch --no-tags --depth=2 origin "$target_ref"
  if [[ "$(git rev-parse FETCH_HEAD^{tree})" == "$staged_tree" &&
        "$(git rev-parse FETCH_HEAD^)" == "$base_sha" ]]; then
    push_needed=false
  fi
fi

if [[ "$push_needed" == true ]]; then
  git -c user.name='github-actions[bot]' \
    -c user.email='41898282+github-actions[bot]@users.noreply.github.com' \
    commit -m '更新子專案版本'
  git push --force-with-lease="$target_ref:$remote_sha" origin "HEAD:$target_ref"
fi

pr=$(gh pr list --repo "$GITHUB_REPOSITORY" --head "$branch" \
  --base "$BASE_BRANCH" --state open --json number --jq '.[0].number // empty')
if [[ -z "$pr" ]]; then
  gh pr create --repo "$GITHUB_REPOSITORY" --head "$branch" \
    --base "$BASE_BRANCH" --title '更新子專案版本' \
    --body '將 WorkHub 的 submodule 指標更新至各子專案 main 的最新提交。'
fi
