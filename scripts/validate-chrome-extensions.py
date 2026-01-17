#!/usr/bin/env python3
"""Validate Chrome extension IDs are installable from Chrome Web Store."""

import re
import sys
import urllib.request
from pathlib import Path

CONFIG_FILE = sys.argv[1] if len(sys.argv) > 1 else "home/profiles/hyprland/apps.nix"

# Extract extension IDs and names from config
content = Path(CONFIG_FILE).read_text()
pattern = r'"([a-z]{32});https://clients2.*?#\s*(.+)'
extensions = re.findall(pattern, content)

if not extensions:
    print(f"No extensions found in {CONFIG_FILE}")
    sys.exit(1)

print(f"Validating {len(extensions)} extensions...\n")


def get_extension_name(html: str) -> str | None:
    """Extract extension name from Chrome Web Store page."""
    # Try og:title meta tag first
    match = re.search(r'<meta property="og:title" content="([^"]+)"', html)
    if match:
        name = match.group(1)
        # Remove " - Chrome Web Store" suffix if present
        return re.sub(r"\s*-\s*Chrome Web Store$", "", name)
    # Fallback to title tag
    match = re.search(r"<title>([^<]+)</title>", html)
    if match:
        return re.sub(r"\s*-\s*Chrome Web Store$", "", match.group(1))
    return None


failed = 0
mismatched = []

for ext_id, config_name in extensions:
    config_name = config_name.strip()
    url = f"https://chromewebstore.google.com/detail/{ext_id}"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            if resp.status == 200:
                html = resp.read().decode("utf-8", errors="ignore")
                store_name = get_extension_name(html)
                if store_name:
                    if store_name.lower() != config_name.lower():
                        print(f"✓ {store_name} ({ext_id})")
                        print(f"  └─ config says: {config_name}")
                        mismatched.append((ext_id, config_name, store_name))
                    else:
                        print(f"✓ {store_name} ({ext_id})")
                else:
                    print(f"✓ {config_name} ({ext_id}) - name not parsed")
            else:
                print(f"✗ {config_name} ({ext_id}) - HTTP {resp.status}")
                failed += 1
    except urllib.error.HTTPError as e:
        print(f"✗ {config_name} ({ext_id}) - HTTP {e.code}")
        failed += 1
    except Exception as e:
        print(f"✗ {config_name} ({ext_id}) - {e}")
        failed += 1

print()
if failed == 0 and not mismatched:
    print("All extensions valid!")
elif failed == 0:
    print(f"All extensions valid, {len(mismatched)} name mismatch(es)")
else:
    print(f"{failed} extension(s) failed validation")
    sys.exit(1)
