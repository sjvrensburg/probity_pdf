#!/usr/bin/env bash
# install.sh — Install the probity-typst Quarto extension into a target project.
#
# Usage:
#   ./install.sh                                   # install into the current directory
#   ./install.sh <project-dir>                     # install at the project root
#   ./install.sh <project-dir> <deck-subdir>       # also make the extension resolvable
#                                                  # from a report kept in a subdirectory
#                                                  # (copies the extension next to it)
#   ./install.sh --link <project-dir> <deck-subdir>
#                                                  # as above, but symlink instead of copy
#                                                  # (Unix filesystems only — see below)
#
# Why <deck-subdir> exists
#   Quarto discovers `_extensions/` by walking up from the .qmd only as far as the
#   project root — the nearest ancestor directory containing a `_quarto.yml`. A root
#   `_quarto.yml` (which this script creates) is enough for discovery in the simple
#   case, but a report in a subdirectory still fails in two ways:
#     1. An intermediate `_quarto.yml` re-anchors the project root below `_extensions/`,
#        or there is no root `_quarto.yml` at all (e.g. after `quarto add`):
#        "Unable to read the extension 'probity'".
#     2. Even when discovery succeeds, the Typst template loads its logo via the
#        relative path `_extensions/probity/assets/...`, which Typst resolves against
#        the *document's* directory. A report in a subdirectory therefore fails with
#        "file not found ... _extensions/probity/assets/logo_trim.png".
#   Co-locating the extension with the report fixes both. Pass <deck-subdir> to do it.
#
#   The default is a copy because it is self-contained and portable: it survives
#   zipping, emailing, and moving to another machine, and it works on Windows.
#   --link makes a relative symlink instead (one source of truth, no duplication),
#   but symlinks need Administrator/Developer Mode on Windows and do not survive
#   being zipped or copied off the filesystem; the script falls back to a copy if
#   the symlink cannot be created or resolved.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_SRC="${SCRIPT_DIR}/_extensions/probity"

LINK_MODE=0
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --link) LINK_MODE=1 ;;
        -h|--help)
            sed -n '2,34p' "$0" | sed 's/^# \{0,1\}//'
            exit 0 ;;
        *) ARGS+=("$arg") ;;
    esac
done

TARGET="${ARGS[0]:-.}"
DECK_SUBDIR="${ARGS[1]:-}"

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

TARGET="$(cd "${TARGET}" && pwd)"   # absolute, normalised
TARGET_EXT="${TARGET}/_extensions/probity"

# ---- install ----
echo "Installing probity extension into: ${TARGET}"

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

# ---- optional: co-locate the extension with a report in a subdirectory ----
if [ -n "${DECK_SUBDIR}" ]; then
    DECK_DIR="${TARGET}/${DECK_SUBDIR}"
    mkdir -p "${DECK_DIR}"
    DECK_DIR="$(cd "${DECK_DIR}" && pwd)"
    DEST="${DECK_DIR}/_extensions"

    if [ "${DECK_DIR}" = "${TARGET}" ]; then
        echo "  Report subdirectory is the project root; nothing extra to do."
    else
        linked=0
        if [ "${LINK_MODE}" -eq 1 ]; then
            if [ -e "${DEST}" ] && [ ! -L "${DEST}" ]; then
                echo "  Note: '${DEST}' is an existing directory; symlinking would shadow it. Copying instead."
            else
                [ -L "${DEST}" ] && rm -f "${DEST}"
                if command -v python3 >/dev/null 2>&1; then
                    REL="$(python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "${TARGET}/_extensions" "${DECK_DIR}")"
                else
                    REL="${TARGET}/_extensions"   # absolute fallback target
                fi
                if ln -s "${REL}" "${DEST}" 2>/dev/null && [ -r "${DEST}/probity/_extension.yml" ]; then
                    echo "  Linked ${DECK_SUBDIR}/_extensions -> ${REL}"
                    linked=1
                else
                    rm -f "${DEST}" 2>/dev/null || true
                    echo "  Note: could not create a working symlink here; copying instead."
                fi
            fi
        fi
        if [ "${linked}" -eq 0 ]; then
            [ -L "${DEST}" ] && rm -f "${DEST}"
            mkdir -p "${DEST}"
            rm -rf "${DEST}/probity"
            cp -r "${EXT_SRC}" "${DEST}/"
            echo "  Copied extension into ${DECK_SUBDIR}/_extensions/probity/ (self-contained, portable)"
        fi
    fi
fi

# ---- verify ----
echo "  Verifying extension files..."
required_files=(
    "_extension.yml"
    "typst-template.typ"
    "typst-show.typ"
    "probity-beamer.sty"
    "assets/logo_trim.png"
    "assets/logo_navy_small.png"
    "assets/logo_white.png"
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
echo "Done. Two formats are now available."
echo ""
echo "PDF report (via Typst — no LaTeX required):"
echo ""
echo "    format: probity-typst"
echo "    lang: en-GB"
echo ""
echo "Slide deck (via XeLaTeX/Beamer — requires a TeX distribution):"
echo ""
echo "    format: probity-beamer"
echo "    lang: en-GB"
echo ""
echo "Render with:  quarto render my-document.qmd"
echo ""
echo "If Beamer is not installed, Quarto will attempt to install it automatically"
echo "via TinyTeX. To install it manually: tlmgr install beamer"
echo ""
echo "Keep documents at or below the directory holding _quarto.yml and _extensions/."
echo "If a document in a subdirectory reports \"Unable to read the extension\" or"
echo "asset errors, re-run this script with the subdirectory as the second argument:"
echo "    bash install.sh ${TARGET} pipeline/docs"
