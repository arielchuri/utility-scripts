#!/usr/bin/env python3
"""
make-booklet - Generate a 2-up imposed booklet PDF for duplex printing and center-stapling.
"""

import sys
import os
import subprocess

def install_pypdf():
    subprocess.run([sys.executable, "-m", "pip", "install", "pypdf", "--quiet"], check=True)

try:
    import pypdf
except ImportError:
    print("Installing required library 'pypdf'...")
    install_pypdf()
    import pypdf

from pypdf import PdfReader, PdfWriter, PageObject

def create_booklet(input_pdf_path, output_pdf_path=None):
    if not os.path.exists(input_pdf_path):
        print(f"Error: File '{input_pdf_path}' not found.")
        sys.exit(1)

    if not output_pdf_path:
        base, ext = os.path.splitext(input_pdf_path)
        output_pdf_path = f"{base}_booklet.pdf"

    reader = PdfReader(input_pdf_path)
    total_orig_pages = len(reader.pages)
    
    remainder = total_orig_pages % 4
    padded_pages = total_orig_pages if remainder == 0 else total_orig_pages + (4 - remainder)

    print(f"Input PDF: {total_orig_pages} pages.")
    if padded_pages != total_orig_pages:
        print(f"Padding to {padded_pages} pages (nearest multiple of 4 for a folded booklet).")

    orig_pages = list(reader.pages)
    first_page_rect = reader.pages[0].mediabox
    page_w = float(first_page_rect.width)
    page_h = float(first_page_rect.height)

    # Pad with blank pages up to padded_pages
    pages = []
    for i in range(padded_pages):
        if i < total_orig_pages:
            pages.append(orig_pages[i])
        else:
            pages.append(PageObject.create_blank_page(width=page_w, height=page_h))

    sheets = padded_pages // 4
    writer = PdfWriter()

    for i in range(sheets):
        # Imposition Indices (0-based)
        left_idx_front = padded_pages - 1 - (2 * i)
        right_idx_front = 2 * i

        left_idx_back = 2 * i + 1
        right_idx_back = padded_pages - 1 - (2 * i + 1)

        # Build Front Sheet
        front_sheet = writer.add_blank_page(width=page_w * 2, height=page_h)
        front_sheet.merge_transformed_page(pages[left_idx_front], pypdf.Transformation().translate(tx=0, ty=0))
        front_sheet.merge_transformed_page(pages[right_idx_front], pypdf.Transformation().translate(tx=page_w, ty=0))

        # Build Back Sheet
        back_sheet = writer.add_blank_page(width=page_w * 2, height=page_h)
        back_sheet.merge_transformed_page(pages[left_idx_back], pypdf.Transformation().translate(tx=0, ty=0))
        back_sheet.merge_transformed_page(pages[right_idx_back], pypdf.Transformation().translate(tx=page_w, ty=0))

    with open(output_pdf_path, "wb") as f:
        writer.write(f)

    print(f"\nBooklet generated successfully: {output_pdf_path}")
    print("\n--- Printing Instructions ---")
    print("1. Open the generated booklet PDF.")
    print("2. Print Duplex (Double-sided) with flip/binding set to 'Short Edge' (Short-edge binding).")
    print("3. Fold down the middle and staple!")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: make-booklet <input.pdf> [output_booklet.pdf]")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    create_booklet(input_file, output_file)
