#!/bin/bash
# KDE Shortcuts Aliases
# Source this file in your .bashrc or .zshrc: source ~/Dropbox/computing/shortcut-aliases.sh

# Main shortcut cheatsheet command
alias short='shortcut-cheat'

# Quick memorable aliases for common searches
alias winkeys='shortcut-cheat window'
alias tilekeys='shortcut-cheat krohnkite'
alias deskkeys='shortcut-cheat desktop'
alias metakeys='shortcut-cheat meta'

# Utility aliases
alias short-edit='shortcut-cheat --edit'

# Add new shortcut function
short-add() {
    if [[ -z "$1" ]]; then
        echo "Usage: short-add 'Action Name=Shortcut'"
        echo "Example: short-add 'My Custom Action=Meta+Shift+X'"
        return 1
    fi
    shortcut-cheat --add "$1"
}

# echo "KDE Shortcuts aliases loaded!"
# echo ""
# echo "Usage:"
# echo "  short                    - Show all shortcuts"
# echo "  short [terms...]         - Search shortcuts (AND logic)"
# echo "  short-edit               - Edit shortcuts file"
# echo "  short-add 'Action=Key'   - Add new shortcut"
# echo ""
# echo "Quick aliases:"
# echo "  winkeys     - Window management shortcuts"
# echo "  tilekeys    - Krohnkite tiling shortcuts"
# echo "  deskkeys    - Desktop switching shortcuts"
# echo "  metakeys    - Meta key shortcuts"
# echo ""
# echo "Examples:"
# echo "  short window left        - Window shortcuts with 'left'"
# echo "  short meta shift         - Meta+Shift combinations"
# echo "  short f10               - All F10 shortcuts"
