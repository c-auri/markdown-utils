function setup
{
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    source $DIR/../src/markdown-utils
}

@test "get-title returns top-level heading without the #" {
    testfile=$BATS_TEST_TMPDIR/tl-heading.md
    echo "# This is a Test" > $testfile
    run get_title $testfile
    assert_success
    assert_output "This is a Test"
}

@test "get-title returns only the first top-level heading" {
    testfile=$BATS_TEST_TMPDIR/tl-heading.md
    echo "# This is a Test" > $testfile
    echo "# This is a Trick" >> $testfile
    run get_title $testfile
    assert_success
    assert_output "This is a Test"
}

@test "get-title does not return lower level heading, even if it's the only one" {
    testfile=$BATS_TEST_TMPDIR/tl-heading.md
    echo "## This is a Trick" > $testfile
    run get_title $testfile
    assert_success
    refute_output
}

@test "get-title does not return lower level heading, even if it comes first" {
    testfile=$BATS_TEST_TMPDIR/tl-heading.md
    echo "## This is a Trick" > $testfile
    echo "# This is a Test" >> $testfile
    run get_title $testfile
    assert_success
    assert_output "This is a Test"
}

@test "get-title returns nothing when file is empty" {
    testfile=$BATS_TEST_TMPDIR/empty.md
    touch $testfile
    run get_title $testfile
    assert_success
    refute_output
}

@test "get-title retuns nothing when file is not empty but has no heading" {
    testfile=$BATS_TEST_TMPDIR/no-tl-heading.md
    echo "This is not a heading" > $testfile
    run get_title $testfile
    assert_sucess
    refute_output
}

@test "get-title fails silently when no file is given" {
    run get_title
    assert_failure
    refute_output
}

@test "get-title fails silently when file does not exist" {
    run get_title $BATS_TEST_TMPDIR/does-not-exist.md
    assert_failure
    refute_output
}
