# Photo Organiser

A Ruby script that automatically organises photos by date into a Lightroom Classic-friendly folder structure. Perfect for organising Lightroom exports or any collection of photos. **Copies files by default** to keep your originals safe.

## Features

- 📅 **Date-based organisation**: Uses EXIF metadata to determine capture date
- 📁 **Lightroom Classic structure**: Creates `YYYY/MM/YYYY-MM-DD` folder hierarchy
- 🔒 **Safe by default**: Copies files instead of moving them (preserves originals)
- 🔄 **Flexible operation**: Option to move files if desired
- 🔍 **Smart fallback**: Uses file modification time when EXIF data is unavailable
- 🧪 **Dry run mode**: Preview changes before applying them
- 🔄 **Flexible overwrite**: Option to overwrite existing files
- 📊 **Progress tracking**: Shows real-time progress and summary statistics
- 🎯 **Format support**: Works with JPEG, TIFF, RAW files, and more

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/lylo/photo-organiser.git
   cd photo-organiser
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Install ExifTool** (required for reading photo metadata):
   ```bash
   # macOS
   brew install exiftool

   # Ubuntu/Debian
   sudo apt-get install libimage-exiftool-perl

   # Other systems: https://exiftool.org/install.html
   ```

4. **You're ready to go!** Run the script with:
   ```bash
   bundle exec ruby photo-organiser.rb --help
   ```

## Usage

### Basic Usage

```bash
bundle exec ruby photo-organiser.rb <source_directory> <destination_directory>
```

### Recommended Workflow for Large Photo Libraries

If you have a large photo collection (1000+ photos per year), it's recommended to organise by year to avoid performance issues and make the process more manageable:

1. **In Adobe Lightroom (Cloud)**: Export photos one year at a time
   - Filter your library by year (e.g., 2024)
   - Export all photos from that year to a temporary folder (e.g., `~/Photos/Export/2024`)
   - Repeat for each year

2. **Run the organiser for each year**:
   ```bash
   # Copy photos (safe, preserves originals)
   bundle exec ruby photo-organiser.rb ~/Photos/Export/2024 ~/Photos/Organised --dry-run
   bundle exec ruby photo-organiser.rb ~/Photos/Export/2024 ~/Photos/Organised

   # Or move photos if you want to clean up the export folder
   bundle exec ruby photo-organiser.rb ~/Photos/Export/2024 ~/Photos/Organised --move --dry-run
   bundle exec ruby photo-organiser.rb ~/Photos/Export/2024 ~/Photos/Organised --move
   ```

3. **Clean up**: Remove the temporary export folders after successful organisation

This approach:
- **Reduces memory usage** when processing large batches
- **Makes progress tracking** more meaningful
- **Allows for easier troubleshooting** if issues arise
- **Enables incremental organisation** of your photo library

### Examples

**Preview changes (dry run):**
```bash
bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised --dry-run
```

**Copy photos to organised structure (default, safe):**
```bash
bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised
```

**Move photos instead of copying:**
```bash
bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised --move
```

**Copy with overwrite protection off:**
```bash
bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised --force
```

### Command Line Options

| Option | Description |
|--------|-------------|
| `--copy` | Copy files to destination (default) |
| `--move` | Move files to destination instead of copying |
| `--dry-run` | Show what would be done without actually doing it |
| `--force` | Overwrite existing files in destination |
| `--help`, `-h` | Show help message |
| `--version`, `-v` | Show version information |

## Folder Structure

The script organizes photos into this structure:

```
destination/
├── 2024/
│   ├── 01/
│   │   ├── 2024-01-15/
│   │   │   ├── IMG_001.jpg
│   │   │   └── IMG_002.jpg
│   │   └── 2024-01-20/
│   │       └── IMG_003.jpg
│   └── 02/
│       └── 2024-02-10/
│           └── IMG_004.jpg
└── 2025/
    └── 03/
        └── 2025-03-05/
            └── IMG_005.jpg
```

This structure is compatible with:
- **Adobe Lightroom Classic** import organisation
- **Date-based browsing** and searching
- **Backup and archival** systems

## How It Works

1. **Scans** the source directory for all files
2. **Reads EXIF data** to find the original capture date
3. **Falls back** to file modification time if no EXIF date exists
4. **Creates** the destination folder structure (`YYYY/MM/YYYY-MM-DD`)
5. **Copies** files to their appropriate date-based folders (or moves if `--move` specified)
6. **Reports** progress and provides a summary

## Supported File Formats

The script works with any format supported by ExifTool, including:

- **JPEG** (.jpg, .jpeg)
- **TIFF** (.tif, .tiff)
- **RAW formats** (.cr2, .nef, .arw, .dng, etc.)
- **PNG** (.png)
- **Many others**

## Error Handling

The script gracefully handles:
- Files without EXIF data (uses modification time)
- Corrupted or unreadable files (skips with error message)
- Existing files in destination (skips unless `--force` is used)
- Missing directories (creates them automatically)

## Requirements

- **Ruby** 2.5 or later
- **ExifTool** installed on your system
- **mini_exiftool** gem

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on how to submit pull requests, report issues, and contribute to the project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

## Acknowledgments

- Built with [mini_exiftool](https://github.com/janfri/mini_exiftool) gem
- Uses [ExifTool](https://exiftool.org/) by Phil Harvey
- Inspired by Adobe Lightroom Classic's folder organisation

## Troubleshooting

### "ExifTool not found" error
Make sure ExifTool is installed and available in your PATH:
```bash
# Check if ExifTool is installed
exiftool -ver

# Install on macOS
brew install exiftool

# Install on Ubuntu/Debian
sudo apt-get install libimage-exiftool-perl
```

### Permission errors
Make sure you have read access to source directory and write access to destination directory.

### "No valid date found" errors
Some files may not have EXIF data or valid modification times. The script will skip these files and report them in the summary.
