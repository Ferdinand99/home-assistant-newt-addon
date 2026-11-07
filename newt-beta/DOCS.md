# Home Assistant Add-on: Newt (Beta)

Runs the official [Pangolin CLI](https://github.com/fosrl/cli)
(`pangolin-cli up site`) inside Home Assistant, connecting this instance to
your [Pangolin](https://docs.pangolin.net/) server over an outbound WireGuard
tunnel. The CLI embeds [Newt](https://docs.fossorial.io/Newt/overview), so it
accepts the same settings and environment variables as the standalone Newt
binary.

This is the **beta** channel. It receives Pangolin CLI updates the same day
(or shortly after) they're published upstream, along with add-on hardening
and fixes. If your host doesn't support AppArmor, use the stable **Newt
Add-on** instead.

### Switched from Newt to the Pangolin CLI

Newt is being phased out upstream in favour of the Pangolin CLI, so this beta
channel now runs the CLI instead of the standalone Newt binary.

- **Your options keep working.** The option names are unchanged
  (`PANGOLIN_ENDPOINT`, `NEWT_ID`, `NEWT_SECRET`). The add-on passes the same
  values to the CLI as `SITE_ID`/`SITE_SECRET` and as `NEWT_ID`/`NEWT_SECRET`,
  so you do not need to change anything. `NEWT_ID` is the site ID and
  `NEWT_SECRET` is the site secret.
- **`custom_env_vars` still work.** Newt settings such as `LOG_LEVEL`, `MTU`
  or `ACCEPT_CLIENTS` are read by the embedded Newt as before.
- **Version numbers changed.** The add-on version is no longer the Newt
  version. The beta channel starts a new `2.x` line, and the pinned CLI
  version is listed in the [changelog](CHANGELOG.md).
- **Rolling back.** To go back to the standalone Newt binary, uninstall this
  beta add-on and install the stable **Newt Add-on** from the same
  repository. Enter the same `PANGOLIN_ENDPOINT`, `NEWT_ID` and `NEWT_SECRET`.
  Only one of the two add-ons should run at a time for the same site.

## Installation

1. Go to **Settings → Add-ons → Add-on Store**.
2. Open the menu (⋮ top right) → **Repositories**, and add:
   ```
   https://github.com/Ferdinand99/home-assistant-newt-addon
   ```
   Both **Newt Add-on** and **Newt Add-on (Beta)** are published from this
   same repository, so you only need to add it once.
3. Find **Newt Add-on (Beta)** in the store list and click **Install**.

## Getting your site ID and secret

1. In your Pangolin dashboard, create a new **Site** and choose **Newt** (or
   the Pangolin CLI) as the connection method.
2. Pangolin generates an ID and a secret for that site (shown as **Newt ID**
   and **Newt Secret**, or **Site ID** and **Site Secret**), and shows you the
   endpoint URL of your Pangolin server.
3. Copy those three values into this add-on's configuration below. The ID goes
   into `NEWT_ID` and the secret into `NEWT_SECRET`.

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

The ID generated for this site in Pangolin (the site ID, passed to the CLI as `SITE_ID`).

### Option: `NEWT_SECRET`

The secret generated for this site in Pangolin (the site secret, passed to the CLI as `SITE_SECRET`).

### Option: `custom_env_vars` (optional)

Extra environment variables passed through to the Pangolin CLI (its embedded Newt), one `NAME=value` entry
per line. Use this for any of Newt's optional settings — see the
[Newt environment variables](https://github.com/fosrl/newt?tab=readme-ov-file#environment-variables)
reference for the full list.

For safety, a few names are always rejected regardless of what you set here,
since they would let a config entry override values the add-on already
validated, or change how the add-on's own script and the Pangolin CLI are executed:
`PATH`, `HOME`, `LD_*`, `HEALTH_FILE`, `PANGOLIN_ENDPOINT`, `NEWT_ID`,
`NEWT_SECRET`, `SITE_ID`, and `SITE_SECRET`. A rejected entry is skipped with a warning in the add-on log;
everything else you set here is applied.

## Health status

The add-on reports **healthy** once the Pangolin CLI successfully establishes the tunnel
to your Pangolin server, and **unhealthy** if that connection is lost — the
CLI owns this signal itself, so it reflects real tunnel connectivity, not just
whether the process is running.

Note this is separate from the per-resource "Target" health checks you may
see in the add-on log (`Target NNN: health check failed: ...`) — those come
from Pangolin checking your own backend services behind the tunnel, and
don't affect the add-on's health status.

## Reverse proxy / `trusted_proxies` setup (optional)

If you're exposing Home Assistant through Pangolin and seeing `403:
Forbidden` errors or token errors, tell Home Assistant to trust the proxy:

1. Go to **Settings → System → Network → HTTP server**.
2. Turn on **Trust X-Forwarded-For**.
3. Under **Trusted proxies**, add the address Newt's requests come from. The
   add-on uses host networking, so this is `127.0.0.1` if your Pangolin
   resource points at `127.0.0.1`/`localhost`, or your Home Assistant host's
   IP if it points at that IP. Also add any other reverse proxy in front of
   Home Assistant.
4. Click **Save**. Then confirm the new settings after Home Assistant
   restarts. If you don't confirm within 5 minutes, they're reverted.

Home Assistant logs the exact IP to add if this isn't already configured.

The old `http:` block (`use_x_forwarded_for` / `trusted_proxies`) in
`configuration.yaml` is ignored on current Home Assistant versions. It's
imported once on upgrade, so remove it afterwards. On older versions that
don't have the **HTTP server** section yet, use that YAML block and restart
Home Assistant.

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

- [Pangolin CLI](https://github.com/fosrl/cli)
- [Newt documentation](https://docs.fossorial.io/Newt/overview)
- [Pangolin documentation](https://docs.pangolin.net/)
- [Home Assistant](https://www.home-assistant.io/)
