#!/bin/bash
# update_librespot.sh - Update spotifyd to use latest librespot dev branch

set -e

echo "Updating spotifyd to use librespot dev branch..."

# Backup original Cargo.toml
cp Cargo.toml Cargo.toml.backup

# Read current Cargo.toml and update librespot dependencies
python3 -c "
import re
import sys

with open('Cargo.toml', 'r') as f:
    content = f.read()

# Pattern to match librespot dependencies
patterns = [
    (r'librespot\s*=\s*\{[^}]*version\s*=\s*\"[^\"]*\"[^}]*\}', 
     'librespot = { git = \"https://github.com/librespot-org/librespot.git\", branch = \"dev\", default-features = false }'),
    (r'librespot-([a-z]+)\s*=\s*\{[^}]*version\s*=\s*\"[^\"]*\"[^}]*\}',
     lambda m: f'librespot-{m.group(1)} = {{ git = \"https://github.com/librespot-org/librespot.git\", branch = \"dev\", default-features = false }}')
]

for pattern, replacement in patterns:
    if callable(replacement):
        content = re.sub(pattern, replacement, content)
    else:
        content = re.sub(pattern, replacement, content)

with open('Cargo.toml', 'w') as f:
    f.write(content)
"

echo "Updated Cargo.toml to use librespot dev branch"
echo "Diff:"
diff -u Cargo.toml.backup Cargo.toml || true

echo ""
echo "You can now build with: cargo build --release --target arm-unknown-linux-gnueabihf --no-default-features --features dbus_mpris"
