#!/bin/bash
DEST=~/Dropbox/computing/hyprland/$(date +%Y-%m-%d_%H%M)
mkdir -p "$DEST"

# Hypr family configs
cp -r ~/.config/hypr "$DEST/hypr"

# Bar
cp -r ~/.config/waybar "$DEST/waybar" 2>/dev/null

# Notifications
cp -r ~/.config/mako "$DEST/mako" 2>/dev/null
cp -r ~/.config/dunst "$DEST/dunst" 2>/dev/null
cp -r ~/.config/monique "$DEST/monique" 2>/dev/null

# Launcher
cp -r ~/.config/hyprlauncher "$DEST/hyprlauncher" 2>/dev/null
cp -r ~/.config/rofi "$DEST/rofi" 2>/dev/null

# Terminal
cp -r ~/.config/kitty "$DEST/kitty" 2>/dev/null

# Shell
cp ~/.bashrc "$DEST/.bashrc" 2>/dev/null
cp ~/.bash_profile "$DEST/.bash_profile" 2>/dev/null
cp ~/.zshrc "$DEST/.zshrc" 2>/dev/null

cp -r ~/.config/konsole "$DEST/konsole" 2>/dev/null
cp -r ~/.config/zellij "$DEST/zellij" 2>/dev/null
cp -r ~/.config/nvim "$DEST/nvim" 2>/dev/null
cp -r ~/.config/fish "$DEST/fish" 2>/dev/null

echo "Backed up to $DEST"
