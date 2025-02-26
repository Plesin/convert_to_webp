# ------------------------------------------------------------------------------
#          FILE:  webp.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin to convert jpg|jpeg files to webp.
#                 Requires cwebp to be installed.
#                 To install libwebp on macOS: brew install webp
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

convert_to_webp() {
  local quality="${1:-80}"
  local input_dir="$(pwd)"
  local output_dir="${input_dir}/webp"

  echo "Converting files in: $input_dir"
  echo "Quality: $quality%"
  
  mkdir -p "$output_dir"
  
  local files=($(find "$input_dir" -maxdepth 1 -type f \( -name "*.jpeg" -o -name "*.jpg" \)))

  if [ ${#files[@]} -gt 0 ]; then
    for file in "${files[@]}"; do
      local filename=$(basename "$file")
      local output_file="${output_dir}/${filename%.*}.webp"
      local size_before=$(stat -f%z "$file")
      echo "Converting $filename"
      cwebp -q "$quality" "$file" -o "$output_file" > /dev/null 2>&1
      local size_after=$(stat -f%z "$output_file")

      if [ $size_before -ge 1048576 ]; then
        local size_before_mb=$(echo "scale=2; $size_before / 1048576" | bc)
        echo "Size before: ${size_before_mb}MB"
      else
        local size_before_kb=$(echo "scale=2; $size_before / 1024" | bc)
        echo "Size before: ${size_before_kb}KB"
      fi

      if [ $size_after -ge 1048576 ]; then
        local size_after_mb=$(echo "scale=2; $size_after / 1048576" | bc)
        echo "Size after: ${size_after_mb}MB"
      else
        local size_after_kb=$(echo "scale=2; $size_after / 1024" | bc)
        echo "Size after: ${size_after_kb}KB"
      fi

      echo ""
    done
  else
    echo "No files found matching patterns: *.jpeg or *.jpg"
  fi
}