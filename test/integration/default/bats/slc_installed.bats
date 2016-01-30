#!/usr/bin/env bats

@test "slc binary is found in PATH" {
  run which slc
  [ "$status" -eq 0 ]
}