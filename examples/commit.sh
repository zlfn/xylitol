#!/usr/bin/env bash

commit_type=$(source ../xylitol.sh choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert" --header="\e[96mChoose Commit Type\e[0m")
scope=$(source ../xylitol.sh input --placeholder="scope" --header="\e[96mEnter Commit Scope (Optional)\e[0m")
scope_part=${scope:+"($scope)"}
message=$(source ../xylitol.sh input --prompt="$commit_type$scope_part: " --placeholder="message" --header="\e[96mEnter Commit Message\e[0m")
echo "$commit_type$scope_part: $message"
