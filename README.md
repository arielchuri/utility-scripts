# Utility Scripts

A collection of useful shell and Python scripts for various tasks.

## Authorship

- **fetchurls** - Created by [Adam DeHaven](https://www.adamdehaven.com) ([GitHub](https://github.com/adamdehaven/fetchurls))
- **Other scripts** - Various authors (see individual script headers for details)

## Scripts Overview

| Script | Help Support | Description |
|--------|-------------|-------------|
| fetchurls | ✓ `-h`, `--help` | Spider websites and fetch URLs with filtering |
| generate_md_toc | ✓ `-h`, `--help` | Simple Markdown TOC generator |
| mdtoc | ✓ `-h`, `--help` | Generate/insert table of contents in Markdown files |
| palette | ✓ `-h`, `--help` | Save, load, and display color palettes |
| prettycsv | ✓ `-h`, `--help` | Format and display CSV files in terminal |
| rename-spaces | ✓ `-h`, `--help` | Rename files by replacing spaces with underscores |

## Detailed Documentation

### fetchurls

**Help**: Run `./fetchurls -h` or `./fetchurls --help`

A bash script to spider a site, follow links, and fetch URLs with built-in filtering into a generated text file.

**Features:**
- Recursively crawls websites
- Filters URLs by file extension
- Supports authentication
- Configurable sleep delays between requests
- Can ignore robots.txt
- Interactive and non-interactive modes

**Basic Usage:**
```bash
# Interactive mode
./fetchurls

# Non-interactive with options
./fetchurls --domain https://example.com --location ~/Desktop --filename example-urls
```

**Common Options:**
- `-d, --domain` - The fully qualified domain URL to crawl
- `-l, --location` - Directory to save results (default: ~/Desktop)
- `-f, --filename` - Name of output file
- `-e, --exclude` - Pipe-delimited list of file extensions to exclude
- `-s, --sleep` - Seconds to wait between retrievals
- `-u, --username` - Username for authentication
- `-p, --password` - Password for authentication
- `-n, --non-interactive` - Run without prompts
- `-i, --ignore-robots` - Ignore robots.txt
- `-v, --version` - Show version info

**Requirements:** wget must be installed

**Note:** This is an external tool created by Adam DeHaven. See the [original repository](https://github.com/adamdehaven/fetchurls) for more information and examples.

---

### rename-spaces

**Help**: Run `./rename-spaces -h` or `./rename-spaces --help`

Renames files by replacing all spaces in filenames with underscores. Directory paths are preserved.

**Usage:**
```bash
./rename-spaces "file with spaces.txt"
./rename-spaces "file 1.txt" "file 2.txt"
./rename-spaces "/path/to/file with spaces.pdf"
```

**Features:**
- Processes multiple files at once
- Preserves directory paths
- Skips files if target name already exists
- Skips files with no spaces in the name

---

### mdtoc

**Help**: Run `./mdtoc -h` or `./mdtoc --help`

Generate or insert a table of contents for Markdown files using fzf for file selection.

**Usage:**
```bash
# Insert/update ToC in file
./mdtoc --insert
./mdtoc -i

# Print ToC to console (uses glow, bat, or less)
./mdtoc --print
./mdtoc -p
```

**Features:**
- Interactive file selection via fzf
- Automatically removes old ToC before inserting new one
- Creates anchors from headings
- Logs updates to ~/Dropbox/notes/computing/log.md
- Pretty printing with glow, bat, or less

**Requirements:** fzf, optionally glow or bat for better output

---

### palette

**Help**: Run `./palette -h` or `./palette --help`

A color palette tool to save, load, and display color palettes in terminal or browser.

**Usage:**
```bash
# Save palette with backgrounds
palette save colors.txt "#6C5CE7" "#A29BFE" --bg-dark "#000" --bg-light "#fff"

# Show palette in terminal (uses saved backgrounds)
palette show colors.txt

# Override backgrounds temporarily
palette show colors.txt --bg-dark "#1a1a2e"

# View in browser
palette web colors.txt

# Add more colors (preserves backgrounds)
palette add colors.txt "#00B894"
```

**Example File:**

See [examples/colors.txt](examples/colors.txt) for a sample palette file with background colors defined.

**Commands:**
- `save <file> <colors...> [OPTIONS]` - Save colors to file
- `show <file> [OPTIONS]` - Display palette in terminal with ANSI colors
- `web <file> [OPTIONS]` - Open palette in browser as HTML
- `add <file> <colors...>` - Add colors to existing file

**Options:**
- `--bg-dark HEX` - Background color for dark mode (default: #000000)
- `--bg-light HEX` - Background color for light mode (default: #FFFFFF)

**File Format:**
```
bg-dark: #1a1a2e
bg-light: #f5f5f5

#6C5CE7
#A29BFE
#FF6B9D
```

---

### generate_md_toc

**Help**: Run `./generate_md_toc -h` or `./generate_md_toc --help`

A simple script that generates a table of contents from Markdown headings.

**Usage:**
```bash
./generate_md_toc file.md
```

**Output:**
- Extracts headings (lines starting with `#`)
- Converts to Markdown list with anchor links
- Prints to stdout

**Example:**

Input: [examples/sample.md](examples/sample.md)

Output: [examples/toc-output.md](examples/toc-output.md)

```
  - [Sample Document](#sample-document)
  - [Introduction](#introduction)
  - [Background](#background)
  - [Motivation](#motivation)
  - [Methods](#methods)
  ...
```

---

### prettycsv

**Help**: Run `./prettycsv -h` or `./prettycsv --help`

Format and display CSV files in a readable column format using less.

**Usage:**
```bash
./prettycsv file.csv
cat data.csv | ./prettycsv
```

**Features:**
- Aligns columns for readability
- Handles empty fields
- Uses less for pagination with:
  - `-F` - Quit if one screen
  - `-S` - Chop long lines (no wrap)
  - `-X` - No screen clear on exit
  - `-K` - Exit on Ctrl-C

**Example:**

Input: [examples/sample.csv](examples/sample.csv)

Output: [examples/prettycsv-output.txt](examples/prettycsv-output.txt)

```
Name           Age  City           Occupation
Alice Johnson  28   New York       Software Engineer
Bob Smith      35   San Francisco  Data Scientist
Carol White    42   Boston         Project Manager
```

**Requirements:** perl, column, less

---

## Installation

1. Clone or download the scripts to a directory
2. Make scripts executable:
   ```bash
   chmod +x fetchurls generate_md_toc mdtoc palette prettycsv rename-spaces
   ```
3. Optionally add the directory to your PATH:
   ```bash
   export PATH="$PATH:/path/to/bin"
   ```

## Help Support Summary

**All scripts now support `-h` and `--help` flags!**

Simply run any script with `-h` or `--help` to see detailed usage information:

```bash
./fetchurls --help
./generate_md_toc -h
./mdtoc --help
./palette -h
./prettycsv --help
./rename-spaces -h
```

The `fetchurls` script also supports `-?` as an alternative help flag.
