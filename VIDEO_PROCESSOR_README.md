# Video Processing Pipeline

A bash script to automatically process videos through multiple stages: sanitization, UUID tagging, format conversion to h265, and intelligent size optimization.

## Overview

This script processes videos through the following pipeline:

```
0_ARRIVAL → sanitize → add UUID → 1_INBOX → convert to h265 → 2_DONE
```

## Features

- **Automatic Video Detection**: Finds all video files in the arrival folder
- **Filename Sanitization**: Removes problematic characters from filenames
- **UUID Prefix**: Adds unique 8-character identifier to prevent conflicts
- **H.265 Conversion**: Converts videos to efficient h265/HEVC format
- **Intelligent Size Comparison**: Keeps the smaller file (original or converted)
- **Multiple Format Support**: mp4, avi, mov, mkv, flv, wmv, m4v, mpg, mpeg, webm, 3gp
- **Progress Tracking**: Color-coded output with detailed progress information

## Prerequisites

### Required Software

- **ffmpeg**: Used for video conversion
  ```bash
  # Ubuntu/Debian
  sudo apt-get install ffmpeg
  
  # Fedora/RHEL
  sudo dnf install ffmpeg
  
  # macOS
  brew install ffmpeg
  ```

### System Requirements

- Bash 4.0 or later
- Sufficient disk space (conversions can temporarily double space usage)
- Unix-like environment (Linux, macOS, WSL)

## Installation

1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/abraxas678/public/master/process_videos.sh
   ```

2. Make it executable:
   ```bash
   chmod +x process_videos.sh
   ```

## Usage

### Basic Usage

1. Place your video files in the `0_ARRIVAL` folder
2. Run the script:
   ```bash
   ./process_videos.sh
   ```

3. Processed videos will appear in `2_DONE` folder

### Directory Structure

The script creates and uses three directories:

```
.
├── 0_ARRIVAL/          # Input: Place your videos here
├── 1_INBOX/            # Temporary: Sanitized files with UUIDs
├── 2_DONE/             # Output: Processed videos
├── myvideos.txt        # Generated: List of videos from 0_ARRIVAL
└── inbox_videos.txt    # Generated: List of videos from 1_INBOX
```

### Processing Steps

#### Step 1: Create Video List
```
0_ARRIVAL/ → myvideos.txt
```
Scans the arrival folder and creates a list of all video files.

#### Step 2-3: Sanitize and Move
```
0_ARRIVAL/ → [sanitize] → [add UUID] → 1_INBOX/
```
- Removes problematic characters from filenames
- Adds 8-character UUID prefix (e.g., `a1b2c3d4_myvideo.mp4`)
- Moves to inbox folder

#### Step 4: Create Inbox List
```
1_INBOX/ → inbox_videos.txt
```
Creates a list of all videos ready for conversion.

#### Step 5-6: Convert and Optimize
```
1_INBOX/ → [convert to h265] → [compare sizes] → 2_DONE/
```
- Converts videos to h265 format (CRF 23, medium preset)
- Compares file sizes
- Keeps the smaller file (original or converted)
- Moves winner to done folder

## Conversion Settings

The script uses ffmpeg with the following settings:

```bash
ffmpeg -i input.mp4 \
  -c:v libx265 \        # H.265/HEVC video codec
  -crf 23 \             # Quality level (lower = better, 23 = high quality)
  -preset medium \      # Encoding speed/efficiency balance
  -c:a aac \            # AAC audio codec
  -b:a 128k \           # Audio bitrate
  -movflags +faststart  # Web-optimized
```

### Quality Settings Explanation

- **CRF 23**: Near-lossless quality with excellent compression
  - Range: 0-51 (0 = lossless, 23 = high quality, 28 = default, 51 = worst)
- **Preset medium**: Good balance between speed and compression
  - Options: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow

### Customizing Quality

Edit the script to adjust quality/size trade-offs:

```bash
# For smaller files (slight quality loss):
-crf 28 -preset fast

# For maximum quality (larger files):
-crf 18 -preset slow

# For fastest conversion (larger files):
-crf 23 -preset ultrafast
```

## Examples

### Example 1: Processing Personal Videos

```bash
# Add videos to arrival folder
cp ~/Downloads/*.mp4 0_ARRIVAL/

# Run processor
./process_videos.sh

# Check results
ls -lh 2_DONE/
```

### Example 2: Batch Processing

```bash
# Copy videos from multiple sources
cp /media/camera/*.mov 0_ARRIVAL/
cp /media/phone/*.mp4 0_ARRIVAL/

# Process everything
./process_videos.sh

# Videos are now in 2_DONE with optimized size
```

## Output Examples

### During Processing

```
[STEP] STEP 1: Creating video list from 0_ARRIVAL/
[INFO] Found 3 video file(s) in 0_ARRIVAL/

[STEP] STEP 2-3: Processing files - sanitize, add UUID, move to 1_INBOX/
[INFO] Processing: my vacation video.mp4
[INFO]   Sanitized: my vacation video.mp4 -> my_vacation_video.mp4
[INFO]   Moved to: 1_INBOX/a1b2c3d4_my_vacation_video.mp4

[STEP] STEP 5-6: Converting to h265 and moving to 2_DONE/
[INFO] Processing: a1b2c3d4_my_vacation_video.mp4
[INFO]   Original size: 150MB
[INFO]   Converting to h265...
[INFO]   Conversion complete
[INFO]   Converted size: 75MB
[INFO]   Converted file is smaller (saved 50%)
[INFO]   Moving converted file to 2_DONE/
```

### Summary Output

```
[INFO] ============================================
[INFO] Video Processing Complete!
[INFO] ============================================
[INFO] Summary:
[INFO]   - Files processed from 0_ARRIVAL: 3
[INFO]   - Files converted and moved to 2_DONE: 3
[INFO] ============================================
```

## Troubleshooting

### ffmpeg Not Found

```
[ERROR] ffmpeg is not installed. Please install it first:
  Ubuntu/Debian: sudo apt-get install ffmpeg
  Fedora/RHEL: sudo dnf install ffmpeg
```

**Solution**: Install ffmpeg using the appropriate command for your system.

### No Videos Found

```
[WARN] No video files found in 0_ARRIVAL/
Supported formats: mp4 avi mov mkv flv wmv m4v mpg mpeg webm 3gp
```

**Solution**: 
1. Check that videos are in the `0_ARRIVAL` folder
2. Verify file extensions match supported formats
3. Check file permissions

### Conversion Failed

```
[ERROR] Conversion failed for: video.mp4
```

**Solution**:
1. Check if the video file is corrupted
2. Verify sufficient disk space
3. Try opening the video with a media player
4. Check ffmpeg error messages for details

### File Already Exists

```
[WARN] File already exists in INBOX: video.mp4
```

**Solution**: 
1. Remove or rename existing file in 1_INBOX
2. Or move it to another location before reprocessing

## Performance Tips

1. **Disk Space**: Ensure you have at least 2x the size of your video library free
2. **CPU Usage**: h265 encoding is CPU-intensive; expect high CPU usage
3. **Time Estimates**: 
   - Fast preset: ~1x video length
   - Medium preset: ~2-3x video length
   - Slow preset: ~5-10x video length

## Safety Features

- **Non-destructive**: Original files are only deleted after successful conversion
- **Duplicate Detection**: Skips files that already exist in target folders
- **Error Handling**: Continues processing even if individual files fail
- **Progress Tracking**: Detailed logging of all operations

## Advanced Usage

### Processing Specific Formats Only

Edit the `VIDEO_EXTENSIONS` array in the script:

```bash
# Only process MP4 and MOV files
VIDEO_EXTENSIONS=("mp4" "mov")
```

### Changing Directory Names

Edit the directory variables at the top of the script:

```bash
ARRIVAL_DIR="input"
INBOX_DIR="processing"
DONE_DIR="output"
```

### Automated Processing with Cron

Run the script automatically every night:

```bash
# Edit crontab
crontab -e

# Add this line (runs at 2 AM daily)
0 2 * * * /path/to/process_videos.sh >> /var/log/video_processor.log 2>&1
```

## File Naming Convention

After processing, files follow this pattern:

```
[UUID]_[sanitized_name].mp4
```

Examples:
- `a1b2c3d4_vacation_2024.mp4`
- `f5e6d7c8_birthday_party.mp4`
- `9g8h7i6j_conference_talk.mp4`

## Supported Video Formats

| Format | Extension | Notes |
|--------|-----------|-------|
| MP4 | .mp4 | Most common, widely supported |
| AVI | .avi | Legacy format, good compression gain |
| MOV | .mov | Apple QuickTime, excellent for h265 |
| MKV | .mkv | Matroska, supports many codecs |
| FLV | .flv | Flash video, usually compresses well |
| WMV | .wmv | Windows Media Video |
| M4V | .m4v | Similar to MP4 |
| MPEG | .mpg, .mpeg | Older format, good compression gain |
| WebM | .webm | Modern web format |
| 3GP | .3gp | Mobile phone video |

## Contributing

Feel free to submit issues and enhancement requests!

## License

This script is provided as-is for personal and commercial use.

## Author

Part of the [abraxas678/public](https://github.com/abraxas678/public) repository.
