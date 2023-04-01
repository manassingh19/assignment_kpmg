#!/bin/bash

function get_value {
  local object=$1
  local key=$2

  # Convert key string into array
  IFS="/" read -ra key_arr <<< "$key"

  # Traverse the object using the keys
  local current="$object"
  for k in "${key_arr[@]}"; do
    if [[ -v "$current[$k]" ]]; then
      current="${current[$k]}"
    else
      echo "Key not found: $key" >&2
      return 1
    fi
  done

  echo "$current"
}



object='{"a":{"b":{"c":"d"}}}'
key='a/b/c'
value=$(get_value "$object" "$key")
echo "$value" # Output: d

object='{"x":{"y":{"z":"a"}}}'
key='x/y/z'
value=$(get_value "$object" "$key")
echo "$value" # Output: a
