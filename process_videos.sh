#!/bin/bash
set -e -o pipefail

# Video Processing Pipeline
# This script processes videos through multiple stages:
# 0_ARRIVAL -> sanitize -> add UUID -> 1_INBOX -> convert to h265 -> 2_DONE

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }
echo_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# Configuration
ARRIVAL_DIR="0_ARRIVAL"
INBOX_DIR="1_INBOX"
DONE_DIR="2_DONE"
VIDEO_LIST="myvideos.txt"
INBOX_LIST="inbox_videos.txt"

# Video file extensions to process
VIDEO_EXTENSIONS=("mp4" "avi" "mov" "mkv" "flv" "wmv" "m4v" "mpg" "mpeg" "webm" "3gp")

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo_error "ffmpeg is not installed. Please install it first:"
    echo_error "  Ubuntu/Debian: sudo apt-get install ffmpeg"
    echo_error "  Fedora/RHEL: sudo dnf install ffmpeg"
    exit 1
fi

# Function to sanitize filename
sanitize_filename() {
    local filename="$1"
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    
    # Remove or replace problematic characters
    # Keep alphanumeric, dash, underscore, and dot
    basename=$(echo "$basename" | sed 's/[^a-zA-Z0-9._-]/_/g')
    
    # Replace multiple underscores/spaces with single underscore
    basename=$(echo "$basename" | sed 's/__*/_/g')
    
    # Remove leading/trailing underscores
    basename=$(echo "$basename" | sed 's/^_*//;s/_*$//')
    
    echo "${basename}.${extension}"
}

# Function to generate short UUID (8 characters)
generate_short_uuid() {
    cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1
}

# Function to get video file size in bytes
get_file_size() {
    stat -c%s "$1" 2>/dev/null || stat -f%z "$1" 2>/dev/null
}

# Function to format bytes to human readable
format_size() {
    local size=$1
    if [ $size -lt 1024 ]; then
        echo "${size}B"
    elif [ $size -lt 1048576 ]; then
        echo "$(( size / 1024 ))KB"
    elif [ $size -lt 1073741824 ]; then
        echo "$(( size / 1048576 ))MB"
    else
        echo "$(( size / 1073741824 ))GB"
    fi
}

# ============================================================================
# STEP 1: Create list of all videos in 0_ARRIVAL folder
# ============================================================================
echo_step "STEP 1: Creating video list from ${ARRIVAL_DIR}/"
echo

# Create directories if they don't exist
mkdir -p "$ARRIVAL_DIR" "$INBOX_DIR" "$DONE_DIR"

if [ ! -d "$ARRIVAL_DIR" ]; then
    echo_error "Directory ${ARRIVAL_DIR} does not exist!"
    exit 1
fi

# Clear previous list
> "$VIDEO_LIST"

# Find all video files
video_count=0
for ext in "${VIDEO_EXTENSIONS[@]}"; do
    while IFS= read -r -d '' file; do
        echo "$file" >> "$VIDEO_LIST"
        ((video_count++))
    done < <(find "$ARRIVAL_DIR" -type f -iname "*.${ext}" -print0 2>/dev/null)
done

if [ $video_count -eq 0 ]; then
    echo_warn "No video files found in ${ARRIVAL_DIR}/"
    echo_info "Supported formats: ${VIDEO_EXTENSIONS[*]}"
    exit 0
fi

echo_info "Found $video_count video file(s) in ${ARRIVAL_DIR}/"
echo_info "Video list saved to ${VIDEO_LIST}"
echo

# ============================================================================
# STEP 2-3: Sanitize filenames, add UUID, and move to 1_INBOX
# ============================================================================
echo_step "STEP 2-3: Processing files - sanitize, add UUID, move to ${INBOX_DIR}/"
echo

processed=0
skipped=0

while IFS= read -r filepath; do
    if [ ! -f "$filepath" ]; then
        echo_warn "File not found: $filepath"
        ((skipped++))
        continue
    fi
    
    # Get original filename
    original_name=$(basename "$filepath")
    echo_info "Processing: $original_name"
    
    # Sanitize filename
    sanitized_name=$(sanitize_filename "$original_name")
    
    if [ "$original_name" != "$sanitized_name" ]; then
        echo_info "  Sanitized: $original_name -> $sanitized_name"
    fi
    
    # Generate short UUID
    uuid=$(generate_short_uuid)
    
    # Create new filename with UUID prefix
    new_name="${uuid}_${sanitized_name}"
    
    # Target path in INBOX
    target_path="${INBOX_DIR}/${new_name}"
    
    # Check if file already exists
    if [ -f "$target_path" ]; then
        echo_warn "  File already exists in INBOX: $new_name"
        ((skipped++))
        continue
    fi
    
    # Move file to INBOX
    mv "$filepath" "$target_path"
    echo_info "  Moved to: $target_path"
    ((processed++))
    echo
    
done < "$VIDEO_LIST"

echo_info "Processed: $processed file(s)"
if [ $skipped -gt 0 ]; then
    echo_warn "Skipped: $skipped file(s)"
fi
echo

# ============================================================================
# STEP 4: Create new filelist from 1_INBOX
# ============================================================================
echo_step "STEP 4: Creating video list from ${INBOX_DIR}/"
echo

> "$INBOX_LIST"

inbox_count=0
for ext in "${VIDEO_EXTENSIONS[@]}"; do
    while IFS= read -r -d '' file; do
        echo "$file" >> "$INBOX_LIST"
        ((inbox_count++))
    done < <(find "$INBOX_DIR" -type f -iname "*.${ext}" -print0 2>/dev/null)
done

if [ $inbox_count -eq 0 ]; then
    echo_warn "No video files found in ${INBOX_DIR}/"
    exit 0
fi

echo_info "Found $inbox_count video file(s) in ${INBOX_DIR}/"
echo_info "Inbox list saved to ${INBOX_LIST}"
echo

# ============================================================================
# STEP 5-6: Convert to h265, compare sizes, move to 2_DONE
# ============================================================================
echo_step "STEP 5-6: Converting to h265 and moving to ${DONE_DIR}/"
echo

converted=0
skipped_conversion=0

while IFS= read -r filepath; do
    if [ ! -f "$filepath" ]; then
        echo_warn "File not found: $filepath"
        ((skipped_conversion++))
        continue
    fi
    
    filename=$(basename "$filepath")
    name_without_ext="${filename%.*}"
    
    echo_info "Processing: $filename"
    
    # Get original file size
    original_size=$(get_file_size "$filepath")
    original_size_human=$(format_size $original_size)
    echo_info "  Original size: $original_size_human"
    
    # Output filename (always .mp4)
    converted_file="${INBOX_DIR}/${name_without_ext}_h265.mp4"
    
    # Check if already converted
    if [ -f "$converted_file" ]; then
        echo_warn "  Converted file already exists, using existing: ${name_without_ext}_h265.mp4"
    else
        echo_info "  Converting to h265..."
        
        # Convert to h265 with high quality preset
        # Using CRF 23 for near-lossless quality with good compression
        # preset slow for better compression
        if ffmpeg -i "$filepath" \
            -c:v libx265 \
            -crf 23 \
            -preset medium \
            -c:a aac \
            -b:a 128k \
            -movflags +faststart \
            "$converted_file" \
            -y \
            -loglevel error \
            -stats 2>&1 | grep -v "^frame="; then
            
            echo_info "  Conversion complete"
        else
            echo_error "  Conversion failed for: $filename"
            ((skipped_conversion++))
            continue
        fi
    fi
    
    # Get converted file size
    converted_size=$(get_file_size "$converted_file")
    converted_size_human=$(format_size $converted_size)
    echo_info "  Converted size: $converted_size_human"
    
    # Calculate size difference
    size_diff=$((original_size - converted_size))
    percent_saved=$(( (size_diff * 100) / original_size ))
    
    # Determine which file to keep
    if [ $converted_size -lt $original_size ]; then
        echo_info "  Converted file is smaller (saved ${percent_saved}%)"
        echo_info "  Moving converted file to ${DONE_DIR}/"
        
        # Move converted file to DONE
        mv "$converted_file" "${DONE_DIR}/${name_without_ext}.mp4"
        
        # Remove original
        rm "$filepath"
        echo_info "  Removed original file"
    else
        echo_info "  Original file is smaller or same size"
        echo_info "  Moving original file to ${DONE_DIR}/"
        
        # Move original to DONE
        mv "$filepath" "${DONE_DIR}/${filename}"
        
        # Remove converted file
        rm "$converted_file"
        echo_info "  Removed converted file"
    fi
    
    ((converted++))
    echo
    
done < "$INBOX_LIST"

echo_info "Successfully processed: $converted file(s)"
if [ $skipped_conversion -gt 0 ]; then
    echo_warn "Skipped during conversion: $skipped_conversion file(s)"
fi

# ============================================================================
# Processing Complete
# ============================================================================
echo
echo_info "============================================"
echo_info "Video Processing Complete!"
echo_info "============================================"
echo_info "Summary:"
echo_info "  - Files processed from ${ARRIVAL_DIR}: $processed"
echo_info "  - Files converted and moved to ${DONE_DIR}: $converted"
echo_info "============================================"
echo
