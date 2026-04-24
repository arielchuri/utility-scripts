#!/bin/bash

# Script to save current KDE Plasma theme as a global theme
# For KDE Plasma on Wayland (Arch Linux/EndeavorOS)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}KDE Plasma Theme Saver${NC}"
echo "================================"
echo ""

# Get theme name from user
read -p "Enter a name for your global theme: " THEME_NAME

if [ -z "$THEME_NAME" ]; then
    echo -e "${RED}Error: Theme name cannot be empty${NC}"
    exit 1
fi

# Sanitize theme name for directory use
THEME_ID=$(echo "$THEME_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')

# Define paths
LOOK_AND_FEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
THEME_DIR="$LOOK_AND_FEEL_DIR/$THEME_ID"

# Check if theme already exists
if [ -d "$THEME_DIR" ]; then
    read -p "Theme already exists. Overwrite? (y/n): " OVERWRITE
    if [ "$OVERWRITE" != "y" ]; then
        echo "Aborted."
        exit 0
    fi
    rm -rf "$THEME_DIR"
fi

echo ""
echo -e "${YELLOW}Reading current theme settings...${NC}"

# Read current settings using kreadconfig6
COLOR_SCHEME=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme)
PLASMA_THEME=$(kreadconfig6 --file plasmarc --group Theme --key name)
WINDOW_DECORATION=$(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme)
ICON_THEME=$(kreadconfig6 --file kdeglobals --group Icons --key Theme)
CURSOR_THEME=$(kreadconfig6 --file kcminputrc --group Mouse --key cursorTheme)
SPLASH_SCREEN=$(kreadconfig6 --file ksplashrc --group KSplash --key Theme 2>/dev/null || echo "none")

echo "  Color Scheme: $COLOR_SCHEME"
echo "  Plasma Theme: $PLASMA_THEME"
echo "  Window Decoration: $WINDOW_DECORATION"
echo "  Icon Theme: $ICON_THEME"
echo "  Cursor Theme: $CURSOR_THEME"
echo "  Splash Screen: $SPLASH_SCREEN"

# Create directory structure
echo ""
echo -e "${YELLOW}Creating theme directory structure...${NC}"
mkdir -p "$THEME_DIR/contents"
mkdir -p "$THEME_DIR/contents/splash"
mkdir -p "$THEME_DIR/contents/previews"
mkdir -p "$THEME_DIR/contents/layouts"

# Create metadata.json
echo -e "${YELLOW}Generating metadata.json...${NC}"
cat > "$THEME_DIR/metadata.json" << EOF
{
    "KPackageStructure": "Plasma/LookAndFeel",
    "KPlugin": {
        "Authors": [
            {
                "Email": "$USER@localhost",
                "Name": "$USER"
            }
        ],
        "Category": "",
        "Description": "Custom saved theme - $THEME_NAME",
        "Id": "$THEME_ID",
        "License": "GPLv2+",
        "Name": "$THEME_NAME",
        "Website": ""
    }
}
EOF

# Create defaults file with current settings
echo -e "${YELLOW}Creating defaults configuration...${NC}"
cat > "$THEME_DIR/contents/defaults" << EOF
[kdeglobals][KDE]
widgetStyle=Breeze

[kdeglobals][General]
ColorScheme=$COLOR_SCHEME

[kdeglobals][Icons]
Theme=$ICON_THEME

[plasmarc][Theme]
name=$PLASMA_THEME

[kcminputrc][Mouse]
cursorTheme=$CURSOR_THEME

[kwinrc][org.kde.kdecoration2]
theme=$WINDOW_DECORATION

[ksplashrc][KSplash]
Theme=$SPLASH_SCREEN
Engine=KSplashQML
EOF

# Create a simple layouts file
cat > "$THEME_DIR/contents/layouts/org.kde.plasma.desktop-layout.js" << 'EOF'
var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "config": {
                "/": {
                    "ItemGeometries-1920x1080": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ]
};

plasma.loadSerializedLayout(layout);
EOF

# Try to create a simple preview image (just a colored rectangle as placeholder)
# In practice, you might want to take a screenshot instead
echo -e "${YELLOW}Creating preview placeholder...${NC}"
if command -v convert &> /dev/null; then
    convert -size 400x250 xc:#31363b -pointsize 30 -fill white -gravity center \
            -annotate +0+0 "$THEME_NAME" "$THEME_DIR/contents/previews/preview.png" 2>/dev/null || \
            touch "$THEME_DIR/contents/previews/preview.png"
else
    touch "$THEME_DIR/contents/previews/preview.png"
fi

echo ""
echo -e "${GREEN}✓ Global theme created successfully!${NC}"
echo ""
echo "Theme ID: $THEME_ID"
echo "Location: $THEME_DIR"
echo ""
echo "To apply this theme:"
echo "  1. Open System Settings"
echo "  2. Go to Appearance > Global Theme"
echo "  3. Look for '$THEME_NAME' in the list"
echo "  4. Click 'Apply'"
echo ""
echo "To share this theme:"
echo "  cd $LOOK_AND_FEEL_DIR"
echo "  tar czf ${THEME_ID}.tar.gz $THEME_ID/"
