#!/usr/bin/env bash

# Desired Node.js version
desired_version="v20.7.0"

# Get the current Node.js version
current_version=$(node -v)

# Compare the current version with the desired version
if [ "$current_version" == "$desired_version" ]; then
    echo "Node.js version matches: $current_version"
else
    echo "Node.js version does not match. Current version: $current_version, Desired version: $desired_version"

    # Check if nvm exists in path
    if which nvm &> /dev/null
    then
        echo "nvm exists in PATH"
    else
        echo "nvm does not exist in PATH"

        # Install nvm to install a newer version of node, required for the app to start
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

        # Export environment variables required to run nvm without a shell restart
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi

    # Check if the desired node version is installed
    if nvm ls "$desired_version" | grep -q "$desired_version"; then
        echo "Node.js version $desired_version is installed."

        # Switch to the desired version
        nvm use $desired_version
    else
        echo "Node.js version $desired_version is not installed."

        # Install node v20.7.0
        nvm install $desired_version
    fi
fi

# Change to project app directory if not already there
cd "$(dirname "$0")/../app"

# Define local node_modules bin directory
bin_directory="node_modules/.bin"

# Check if the directory exists
if [ -d "$bin_directory" ]; then
    echo "The directory $bin_directory exists."
else
    echo "The directory $bin_directory does not exist."

    # Install next@14.0.4 globally for the bin to work in this read-only environment
    npm i -g next@14.0.4
fi

# Finally start the app
npm start
