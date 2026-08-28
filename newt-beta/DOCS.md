# Home Assistant Add-on: Newt (Beta)

Runs [Newt](https://docs.fossorial.io/Newt/overview) from
[Fossorial](https://fossorial.io/) inside Home Assistant, connecting this
instance to your [Pangolin](https://docs.pangolin.net/) server over an
outbound WireGuard tunnel.

This is the **beta** channel. It receives Newt updates the same day (or
shortly after) they're published upstream, along with add-on hardening and
fixes before they're promoted to the stable channel. If your host doesn't
support AppArmor, use the stable **Newt Add-on** instead.

## Installation

1. Go to **Settings → Add-ons → Add-on Store**.
2. Open the menu (⋮ top right) → **Repositories**, and add:
   ```
   https://github.com/Ferdinand99/home-assistant-newt-addon
   ```
   Both **Newt Add-on** and **Newt Add-on (Beta)** are published from this
   same repository, so you only need to add it once.
3. Find **Newt Add-on (Beta)** in the store list and click **Install**.

## Getting your Newt ID and Secret

1. In your Pangolin dashboard, create a new **Site** and choose **Newt** as
   the connection method.
2. Pangolin generates a **Newt ID** and **Newt Secret** for that site, and
   shows you the endpoint URL of your Pangolin server.
3. Copy those three values into this add-on's configuration below.

See the [Pangolin site setup docs](https://docs.pangolin.net/manage/sites/install-site)
for the full walkthrough.

## Configuration

```yaml
PANGOLIN_ENDPOINT: "https://pangolin.example.com"
NEWT_ID: "your_newt_id"
NEWT_SECRET: "your_newt_secret"
custom_env_vars:
  - "ACCEPT_CLIENTS=true"
  - "LOG_LEVEL=DEBUG"
  - "MTU=1420"
```

### Option: `PANGOLIN_ENDPOINT`

The URL of the Pangolin server this site connects to.

### Option: `NEWT_ID`

The Newt ID generated for this site in Pangolin.

### Option: `NEWT_SECRET`

The Newt secret generated for this site in Pangolin.

### Option: `custom_env_vars` (optional)

Extra environment variables passed through to Newt, one `NAME=value` entry
per line. Use this for any of Newt's optional settings — see the
[Newt environment variables](https://github.com/fosrl/newt?tab=readme-ov-file#environment-variables)
reference for the full list.

For safety, a few names are always rejected regardless of what you set here,
since they would let a config entry override values the add-on already
validated, or change how the add-on's own script and Newt are executed:
`PATH`, `HOME`, `LD_*`, `HEALTH_FILE`, `PANGOLIN_ENDPOINT`, `NEWT_ID`, and
`NEWT_SECRET`. A rejected entry is skipped with a warning in the add-on log;
everything else you set here is applied.

## Health status

The add-on reports **healthy** once Newt successfully establishes the tunnel
to your Pangolin server, and **unhealthy** if that connection is lost — Newt
owns this signal itself, so it reflects real tunnel connectivity, not just
whether the process is running.

Note this is separate from the per-resource "Target" health checks you may
see in the add-on log (`Target NNN: health check failed: ...`) — those come
from Pangolin checking your own backend services behind the tunnel, and
don't affect the add-on's health status.

## Reverse proxy / `trusted_proxies` setup (optional)

If you're exposing Home Assistant through Pangolin and seeing `403:
Forbidden` errors or token errors, add the add-on's network and your
reverse proxy's IP to `configuration.yaml`:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24  # Default range for Home Assistant add-ons
    - 127.0.0.1
```

Home Assistant logs the exact IP to add if this isn't already configured.
Restart Home Assistant (**Settings → System → Restart**, or `ha core
restart`) after editing.

## Troubleshooting

**Add-on doesn't start?**
Check the add-on log for the specific error. Most commonly this is a missing
or incorrect `PANGOLIN_ENDPOINT`, `NEWT_ID`, or `NEWT_SECRET`.

**Add-on shows unhealthy?**
This means the tunnel to Pangolin isn't currently up. Check that your
Pangolin server is reachable from this Home Assistant instance and that the
site hasn't been deleted or regenerated (which invalidates the old
`NEWT_ID`/`NEWT_SECRET`).

**Configuration changes not taking effect?**
Restart the add-on after saving.

## Changelog & Releases

See [CHANGELOG.md](CHANGELOG.md) in this add-on's folder.

## Support

- [Discord](https://discord.gg/fTHY3ZM8nY)
- [GitHub Issues](https://github.com/Ferdinand99/home-assistant-newt-addon/issues)

## Useful links

- [Newt documentation](https://docs.fossorial.io/Newt/overview)
- [Pangolin documentation](https://docs.pangolin.net/)
- [Home Assistant](https://www.home-assistant.io/)
