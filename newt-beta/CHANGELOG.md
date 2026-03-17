# Changelog

## 🔹 Version 1.10.3-beta9 - (17.03.2026)
- Reduced startup log noise by pre-creating HEALTH_FILE before launching Newt

## 🔹 Version 1.10.3-beta8 - (17.03.2026)
- Set HOME and XDG_CONFIG_HOME to /data paths so Newt no longer attempts to write under /root/.config
- Updated AppArmor profile to allow Newt config persistence under /data

## 🔹 Version 1.10.3-beta7 - (17.03.2026)
- Fixed AppArmor profile to allow /bin/busybox execution used by /bin/rm on Alpine-based images

## 🔹 Version 1.10.3-beta6 - (17.03.2026)
- Fixed AppArmor profile to allow /bin/rm execution required by health file cleanup in run.sh

## 🔹 Version 1.10.3-beta5 - (17.03.2026)
- Fixed AppArmor profile to allow /usr/bin/jq execution required by run.sh

## 🔹 Version 1.10.3-beta4 - (17.03.2026)
- Fixed AppArmor profile to allow /usr/bin/env and bash interpreter execution used by run.sh

## 🔹 Version 1.10.3-beta3 - (17.03.2026)
- Testing to see if AppArmor works

## 🔹 Version 1.10.3-beta2 - (17.03.2026)
- Removed full_access to reduce privileged host exposure and improve add-on security posture
- Disabled hassio_api access since it is not required by the runtime script
- Hardened custom environment variable validation in run.sh
- Redacted sensitive runtime values from logs to prevent secret leakage
- Hardened binary download flags in Dockerfile with enforced HTTPS/TLS and retries
- Added a hardened AppArmor profile file for opt-in use on AppArmor-capable hosts
- Reduced runtime package footprint by removing build-only curl after download
- Added optional per-architecture SHA256 verification build args for Newt binaries
- Added graceful signal handling in run.sh for cleaner Home Assistant stop/restart behavior