#!/usr/bin/env bats

test_tmp_dir=test-tmp
programme=$BATS_TEST_DIRNAME/prepare-commit-msg
message_file=''

create_commit_message() {
    local branch_name=$1
    local output_file=$2
    $BATS_TEST_DIRNAME/original-commit-message.sh "$branch_name" |tee "$output_file"
}

export_git() {
    readonly branch_name=$1
    git() { [[ "$@" = 'symbolic-ref --short HEAD' ]] && { echo $branch_name ; } || { return 1; }; }
    export branch_name
    export -f git
}

setup() {
    rm -rf $test_tmp_dir
    mkdir $test_tmp_dir

    message_file="$test_tmp_dir/$BATS_TEST_NAME"
}

@test 'Shows original text' {
    export_git master
    original="$(create_commit_message master "$message_file")"

    run $programme "$message_file"
    
    diff "$message_file" <(echo "$original")
}

# @test 'Begins with a ticket name' {
#     export_git ISSUE-1000--do-something
#     original="$(create_commit_message ISSUE-1000--do-something "$message_file")"

#     run $programme "$message_file"

#     diff "$message_file" <(cat <<-END_COMMIT_MSG
# 		[ISSUE-1000]
# 		$original
# 		END_COMMIT_MSG
# 	)
# }

# @test "Add pair mate's name" {
#     export_git master
#     original="$(create_commit_message master "$message_file")"

#     CO_AUTHORED_BY='Foo Bar <foo.bar@example.com>' run $programme "$message_file"

#     diff "$message_file" <(cat <<-END_COMMIT_MSG

# 		Co-authored-by: Foo Bar <foo.bar@example.com>
# 		$original
# 		END_COMMIT_MSG
# 	)
# }

# @test "Add a ticket name and pair mate's name" {
#     export_git ISSUE-1000--do-something
#     original="$(create_commit_message ISSUE-1000--do-something "$message_file")"

#     CO_AUTHORED_BY='Foo Bar <foo.bar@example.com>' run $programme "$message_file"

#     diff "$message_file" <(cat <<-END_COMMIT_MSG
# 		[ISSUE-1000]

# 		Co-authored-by: Foo Bar <foo.bar@example.com>
# 		$original
# 		END_COMMIT_MSG
# 	)
# }
