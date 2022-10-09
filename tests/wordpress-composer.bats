# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
}

teardown() {
  load teardown.sh
}

@test "wordpress-composer" {
  load per_test.sh
  template="wordpress-composer"
  for source in $PROJECT_SOURCE platformsh/ddev-platformsh; do
    echo "# ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    per_test_setup

    run ddev exec -s db 'echo ${DDEV_DATABASE}'
    assert_output "mariadb:10.4"
    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
    assert_output "7.4"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "wordpress"
    per_test_teardown
  done
}