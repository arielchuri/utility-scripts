#!/usr/bin/env bash
#
# play-playlist.sh - Stream links from knowledge/_Memory/notes/media/playlist.md or playlist.txt via play-music.sh
#

PLAYLIST_MD="/Users/arielchuri/Life/knowledge/_Memory/notes/media/playlist.md"
PLAYLIST_TXT="/Users/arielchuri/Life/playlist.txt"

LINKS=()

# Extract links from playlist.md if available
if [ -f "$PLAYLIST_MD" ]; then
  while IFS= read -r line; do
    url=$(echo "$line" | grep -o 'https://[^\s)"]*')
    if [ -n "$url" ]; then
      LINKS+=("$url")
    fi
  done < "$PLAYLIST_MD"
fi

# Fallback to playlist.txt if playlist.md has no links
if [ ${#LINKS[@]} -eq 0 ] && [ -f "$PLAYLIST_TXT" ]; then
  while IFS= read -r line; do
    if [[ "$line" =~ ^https?:// ]] || [[ "$line" =~ ^ytdl:// ]]; then
      LINKS+=("$line")
    fi
  done < "$PLAYLIST_TXT"
fi

if [ ${#LINKS[@]} -eq 0 ]; then
  echo "No music links found in $PLAYLIST_MD or $PLAYLIST_TXT."
  exit 1
fi

echo "Starting playback for ${#LINKS[@]} tracks..."
for link in "${LINKS[@]}"; do
  echo "Playing: $link"
  /Users/arielchuri/Life/tools/bin/play-music.sh "$link"
done
