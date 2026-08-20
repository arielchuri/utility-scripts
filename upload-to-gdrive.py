#!/usr/bin/env python3
"""
upload-to-gdrive.py - Upload files to Google Drive using rclone or Google Drive API credentials.
"""

import sys
import os
import subprocess

def main():
    if len(sys.argv) < 2:
        print("Usage: upload-to-gdrive.py <path-to-file> [gdrive-folder-name]")
        sys.exit(1)

    file_path = sys.argv[1]
    if not os.path.exists(file_path):
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)

    # Check if rclone is available
    rclone_check = subprocess.run(["which", "rclone"], capture_output=True)
    if rclone_check.returncode == 0:
        target_dir = sys.argv[2] if len(sys.argv) > 2 else ""
        remote_target = f"gdrive:{target_dir}" if target_dir else "gdrive:"
        print(f"Uploading {file_path} to Google Drive ({remote_target})...")
        res = subprocess.run(["rclone", "copy", file_path, remote_target], capture_output=True, text=True)
        if res.returncode == 0:
            print("Upload completed successfully!")
        else:
            print(f"rclone Error: {res.stderr}")
    else:
        print("rclone is not configured yet for automated background sync.")
        print("\n--- Easy Google Drive Options ---")
        print("1. Google Drive for Desktop app (Continuous auto-sync folder)")
        print("2. rclone CLI sync tool")

if __name__ == "__main__":
    main()
