#!/bin/bash

# Add a directory to the PATH environment variable
# Usage: add_to_path /path/to/directory

add_to_path() {
    # Check if the directory exists
    if [ -d "$1" ]; then
        # Check if the directory is already in the PATH
        if [[ ":$PATH:" != *":$1:"* ]]; then
            # Add the directory to the PATH
            export PATH="$1:$PATH"
            echo "Directory '$1' added to PATH"
        else
            echo "Directory '$1' is already in PATH"
        fi
    else
        echo "Directory '$1' does not exist"
    fi
}

# Check if an argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

# Call the function with the provided directory
add_to_path "$1"
