#!/usr/bin/env python3
"""
firefox-tabs.py - Read and list all currently open Firefox tabs on macOS.
"""

import os
import sys
import glob
import json
import struct

try:
    import lz4.block
except ImportError:
    print("Installing required library 'lz4'...")
    import subprocess
    subprocess.run([sys.executable, "-m", "pip", "install", "lz4", "--quiet"], check=True)
    import lz4.block

def get_open_tabs():
    profile_dirs = glob.glob(os.path.expanduser('~/Library/Application Support/Firefox/Profiles/*.default-release'))
    if not profile_dirs:
        print("Error: Firefox profile directory not found.")
        sys.exit(1)

    session_file = os.path.join(profile_dirs[0], 'sessionstore-backups', 'recovery.jsonlz4')
    if not os.path.exists(session_file):
        print(f"Error: Session recovery file not found at {session_file}")
        sys.exit(1)

    with open(session_file, 'rb') as f:
        magic = f.read(8)
        if magic != b'mozLz40\x00':
            print("Error: Unsupported session file format.")
            sys.exit(1)
        uncompressed_len = struct.unpack('<I', f.read(4))[0]
        compressed_data = f.read()

    decompressed = lz4.block.decompress(compressed_data, uncompressed_size=uncompressed_len)
    js = json.loads(decompressed)

    tabs = []
    for win in js.get('windows', []):
        for tab in win.get('tabs', []):
            idx = tab.get('index', 1) - 1
            entries = tab.get('entries', [])
            if entries and idx < len(entries):
                title = entries[idx].get('title', 'No Title')
                url = entries[idx].get('url', '')
                tabs.append((title, url))

    return tabs

def main():
    tabs = get_open_tabs()
    print(f"Total Open Firefox Tabs: {len(tabs)}\n")
    for i, (t, u) in enumerate(tabs, 1):
        print(f"{i:2d}. {t}\n    URL: {u}\n")

if __name__ == "__main__":
    main()
