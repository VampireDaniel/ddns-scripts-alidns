#!/usr/bin/env bats

@test "Aliyun signature generation" {
  run bash -c 'echo -n "teststring" | openssl dgst -sha1 -hmac "secret&" -binary | openssl base64'
  [ "$status" -eq 0 ]
}

@test "Parse fake API response" {
  run bash -c 'echo "{\"Code\":\"DomainRecordDuplicate\"}" | jsonfilter -e "@.Code"'
  [ "$status" -eq 0 ]
  [ "$output" = "DomainRecordDuplicate" ]
} 