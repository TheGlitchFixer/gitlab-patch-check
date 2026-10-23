#!/usr/bin/env bash
# gitlab-patch-check — is your GitLab patched against CVE-2026-110264?
# Patched release lines published by GitLab on 2026-10-22.
set -euo pipefail

PATCHED="19.5.1 19.4.3 19.3.6 19.2.9 19.1.9 19.0.10 18.11.13"

if command -v gitlab-rake >/dev/null 2>&1; then
  VERSION=$(sudo gitlab-rake gitlab:env:info 2>/dev/null | awk -F': ' '/GitLab version/ {print $2}' | awk '{print $1}')
elif [ -f /opt/gitlab/embedded/service/gitlab-rails/VERSION ]; then
  VERSION=$(cat /opt/gitlab/embedded/service/gitlab-rails/VERSION)
else
  echo "Could not detect a GitLab installation on this host."
  echo "Check manually: Administration > Version, or run gitlab-rake gitlab:env:info"
  exit 1
fi

echo "Detected GitLab version: $VERSION"

ver_ge() { [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]; }

for p in $PATCHED; do
  line="${p%.*}"
  case "$VERSION" in
    "$line".*)
      if ver_ge "$VERSION" "$p"; then
        echo "OK: $VERSION is patched for CVE-2026-110264 (>= $p on the $line line)."
        exit 0
      else
        echo "VULNERABLE: $VERSION is below the patched $p on the $line line. Update tonight."
        exit 2
      fi
      ;;
  esac
done

echo "Your release line is not in the patched list. If you run 18.x/19.x, update to a patched line."
echo "Full guide: https://thehomelabfixer.blogspot.com/2026/10/gitlab-update-patch-cvss-10-rce-tonight.html"
exit 2
