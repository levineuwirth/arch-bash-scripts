#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Exiting..."
    exit 1
fi

echo "Available locales:"
localectl list-locales

read -p "Enter the locale you want to switch to: " user_locale

if locale | grep -q "LANG=$user_locale"; then
    echo "The locale $user_locale is currently active. Exiting..."
    exit 0
fi

if localectl set-locale LANG="$user_locale"; then
    echo "Locale changed."
else
    echo "Failed to set locale. Check your spelling of the name. Exiting..."
    exit 1
fi

read -p "Changes require ending the X window session. End session now? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "Ending X window session..."
  pkill -KILL -u "$USER"
else
  echo "Changes take effect on your next X window session."
fi
