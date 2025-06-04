# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-06-04

### Added
- Copy vs move functionality with `--copy` and `--move` options
- Copy is now the default (safer) behavior - files are copied rather than moved
- Move mode available with `--move` option for users who want the original behavior
- Enhanced progress display showing operation type (COPY vs MOVE)
- Conflict detection prevents specifying both `--copy` and `--move`

### Changed
- Default behavior changed from move to copy for safer operation
- All documentation updated to reflect copy-first approach
- Command examples in help text updated to show both modes

### Fixed
- File operation safety improved with copy-by-default approach

## [1.0.0] - 2025-06-04

### Added
- Initial release of Photo Organiser
- Date-based photo organisation using EXIF metadata
- Lightroom Classic-friendly folder structure (YYYY/MM/YYYY-MM-DD)
- Dry run mode for previewing changes
- Force overwrite option
- Progress tracking and summary statistics
- Comprehensive help and version information
- Smart fallback to file modification time when EXIF unavailable
- British spelling throughout (organise vs organize)
- Bundler support for dependency management
- Support for all ExifTool-compatible formats
- Graceful error handling and detailed logging

### Workflow Features
- Optimised for large photo libraries (1000+ photos per year)
- Year-by-year processing recommendations
- Integration with Adobe Lightroom Cloud export workflow

### Developer Features
- MIT License
- Comprehensive README with examples
- Ruby 2.5+ compatibility
- Bundler support for clean dependency management
- Professional project structure
