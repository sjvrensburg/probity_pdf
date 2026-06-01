#!/usr/bin/env bash
# install.sh — Install the probity-typst Quarto extension into a target project.
#
# Usage:
#   ./install.sh /path/to/target/project
#   ./install.sh                  # installs into the current directory

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_SRC="${SCRIPT_DIR}/_extensions/probity"
TARGET="${1:-.}"

# ---- guards ----
if [ ! -f "${EXT_SRC}/_extension.yml" ]; then
    echo "ERROR: Cannot find _extensions/probity/_extension.yml in ${SCRIPT_DIR}" >&2
    echo "       Run this script from the probity_pdf repository root." >&2
    exit 1
fi

if [ ! -d "${TARGET}" ]; then
    echo "ERROR: Target directory does not exist: ${TARGET}" >&2
    exit 1
fi

TARGET_EXT="${TARGET}/_extensions/probity"

# ---- install ----
echo "Installing probity-typst extension into: ${TARGET}"

if [ -d "${TARGET_EXT}" ]; then
    echo "  Removing previous installation..."
    rm -rf "${TARGET_EXT}"
fi

mkdir -p "${TARGET_EXT}"
cp -r "${EXT_SRC}"/* "${TARGET_EXT}"/

if [ -d "${EXT_SRC}/assets" ]; then
    cp -r "${EXT_SRC}/assets" "${TARGET_EXT}/"
fi

# ---- project root marker ----
QUARTO_YML="${TARGET}/_quarto.yml"
if [ ! -f "${QUARTO_YML}" ]; then
    echo "  Creating minimal _quarto.yml (needed for subdirectory discovery)..."
    cat > "${QUARTO_YML}" <<'YAML'
project:
  title: "Project"
YAML
fi

# ---- verify ----
echo "  Verifying extension files..."
required_files=(
    "_extension.yml"
    "typst-template.typ"
    "typst-show.typ"
    "assets/logo_trim.png"
    "assets/logo_navy_small.png"
)
for f in "${required_files[@]}"; do
    if [ ! -f "${TARGET_EXT}/${f}" ]; then
        echo "ERROR: Expected file missing after install: ${TARGET_EXT}/${f}" >&2
        exit 1
    fi
done

echo "  Checking Quarto version..."
if command -v quarto &>/dev/null; then
    quarto --version
else
    echo "  (quarto not found on PATH; skipping validation)"
fi

echo ""
echo "Done. Add the following to your .qmd front matter:"
echo ""
echo "    format: probity-typst"
echo "    lang: en-GB"
echo ""
echo "Render with:"
echo ""
echo "    quarto render my-report.qmd"
echo ""
echo "Output is a PDF via Typst (no LaTeX required)."
