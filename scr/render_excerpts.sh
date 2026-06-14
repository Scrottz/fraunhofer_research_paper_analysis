#!/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error: This script must be run within a Git repository."
    exit 1
fi

SRC_DIR="$PROJECT_ROOT/doc/excerpts"
OUT_DIR="$PROJECT_ROOT/build/excerpts"
CSS_FILE="$PROJECT_ROOT/lib/css/excerpt.css"

mkdir -p "$OUT_DIR"

echo "Starting Excerpt PDF rendering..."
echo "--------------------------------------------------"

count=0

for file in "$SRC_DIR"/*.md; do
    [ -e "$file" ] || continue
    filename=$(basename "$file" .md)
    
    echo "Processing: $filename ..."
    
    pandoc "$file" \
        -o "$OUT_DIR/$filename.pdf" \
        --pdf-engine=weasyprint \
        --css="$CSS_FILE" \
        --resource-path="$PROJECT_ROOT"

    ((count++))
done

echo "--------------------------------------------------"
echo "Done. $count PDF(s) generated in $OUT_DIR/"
