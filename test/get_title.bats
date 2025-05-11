function setup
{
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    source $DIR/../src/markdown-utils

    TESTDIR=$DIR/tmp/get-title
    mkdir -p $TESTDIR
}

function teardown
{
    rm -rf $TESTDIR
}

@test "get-title returns top-level heading without the #" {
    testfile=$TESTDIR/tl-heading.md
    echo "# This is a Test" > $testfile
    run get_title $testfile
    assert_success
    assert_output "This is a Test"
}

@test "get-title returns only the first top-level heading" {
    testfile=$TESTDIR/tl-heading.md
    echo "# This is a Test" > $testfile
    echo "# This is a Trick" >> $testfile
    run get_title $testfile
    assert_success
    assert_output "This is a Test"
}

@test "get-title does not return lower level heading, even if it's the only one" {
    testfile=$TESTDIR/tl-heading.md
    echo "## This is a Trick" > $testfile
    run get_title $testfile
    assert_success
    refute_output
}

@test "get-title does not return lower level heading, even if it comes first" {
    testfile=$TESTDIR/tl-heading.md
    echo "## This is a Trick" > $testfile
    echo "# This is a Test" >> $testfile
    run get_title $testfile
    assert_success
    assert_output "This is a Test"
}

@test "get-title returns nothing when file is empty" {
    testfile=$TESTDIR/empty.md
    touch $testfile
    run get_title $testfile
    assert_success
    refute_output
}

@test "get-title fails silently when no file is given" {
    run get_title
    assert_failure
    refute_output
}

@test "get-title fails silently when file does not exist" {
    run get_title $TESTDIR/does-not-exist.md
    assert_failure
    refute_output
}

@test "get-title fails silenty when file has no heading" {
    testfile=$TESTDIR/no-tl-heading.md
    echo "This is a Test" > $testfile
    run get_title $testfile
    assert_success
    refute_output
}
