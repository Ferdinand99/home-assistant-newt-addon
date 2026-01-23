# Changelog

## 🔹 Version 1.9.0 - (23.01.2026)
- Updated newt to 1.9.0

## 🔹 Version 1.8.1 - (24.12.2025)
- Updated newt version to 1.8.1
- chore(nix): add nix hash update automation by @water-sucks in #217
- Fix health check leaking socket binds

## 🔹 Version 1.8.0 - (23.12.2025)
- Updated newt version to 1.8.0 to support the new Pangolin update
- Port firewalling for Private Resources by @oschwartz10612 in #203
- Support ICMP test requests for clients by @oschwartz10612 in #208
- fix(nix): use correct hash for vendored deps by @water-sucks in #199
- feat(build): parallelize go-build-release and github actions with matrix by @water-sucks in #200

## 🔹 Version 1.7.0 - (12.12.2025)
- Updated newt version to 1.7.0 to support the new Pangolin update

## 🔹 Version 1.6.0.1 - (31.10.2025)
- Added a possible fix to the Newt version bug in the Pangolin Dashboard

## 🔹 Version 1.6.0 - (30.10.2025)
- Bumped addon version to match newt version
- Updated timestamp in chanelog to match local format

## 🔹 Version 1.4.9 - (2025-10-28)
- Updated NEWT to version 1.6.0

## 🔹 Version 1.4.8 - (2025-10-09)
- Updated NEWT to version 1.5.2

## 🔹 Version 1.4.7 - (2025-09-30)
- Added support for custom environment variables (PR Contribution by @r3nor)

## 🔹 Version 1.4.6 - (2025-09-29)
- Updated NEWT to version 1.5.1

## 🔹 Version 1.4.5 - (2025-09-18)
- Updated NEWT to version 1.5.0

## 🔹 Version 1.4.4 - (2025-09-02)
- Updated NEWT to version 1.4.4

## 🔹 Version 1.4.3 - (2025-09-02)
- Updated NEWT to version 1.4.3

## 🔹 Version 1.4.2 - (2025-08-23)
- Updated NEWT to version 1.4.2

## 🔹 Version 1.4.1 - (2025-08-17)
- Updated NEWT to version 1.4.1

## 🔹 Version 1.4.0 - (2025-07-30)
- Updated NEWT to version 1.4.0

## 🔹 Version 1.3.9 - (2025-07-19)
- Small changes to fix ping issue. Added - NET_RAW in config.json

## 🔹 Version 1.3.8 - (2025-07-19)
- Updated newt version to 1.3.4

## 🔹 Version 1.3.7 - (2025-07-14)
- Updated newt version to 1.3.2

## 🔹 Version 1.3.6 - (2025-07-12)
- Updated newt version to 1.3.1

## 🔹 Version 1.3.5 - (2025-07-11)
- Updated newt version to 1.3.0

## 🔹 Version 1.3.4 - (2025-06-08)
- Updated newt version to 1.2.1

## 🔹 Version 1.3.4 - (2025-06-08)
- Updated newt version to 1.2.1

## 🔹 Version 1.3.3 - (2025-05-21)
- First automated changelog post to Discord!
- Version Bump

## 🔹 Version 1.3.2 - (2025-05-18)
- Added add-on icon

## 🔹 Version 1.3.1 - (2025-04-07)
- Updated newt to release 1.1.3

## 🔹 Version 1.3.0 - (2025-04-06)
- Made changes to run.sh. Should allow the addon to reconnect after loosing connection to Pangolin

## 🔹 Version 1.2.9 - (2025-03-22)
- Updated newt to release 1.1.2

## 🔹 Version 1.2.6 - (2025-03-15)
- Updated newt to release 1.1.1

## 🔹 Version 1.2.5 - (2025-03-08)
- Added built in Home Assistant Changelog support

## 🔹 Version 1.2.4 - (2025-03-08)
- Fixed architecture detection for downloading the correct Newt binary
- Improved logging for missing dependencies
- Added automatic retries if the download fails

## 🔹 Version 1.2.3 - (2025-03-07)
- Switched to GitHub API for downloading the latest Newt version
- Removed hardcoded version numbers from the Dockerfile

## 🔹 Version 1.2.4 - (2025-03-06)
- Fixed issue where configuration was not loading from UI
- Added support for environment variables
