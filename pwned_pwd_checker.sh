#!/bin/bash

# Script to check if a password has been compromised using Have I Been Pwned API
# Uses SHA-1 hash and k-anonymity to protect password privacy

# Function to display usage
usage() {
    echo "Usage: $0 [password]"
    echo "If password is not provided, you'll be prompted to enter it securely"
    exit 1
}

# Check if password provided as argument
if [ $# -eq 1 ]; then
    password="$1"
else
    # Prompt for password securely (no echo)
    read -s -p "Enter password to check: " password
    echo
fi

# Validate password is not empty
if [ -z "$password" ]; then
    echo "Error: Password cannot be empty"
    exit 1
fi

# Generate SHA-1 hash of the password
hash=$(echo -n "$password" | sha1sum | cut -d' ' -f1)

# Convert to uppercase (API expects uppercase)
hash_upper=$(echo "$hash" | tr '[:lower:]' '[:upper:]')

# Get first 5 characters for k-anonymity
hash_prefix=${hash_upper:0:5}

# Get remaining characters to search for
hash_suffix=${hash_upper:5}

echo "Checking password against Have I Been Pwned database..."

# Make API call to get compromised hashes with same prefix
api_response=$(curl -s "https://api.pwnedpasswords.com/range/$hash_prefix")

# Check if curl command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to connect to Have I Been Pwned API"
    exit 1
fi

# Check if our hash suffix is in the response
if echo "$api_response" | grep -q "^$hash_suffix:"; then
    # Extract the count of times this password has been seen
    count=$(echo "$api_response" | grep "^$hash_suffix:" | cut -d':' -f2)
    echo "⚠️  WARNING: This password has been found in data breaches!"
    echo "   It has appeared $count times in compromised password lists."
    echo "   You should change this password immediately."
    exit 2
else
    echo "✅ Good news! This password has not been found in any known data breaches."
    echo "   However, you should still use a strong, unique password."
    exit 0
fi