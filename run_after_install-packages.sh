#!/bin/bash

echo "Checking for new mise runtimes..."
if test -f ~/.local/bin/mise &> /dev/null; then
    ~/.local/bin/mise install -y
else
    echo "mise is not installed. Skipping..."
fi
