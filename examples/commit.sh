#!/usr/bin/env bash

commit_type=$(../xylitol.sh choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert" --header="Choose Commit Type")
scope=$(../xylitol.sh input --placeholder="scope" --header="Enter Commit Scope (Optional)")
scope_part=${scope:+"($scope)"}
message=$(../xylitol.sh input --prompt="${commit_type}${scope_part}: " --placeholder="message" --header="Enter Commit Message")
echo "$commit_type$scope_part: $message"
