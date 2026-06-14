#!/bin/bash

# ==========================================================================
# OVERVIEW TABLES PDF RENDERER
# Generates landscape-oriented PDF from overview-tables.md
# ==========================================================================

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error: This script must be run within a Git repository."
    exit 1
fi

SRC_FILE="$PROJECT_ROOT/doc/overview_tables/overview_tables.md"
OUT_DIR="$PROJECT_ROOT/build/overview_tables"
CSS_FILE="$PROJECT_ROOT/lib/css/overview_tables.css"
OUTPUT_FILE="$OUT_DIR/overview_tables.pdf"

# Verzeichnis erstellen
mkdir -p "$OUT_DIR"

# Prüfen ob Quelldatei existiert
if [ ! -f "$SRC_FILE" ]; then
    echo "Error: Source file not found: $SRC_FILE"
    exit 1
fi

if [ ! -f "$CSS_FILE" ]; then
    echo "Error: CSS file not found: $CSS_FILE"
    exit 1
fi

echo "Starting Overview Tables PDF rendering..."
echo "--------------------------------------------------"
echo "Source:  $SRC_FILE"
echo "CSS:     $CSS_FILE"
echo "Output:  $OUTPUT_FILE"
echo "--------------------------------------------------"

# Pandoc-Konvertierung mit WeasyPrint
pandoc "$SRC_FILE" \
    -o "$OUTPUT_FILE" \
    --pdf-engine=weasyprint \
    --css="$CSS_FILE" \
    --resource-path="$PROJECT_ROOT" \

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------"
    echo "✓ Success: PDF generated at $OUTPUT_FILE"
    echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
else
    echo "--------------------------------------------------"
    echo "✗ Error: PDF generation failed"
    exit 1
fi
