#!/bin/bash
# Install git hooks
HOOK_DIR=.git/hooks
HOOKS_DIR=hooks

# Create symbolic links for each hook
for hook in $HOOKS_DIR/*; do
    if [ -f "$hook" ] && [ ! -x "$HOOK_DIR/$(basename $hook)" ]; then
        ln -sf "../../$hook" "$HOOK_DIR/$(basename $hook)"
        chmod +x "$HOOK_DIR/$(basename $hook)"
    fi
done
