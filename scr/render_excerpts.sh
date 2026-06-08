
#!/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error: This script must be run within a Git repository."
    exit 1
fi

SRC_DIR="$PROJECT_ROOT/excerpts/md"
OUT_DIR="$PROJECT_ROOT/excerpts/pdf"
CSS_FILE="$PROJECT_ROOT/css/excerpt.css"

mkdir -p "$OUT_DIR"

echo "Starting PDF rendering..."
echo "--------------------------------------------------"

count=0

for file in "$SRC_DIR"/*.md; do
    [ -e "$file" ] || continue
    filename=$(basename "$file" .md)
    
    echo "Processing: $filename ..."
    
    # Wir nutzen das Standard-Template von Pandoc.
    # --css fügt das Design hinzu.
    # --resource-path löst die Bild-Pfade relativ zum Root.
    pandoc "$file" \
        -o "$OUT_DIR/$filename.pdf" \
        --pdf-engine=weasyprint \
        --css="$CSS_FILE" \
        --resource-path="$PROJECT_ROOT" \
        --metadata title="$filename"
    
    ((count++))
done

echo "--------------------------------------------------"
echo "Done. $count PDFs generated in $OUT_DIR/"
