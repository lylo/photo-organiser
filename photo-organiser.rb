#!/usr/bin/env ruby
# Photo Organiser - Organise photos by date into Lightroom Classic-friendly structure
# MIT License - See LICENSE file for details

require 'fileutils'
require 'mini_exiftool'
require 'optparse'

def show_help
  puts <<~HELP
    Photo Organiser v1.1.0
    =====================

    Organise photos by date into a Lightroom Classic-friendly folder structure.
    Reads EXIF metadata to determine capture date and creates folders in YYYY/MM/YYYY-MM-DD format.

    USAGE
      bundle exec ruby photo-organiser.rb <source_directory> <destination_directory> [options]

    ARGUMENTS
      source_directory      Directory containing photos to organise
      destination_directory Directory where organised photos will be placed

    OPTIONS
      --copy               Copy files to destination (default)
      --move               Move files to destination instead of copying
      --dry-run            Show what would be done without actually doing it
      --force              Overwrite existing files in destination
      --help, -h           Show this help message
      --version, -v        Show version information

    EXAMPLES
      # Organise photos with dry run to preview changes
      bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised --dry-run

      # Copy photos to organised structure (default behaviour)
      bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised

      # Move photos instead of copying
      bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised --move

      # Copy and overwrite existing files
      bundle exec ruby photo-organiser.rb ~/Photos/Export ~/Photos/Organised --force

    FOLDER STRUCTURE
      The script creates folders in this structure:
      destination/
      ├── 2024/
      │   ├── 01/
      │   │   ├── 2024-01-15/
      │   │   └── 2024-01-20/
      │   └── 02/
      │       └── 2024-02-10/
      └── 2025/
          └── 03/
              └── 2025-03-05/

    SUPPORTED FORMATS
      Any format supported by MiniExiftool (JPEG, TIFF, RAW files, etc.)
      Falls back to file modification time if EXIF data is unavailable.
  HELP
end

def show_version
  puts 'Photo Organiser v1.1.0'
  puts 'MIT License'
end

# Parse command line arguments
options = {}
OptionParser.new do |opts|
  opts.on('--copy', 'Copy files to destination (default)') do
    options[:copy] = true
  end

  opts.on('--move', 'Move files to destination instead of copying') do
    options[:move] = true
  end

  opts.on('--dry-run', 'Show what would be done without actually doing it') do
    options[:dry_run] = true
  end

  opts.on('--force', 'Overwrite existing files in destination') do
    options[:force] = true
  end

  opts.on('-h', '--help', 'Show help message') do
    show_help
    exit
  end

  opts.on('-v', '--version', 'Show version') do
    show_version
    exit
  end
end.parse!

# Check for required arguments
if ARGV.length < 2
  puts "Error: Missing required arguments\n\n"
  show_help
  exit 1
end

# Check for conflicting options
if options[:copy] && options[:move]
  puts "Error: Cannot specify both --copy and --move\n\n"
  show_help
  exit 1
end

SOURCE_DIR = ARGV[0]
DEST_DIR = ARGV[1]
DRY_RUN = options[:dry_run] || false
FORCE_OVERWRITE = options[:force] || false
MOVE_FILES = options[:move] || false # Default to copy unless --move specified

# Validate directories
unless File.directory?(SOURCE_DIR)
  puts "Error: Source directory '#{SOURCE_DIR}' does not exist or is not a directory"
  exit 1
end

# Ensure the destination directory exists (except in dry run mode)
FileUtils.mkdir_p(DEST_DIR) unless DRY_RUN

puts "Source: #{SOURCE_DIR}"
puts "Destination: #{DEST_DIR}"
puts "Mode: #{DRY_RUN ? 'DRY RUN' : 'LIVE'}"
puts "Operation: #{MOVE_FILES ? 'MOVE' : 'COPY'}"
puts "Force overwrite: #{FORCE_OVERWRITE ? 'YES' : 'NO'}"
puts '=' * 50

# Get all files (not directories) from source
files = Dir.glob(File.join(SOURCE_DIR, '*')).select { |f| File.file?(f) }
puts "Found #{files.length} files to process\n\n"

processed = 0
skipped = 0
errors = 0

files.each_with_index do |file, index|
  # Show progress
  print "\rProcessing #{index + 1}/#{files.length}: #{File.basename(file)}"

  # Extract capture date from EXIF metadata
  exif = MiniExiftool.new(file)
  capture_date = exif.date_time_original || exif.create_date

  # Fallback: Use file modification time if EXIF date is unavailable
  capture_date ||= File.mtime(file)

  raise 'No valid date found' unless capture_date

  # Format folder structure to match Lightroom Classic
  year  = capture_date.strftime('%Y')
  month = capture_date.strftime('%m') # Two-digit month
  day   = capture_date.strftime('%Y-%m-%d')

  target_folder = File.join(DEST_DIR, year, month, day)
  target_path   = File.join(target_folder, File.basename(file))

  overwrite = File.exist?(target_path) && FORCE_OVERWRITE
  operation = MOVE_FILES ? 'move' : 'copy'

  if DRY_RUN
    puts "\n[DRY RUN] Would #{operation}: #{file} -> #{target_path} (overwrite: #{overwrite})"
    processed += 1
  else
    FileUtils.mkdir_p(target_folder)
    if overwrite
      if MOVE_FILES
        FileUtils.mv(file, target_path, force: true)
        puts "\nMoved: #{file} -> #{target_path} (overwritten)"
      else
        FileUtils.cp(file, target_path)
        puts "\nCopied: #{file} -> #{target_path} (overwritten)"
      end
      processed += 1
    elsif !File.exist?(target_path)
      if MOVE_FILES
        FileUtils.mv(file, target_path)
        puts "\nMoved: #{file} -> #{target_path}"
      else
        FileUtils.cp(file, target_path)
        puts "\nCopied: #{file} -> #{target_path}"
      end
      processed += 1
    else
      puts "\nSkipping (already exists): #{file}"
      skipped += 1
    end
  end
rescue StandardError => e
  puts "\nError processing #{file}: #{e.message}"
  errors += 1
end

puts "\n\n" + '=' * 50
puts 'SUMMARY'
puts '=' * 50
puts "Files processed: #{processed}"
puts "Files skipped: #{skipped}"
puts "Errors: #{errors}"
puts "Total files: #{files.length}"
puts "\nOrganising complete!#{' (Dry Run Mode)' if DRY_RUN}"
