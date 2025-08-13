#!/usr/bin/env bash
set -e

REPO="Nospire/fx"

echo "Fetching release list from GitHub..."
RELEASES_JSON=$(curl -s "https://api.github.com/repos/$REPO/releases")

# Получаем список релизов
RELEASE_TAGS=($(echo "$RELEASES_JSON" | grep '"tag_name":' | cut -d '"' -f 4))
RELEASE_NAMES=($(echo "$RELEASES_JSON" | grep '"name":' | cut -d '"' -f 4 | grep -v null))

if [ ${#RELEASE_TAGS[@]} -eq 0 ]; then
  echo "No releases found for $REPO"
  exit 1
fi

echo
echo "Available releases:"
for i in "${!RELEASE_TAGS[@]}"; do
  echo "$((i+1))) ${RELEASE_NAMES[$i]} (${RELEASE_TAGS[$i]})"
done

echo
read -rp "Enter release number to download (or press Enter for latest): " choice

if [[ -z "$choice" || "$choice" -eq 1 ]]; then
  CHOSEN_TAG="${RELEASE_TAGS[0]}"
else
  INDEX=$((choice-1))
  if [ $INDEX -lt 0 ] || [ $INDEX -ge ${#RELEASE_TAGS[@]} ]; then
    echo "Invalid choice"
    exit 1
  fi
  CHOSEN_TAG="${RELEASE_TAGS[$INDEX]}"
fi

echo "Selected release: $CHOSEN_TAG"

# Получаем JSON конкретного релиза
RELEASE_JSON=$(curl -s "https://api.github.com/repos/$REPO/releases/tags/$CHOSEN_TAG")

# Ищем первый .tar.gz в ассетах
ASSET_URL=$(echo "$RELEASE_JSON" | grep "browser_download_url" | grep ".tar.gz" | cut -d '"' -f 4 | head -n 1)

if [ -z "$ASSET_URL" ]; then
  echo "No .tar.gz asset found in release $CHOSEN_TAG"
  exit 1
fi

ASSET_FILE=$(basename "$ASSET_URL")
echo "Downloading $ASSET_FILE..."
curl -L -o "$ASSET_FILE" "$ASSET_URL"

echo "Extracting $ASSET_FILE..."
tar xzf "$ASSET_FILE"

if [ -f "install_openh264.sh" ]; then
  chmod +x install_openh264.sh
  ./install_openh264.sh
else
  echo "install_openh264.sh not found after extraction."
  exit 1
fi
