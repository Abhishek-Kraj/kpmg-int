# Define a new function called Get-NestedValue
function Get-NestedValue {
    # Declare parameters for the function: a hashtable (nestedHash) and a string (key)
    param(
        [hashtable]$nestedHash,
        [string]$key
    )

    # Split the key string on "/" to get an array of keys
    $keys = $key -split "/"

    # If the array of keys has only one element
    if ($keys.Count -eq 1) {
        # Return the value in the hashtable corresponding to that key
        return $nestedHash[$keys[0]]
    } else {
        # If there is more than one key, take the first key
        $newKey = $keys[0]
        # And join the remaining keys into a string
        $remainingKeys = $keys[1..($keys.Count - 1)] -join "/"
        # Then make a recursive call to Get-NestedValue with the hashtable at the first key and the remaining keys
        return Get-NestedValue -nestedHash $nestedHash[$newKey] -key $remainingKeys
    }
}

# Define a hashtable
$object1 = @{"a"=@{"b"=@{"c"="d"}}}
# Define a key string
$key1 = "a/b/c"
# Write "Test 1:" to the output
Write-Output "Test 1:"
# Call Get-NestedValue with the hashtable and key string, and write the return value to the output
Write-Output (Get-NestedValue -nestedHash $object1 -key $key1)  # prints: d

# Do the same thing with a different hashtable and key string
$object2 = @{"x"=@{"y"=@{"z"="a"}}}
$key2 = "x/y/z"
Write-Output "Test 2:"
Write-Output (Get-NestedValue -nestedHash $object2 -key $key2)  # prints: a
