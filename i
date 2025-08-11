#!/usr/bin/env bash
# Качает последний openh264_installer.tar.gz из релизов Nospire/fx,
# распаковывает и запускает install_openh264.sh.

set -euo pipefail

REPO="Nospire/fx"
ASSET="openh264_installer.tar.gz"
BASE="https://github.com/${REPO}/releases/latest/download"

need() { command -v "$1" >/dev/null 2>&1; }

for bin in curl tar; do
  if ! need "$bin"; then
    echo "Не найдена утилита: $bin" >&2
    exit 1
  fi
done

SUDO=""
if need sudo; then SUDO="sudo -E"; fi

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

echo "[*] Скачиваю ${ASSET}…"
curl -fL --retry 3 -o "${workdir}/${ASSET}" "${BASE}/${ASSET}"

echo "[*] Распаковываю…"
mkdir -p "${workdir}/unpack"
tar -xzf "${workdir}/${ASSET}" -C "${workdir}/unpack"

inst="$(find "${workdir}/unpack" -type f -name 'install_openh264.sh' | head -n1 || true)"
if [ -z "${inst:-}" ]; then
  echo "Не найден install_openh264.sh внутри ${ASSET}." >&2
  exit 1
fi
chmod +x "$inst"

echo "[*] Запускаю install_openh264.sh… (может попросить пароль sudo пользователя deck)"
(
  cd "$(dirname "$inst")"
  if [ -n "$SUDO" ]; then
    $SUDO ./$(basename "$inst")
  else
    ./$(basename "$inst")
  fi
)

echo "[✓] Готово."
