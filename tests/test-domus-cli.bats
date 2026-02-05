#!/usr/bin/env bats
# Integration tests for domus CLI

setup() {
  DOMUS="$BATS_TEST_DIRNAME/../dot_local/bin/executable_domus"
}

@test "domus --help exits 0" {
  run bash "$DOMUS" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"domus"* ]]
  [[ "$output" == *"COMMANDS"* ]]
}

@test "domus --version prints version" {
  run bash "$DOMUS" --version
  [ "$status" -eq 0 ]
  [[ "$output" == domus* ]]
}

@test "domus help shows usage" {
  run bash "$DOMUS" help
  [ "$status" -eq 0 ]
  [[ "$output" == *"USAGE"* ]]
}

@test "domus unknown command fails" {
  run bash "$DOMUS" nonexistent-command
  [ "$status" -eq 2 ]
  [[ "$output" == *"Unknown command"* ]]
}
