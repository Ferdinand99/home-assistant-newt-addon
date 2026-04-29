# Changelog

## 🔹 Version 1.12.2-beta2 - (29.04.2026)
- Fixed an issue where the add-on would download the wrong architecture binary during cross-compilation by implementing Home Assistant's native `BUILD_ARCH` variable
- Fixed build crashes caused by GitHub DNS resolution timeouts in Alpine Linux (`Could not resolve host: github.com`)
- Fixed `sha256sum` checksum validation failing due to strict spacing requirements

## 🔹 Version 1.12.2-beta1 - (29.04.2026)
- Updated newt version to 1.12.2 (https://github.com/fosrl/newt/releases/tag/1.12.2)

## 🔹 Version 1.12.0-beta1 - (28.04.2026)
- Updated newt version to 1.12.0 (https://github.com/fosrl/newt/releases/tag/1.12.0)

## 🔹 Version 1.11.0-beta1 - (04.04.2026)
- Updated newt version to 1.11.0 (https://github.com/fosrl/newt/releases/tag/1.11.0)

## 🔹 Version 1.10.4-beta1 - (29.03.2026)
- Updated newt version to 1.10.4 (https://github.com/fosrl/newt/releases/tag/1.10.4)

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
