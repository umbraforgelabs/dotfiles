# GnuPG Configuration

This directory contains modern GnuPG (GPG) configuration files optimized for Ubuntu 24.04 LTS and Raspberry Pi OS Bookworm.

## Files

### `gpg.conf`
Main GPG configuration with:
- Modern keyserver: `hkps://keys.openpgp.org` (replaced deprecated SKS network)
- Strong digest algorithms: SHA512, SHA384, SHA256
- TODO: Set `default-key` to your key fingerprint

### `gpg-agent.conf`
GPG Agent settings:
- Pinentry program selection (GUI or terminal)
- Cache TTL configuration
- Optional SSH support

### `dirmngr.conf`
Directory Manager configuration:
- Keyserver setup for certificate retrieval
- Optional proxy configuration

## Setup Instructions

1. Copy these files to your `~/.gnupg/` directory (typically via dotfile installer)
2. Edit `gpg.conf` and set your `default-key` with your GPG key fingerprint (format: `0xYOURKEYFINGERPRINT`)
3. Optionally enable SSH support in `gpg-agent.conf`
4. Run: `gpg --refresh-keys` to test keyserver connectivity

## Modern Changes

### Keyserver Migration
- **Old:** `hkps://hkps.pool.sks-keyservers.net` (SKS network deprecated in 2021)
- **New:** `hkps://keys.openpgp.org` (actively maintained, modern infrastructure)

### Pinentry Updates
- Ubuntu 24.04: Uses `pinentry-gtk-2` by default (GUI prompt)
- Headless/SSH: Falls back to `pinentry-curses` (terminal prompt)
- Raspberry Pi: Uses `pinentry-tty` if needed

### Removed Deprecated Settings
- `ca-cert-file` option (now handled by system CA bundles)
- Ubuntu 16.04 specific configurations
- SKS keyserver CA certificate references

## Troubleshooting

**"No keyserver available"** error:
- Ensure you have network connectivity
- Verify keyserver URL: `gpg --keyserver hkps://keys.openpgp.org --recv-keys 0xYOURKEYID`

**Pinentry issues:**
- Check available pinentry programs: `which pinentry-gtk-2 pinentry-curses pinentry-tty`
- Install if needed: `sudo apt install pinentry-gtk2` or similar

**SSH not working with gpg-agent:**
- Uncomment SSH settings in `gpg-agent.conf`
- Ensure GPG_SSH_AUTH_SOCK is set in your shell: `export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)`
