object='{"a":{"b":{"c":"d"}}}'
key='a/b/c'
value=$(get_value "$object" "$key")
echo "$value" # Output: d

object='{"x":{"y":{"z":"a"}}}'
key='x/y/z'
value=$(get_value "$object" "$key")
echo "$value" # Output: a


object='{"a":{"b":{"c":"d"}}}'
key='a/b/c'
value=$(get_value "$object" "$key")
echo "$value" # Output: d

object='{"x":{"y":{"z":"a"}}}'
key='x/y/z'
value=$(get_value "$object" "$key")
echo "$value" # Output: a
