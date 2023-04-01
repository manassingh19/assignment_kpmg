get_value() {
  local object="$1"
  local key="$2"

  # Use jq to get the value of the key
  local value=$(echo "$object" | jq -r ".$key")

  # Print the value
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
