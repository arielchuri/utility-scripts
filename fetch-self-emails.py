#!/usr/bin/env python3
"""
fetch-self-emails.py - Extract links from self-sent emails for Ariel Churi:
1. Emails to music@sparklelabs.com -> knowledge/_Memory/notes/media/playlist.md
2. Emails to ariel@sparklelabs.com -> tasks/mailtoself.md
Deletes processed emails from IONOS IMAP.
"""

import os
import re
import sys
import html
import email
import imaplib
from email.header import decode_header

# Configuration
IMAP_SERVER = os.getenv("IMAP_SERVER", "imap.ionos.com")
IMAP_PORT = int(os.getenv("IMAP_PORT", "993"))
EMAIL_ACCOUNT = os.getenv("EMAIL_ACCOUNT", "ariel@sparklelabs.com")
PASSWORD = os.getenv("APP_PASSWORD", "Cj#n23Y;x3")

MAILTOSELF_FILE = os.getenv("MAILTOSELF_FILE", "/Users/arielchuri/Life/tasks/mailtoself.md")
PLAYLIST_FILE = os.getenv("PLAYLIST_FILE", "/Users/arielchuri/Life/knowledge/_Memory/notes/media/playlist.md")

ALLOWED_SENDERS = [
    "ariel@sparklelabs.com",
    "ariel.churi@gmail.com",
    "arielchuri@gmail.com"
]

URL_REGEX = re.compile(r'https?://[^\s>"\']+')

def decode_str(header_str):
    if not header_str:
        return ""
    decoded_parts = decode_header(header_str)
    result = ""
    for bytes_or_str, encoding in decoded_parts:
        if isinstance(bytes_or_str, bytes):
            result += bytes_or_str.decode(encoding or "utf-8", errors="replace")
        else:
            result += str(bytes_or_str)
    return result

def get_email_body(msg):
    body = ""
    if msg.is_multipart():
        for part in msg.walk():
            content_type = part.get_content_type()
            content_disposition = str(part.get("Content-Disposition"))
            if content_type in ["text/plain", "text/html"] and "attachment" not in content_disposition:
                try:
                    payload = part.get_payload(decode=True)
                    if payload:
                        charset = part.get_content_charset() or "utf-8"
                        body += payload.decode(charset, errors="replace")
                except Exception:
                    pass
    else:
        try:
            payload = msg.get_payload(decode=True)
            if payload:
                charset = msg.get_content_charset() or "utf-8"
                body = payload.decode(charset, errors="replace")
        except Exception:
            pass
    return body

def process_emails():
    print(f"Connecting to {IMAP_SERVER} for {EMAIL_ACCOUNT}...")
    try:
        mail = imaplib.IMAP4_SSL(IMAP_SERVER, IMAP_PORT)
        mail.login(EMAIL_ACCOUNT, PASSWORD)
        mail.select("INBOX")
    except Exception as e:
        print(f"IMAP Connection Error: {e}")
        sys.exit(1)

    status, messages = mail.search(None, 'UNSEEN')
    if status != 'OK' or not messages[0]:
        status, messages = mail.search(None, 'ALL')
        if status != 'OK' or not messages[0]:
            print("No emails found in INBOX.")
            mail.logout()
            return

    msg_nums = messages[0].split()
    print(f"Scanning {len(msg_nums)} emails in INBOX...")

    mailtoself_links = []
    music_links = []
    processed_msg_nums = []

    for num in msg_nums:
        res, data = mail.fetch(num, '(RFC822)')
        if res != 'OK' or not data or not data[0]:
            continue

        raw_email = data[0][1]
        if not raw_email or not isinstance(raw_email, bytes):
            continue

        msg = email.message_from_bytes(raw_email)

        from_header = decode_str(msg.get("From", "")).lower()
        to_header = decode_str(msg.get("To", "")).lower()

        is_allowed_sender = any(addr in from_header for addr in ALLOWED_SENDERS)

        if is_allowed_sender:
            subject = decode_str(msg.get("Subject", "No Subject")).strip()
            body = get_email_body(msg)
            
            urls = URL_REGEX.findall(body)
            clean_urls = list(dict.fromkeys([html.unescape(u).rstrip(".,;") for u in urls]))

            date_str = email.utils.formatdate(localtime=True)[:16]

            # Route 1: music@sparklelabs.com -> playlist.md
            if "music@sparklelabs.com" in to_header:
                if clean_urls:
                    for url in clean_urls:
                        music_links.append((subject, url, date_str))
                elif subject:
                    music_links.append((subject, None, date_str))
                processed_msg_nums.append(num)

            # Route 2: ariel@sparklelabs.com -> mailtoself.md
            elif "ariel@sparklelabs.com" in to_header:
                if clean_urls:
                    for url in clean_urls:
                        mailtoself_links.append((subject, url, date_str))
                elif subject:
                    mailtoself_links.append((subject, None, date_str))
                processed_msg_nums.append(num)

    # Write to mailtoself.md
    if mailtoself_links:
        os.makedirs(os.path.dirname(MAILTOSELF_FILE), exist_ok=True)
        file_exists = os.path.exists(MAILTOSELF_FILE)
        with open(MAILTOSELF_FILE, "a", encoding="utf-8") as f:
            if not file_exists:
                f.write("# Self-Sent Email Links\n\n")
            for subj, url, dt in mailtoself_links:
                if url:
                    f.write(f"- [ ] [{subj}]({url}) (added {dt})\n")
                else:
                    f.write(f"- [ ] {subj} (added {dt})\n")
        print(f"Extracted {len(mailtoself_links)} links into {MAILTOSELF_FILE}")

    # Write to playlist.md
    if music_links:
        os.makedirs(os.path.dirname(PLAYLIST_FILE), exist_ok=True)
        file_exists = os.path.exists(PLAYLIST_FILE)
        with open(PLAYLIST_FILE, "a", encoding="utf-8") as f:
            if not file_exists:
                f.write("# Music Playlist Links\n\n")
            for subj, url, dt in music_links:
                if url:
                    f.write(f"- [{subj}]({url}) (added {dt})\n")
                else:
                    f.write(f"- {subj} (added {dt})\n")
        print(f"Extracted {len(music_links)} music links into {PLAYLIST_FILE}")

    # Delete & Expunge processed emails
    if processed_msg_nums:
        for num in processed_msg_nums:
            mail.store(num, '+FLAGS', '\\Deleted')
        mail.expunge()
        print(f"Deleted {len(processed_msg_nums)} processed emails from INBOX.")
    else:
        print("No new target emails processed.")

    mail.logout()

if __name__ == "__main__":
    process_emails()
