require "fileutils"
require "mini_exiftool"

SOURCE_DIR = ARGV[0] || abort("Usage: ruby organize_photos.rb <source_directory> <destination_directory> [--dry-run] [--force]")
DEST_DIR = ARGV[1] || abort("Usage: ruby organize_photos.rb <source_directory> <destination_directory> [--dry-run] [--force]")
DRY_RUN = ARGV.include?("--dry-run")
FORCE_OVERWRITE = ARGV.include?("--force")

# Ensure the destination directory exists (except in dry run mode)
FileUtils.mkdir_p(DEST_DIR) unless DRY_RUN

Dir.glob(File.join(SOURCE_DIR, "*")).each do |file|
  next if File.directory?(file) # Skip directories

  begin
    # Extract capture date from EXIF metadata
    exif = MiniExiftool.new(file)
    capture_date = exif.date_time_original || exif.create_date

    # Fallback: Use file modification time if EXIF date is unavailable
    capture_date ||= File.mtime(file)

    raise "No valid date found" unless capture_date

    # Format folder structure to match Lightroom Classic
    year  = capture_date.strftime("%Y")
    month = capture_date.strftime("%m") # Two-digit month
    day   = capture_date.strftime("%Y-%m-%d")

    target_folder = File.join(DEST_DIR, year, month, day)
    target_path   = File.join(target_folder, File.basename(file))

    overwrite = File.exist?(target_path) && FORCE_OVERWRITE

    if DRY_RUN
      puts "[DRY RUN] Would move: #{file} -> #{target_path} (overwrite: #{overwrite})"
    else
      FileUtils.mkdir_p(target_folder)
      if overwrite
        FileUtils.mv(file, target_path, force: true)
        puts "Moved: #{file} -> #{target_path} (overwritten)"
      elsif !File.exist?(target_path)
        FileUtils.mv(file, target_path)
        puts "Moved: #{file} -> #{target_path}"
      else
        puts "Skipping (already exists): #{file}"
      end
    end

  rescue => e
    puts "Skipping #{file}: #{e.message}"
  end
end

puts "Organizing complete!#{' (Dry Run Mode)' if DRY_RUN}"
