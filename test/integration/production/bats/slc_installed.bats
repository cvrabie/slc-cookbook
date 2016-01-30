#!/usr/bin/env bats

@test "sl-pm binary is found in PATH" {
  run which sl-pm
  [ "$status" -eq 0 ]
}