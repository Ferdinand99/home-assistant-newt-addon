# Changelog

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