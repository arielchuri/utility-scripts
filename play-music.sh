#!/usr/bin/env bash
#
# play-music.sh - Stream music audio-only in terminal via mpv from YouTube or Bandcamp
#

RECENT=""

if [ "$1" = "--recent" ] || [ "$1" = "-r" ]; then
  RECENT="yes"
  shift
fi

if [ -z "$1" ]; then
  echo "Usage: $(basename "$0") [--recent|-r] <search query or URL>"
  exit 1
fi

QUERY="$*"

if [[ "$QUERY" =~ bandcamp\.com ]]; then
  STREAM_URL=$(curl -s "$QUERY" | grep -o 'https://t[0-9]*\.bcbits\.com/stream/[^"]*' | head -n 1 | sed 's/&amp;/&/g' | sed 's/&quot;.*//')
  if [ -z "$STREAM_URL" ]; then
    echo "Error extracting Bandcamp stream URL."
    exit 1
  fi
  exec mpv --no-video "$STREAM_URL"
elif [[ "$QUERY" =~ ^https?:// ]]; then
  STREAM_URL=$(yt-dlp -f "ba/b" --extractor-args "youtube:player_client=android,web" -g "$QUERY")
  exec mpv --no-video --user-agent="Android" "$STREAM_URL"
else
  TARGET="ytsearch:$QUERY"
  YTDL_FLAGS=(-f "ba/b" --extractor-args "youtube:player_client=android,web")

  if [ -n "$RECENT" ]; then
    CUTOFF_DATE=$(date -v-1y +%Y%m%d)
    YTDL_FLAGS+=(--dateafter "$CUTOFF_DATE")
  fi

  STREAM_URL=$(yt-dlp "${YTDL_FLAGS[@]}" -g "$TARGET" 2>/dev/null)

  # Fallback if no upload found after date cutoff
  if [ -z "$STREAM_URL" ] && [ -n "$RECENT" ]; then
    echo "No uploads found within the past year. Searching without date restriction..."
    STREAM_URL=$(yt-dlp -f "ba/b" --extractor-args "youtube:player_client=android,web" -g "$TARGET")
  fi

  if [ -z "$STREAM_URL" ]; then
    echo "Error: Could not retrieve YouTube stream URL."
    exit 1
  fi

  exec mpv --no-video --user-agent="Android" "$STREAM_URL"
fi
