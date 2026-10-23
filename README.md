# gitlab-patch-check

Companion script for the guide "GitLab Update: Patch the CVSS-10 RCE Tonight" on The Homelab Fixer: https://thehomelabfixer.blogspot.com/2026/10/gitlab-update-patch-cvss-10-rce-tonight.html

## What it does

Prints your installed GitLab version and tells you whether it is on a patched release line for CVE-2026-110264.

## Usage

```bash
bash check-gitlab-version.sh
```

## Patched lines

19.5.1, 19.4.3, 19.3.6, 19.2.9, 19.1.9, 19.0.10, 18.11.13 (and anything newer in the same line).
