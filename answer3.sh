#!/bin/bash

get_value() {
  local object="$1"
  local key="$2"
  local value="$(echo "$object" | jq -r ".$key")"
  echo "$value"
}


object='{"a":{"b":{"c":"d"}}}'
key='a/b/c'
value=$(get_value "$object" "$key")
echo "$value" # Output: d

object='{"x":{"y":{"z":"a"}}}'
key='x/y/z'
value=$(get_value "$object" "$key")
echo "$value" # Output: a
