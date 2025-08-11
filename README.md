# OpenH264 Installer for Steam Deck

[🇷🇺 **Русский**](#русский) | [🇬🇧 **English**](#english)

---

## 🇷🇺 Русский

### Проблема
Многие пользователи Steam Deck сталкиваются с ошибкой при скачивании OpenH264:
```
Aborted due to failure (while downloading http://ciscobinary.openh264.org/libopenh264-2.1.1-linux64.6.so.bz2: Error resolving "ciscobinary.openh264.org": Name or service not known)
```
Из-за этого Discord не запускается, Telegram не показывает видео, а другие Flatpak-приложения, которым нужен кодек OpenH264, работают с ошибками.

### Причина
Flatpak пытается скачать устаревшую версию библиотеки (2.1.1) с сервера Cisco `ciscobinary.openh264.org`. Этот сервер либо недоступен, либо блокируется провайдерами, поэтому загрузка срывается.

### Решение
В репозитории лежит актуальная версия OpenH264 (2.5.1) и скрипт для автоматической установки.

**Установка (Steam Deck, одной командой):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nospire/fx/main/i)
```

Скрипт:
1. Скачает `openh264_installer.tar.gz` из последнего релиза.
2. Распакует архив.
3. Запустит `install_openh264.sh`, который установит кодек в:
   ```
   /var/lib/flatpak/runtime/org.freedesktop.Platform.openh264/x86_64/2.5.1
   ```
4. Выполнит `flatpak repair` для регистрации кодека.

После установки приложения, которые раньше не работали с видео, будут функционировать нормально. Перезагрузка **не обязательна**, но может быть полезна.

---

## 🇬🇧 English

### The Issue
Many Steam Deck users encounter this error when downloading OpenH264:
```
Aborted due to failure (while downloading http://ciscobinary.openh264.org/libopenh264-2.1.1-linux64.6.so.bz2: Error resolving "ciscobinary.openh264.org": Name or service not known)
```
This causes Discord to fail to start, Telegram to not show videos, and other Flatpak apps that require OpenH264 to break.

### Cause
Flatpak is trying to download an outdated version (2.1.1) of the library from Cisco’s `ciscobinary.openh264.org`. This server is either unreachable or blocked by some ISPs, causing the download to fail.

### Solution
This repository contains the latest working version of OpenH264 (2.5.1) along with an automatic installer script.

**Installation (Steam Deck, single command):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nospire/fx/main/i)
```

The script will:
1. Download `openh264_installer.tar.gz` from the latest release.
2. Extract it.
3. Run `install_openh264.sh` to install the codec into:
   ```
   /var/lib/flatpak/runtime/org.freedesktop.Platform.openh264/x86_64/2.5.1
   ```
4. Execute `flatpak repair` to register the codec.

After installation, apps that previously failed to play videos should work normally. A reboot is **optional** but may be helpful.

---

### 📦 Repository Contents
- `i` — the lightweight installer script for quick setup via curl.
- `openh264_installer.tar.gz` (in Releases) — archive containing:
  - `install_openh264.sh` — the installation script
  - `openh264-2.5.1.tar.gz` — the codec itself.

### 📜 License
MIT
