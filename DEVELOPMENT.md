# Development Setup

This document describes how to set up the development environment for working with the Verse documentation.

## Prerequisites

- Python 3.8 or higher
- Node.js (for bin scripts)
- Access to fortniteMain repository

## Verse VM Locations

The scripts in `bin/` require the Verse VMs from the fortniteMain repository. As of the UE6 reorganization, both VMs are now located in `Engine/Binaries/Win64/`:

### TestScript VM (for `.versetest` files)
```
/mnt/c/fortniteMain/Engine/Binaries/Win64/VerseTestScriptCmdVM-Win64-Shipping.exe
```

**Source Project**: `Engine/Source/Programs/VerseTestScriptCmd`

### CLR VM (for `.verse` files)
```
/mnt/c/fortniteMain/Engine/Binaries/Win64/VerseCLRVM-Win64-Shipping.exe
```

## Available Scripts

### Testing

- `bin/vtest <file-or-directory>` - Run Verse tests
  - `--verbose` - Show detailed error messages
  - `--raw` - Show complete VM output

### Code Extraction

- `bin/extract <markdown-file> -t <target-directory>` - Extract Verse snippets from markdown
- `bin/extract_all` - Extract all snippets from all docs

### Compilation

- `bin/compile <directory>` - Compile all .verse files in a directory
