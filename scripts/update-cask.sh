#!/usr/bin/env bash
# Points Casks/portscope.rb at the latest published PortScope release.
#
# The digest is the one the release publishes beside the zip, and the zip is
# downloaded and hashed here as well, so a cask never names a digest that does
# not match the file it installs.
set -euo pipefail

REPO="xiaoyuhen/portscope"
CASK="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/Casks/portscope.rb"

tag="$(gh api "repos/$REPO/releases/latest" --jq .tag_name)"
version="${tag#v}"
if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
    echo "Unexpected tag: $tag" >&2
    exit 1
fi

current="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$CASK")"
if [[ "$version" == "$current" ]]; then
    echo "portscope $current is current."
    exit 0
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
zip="PortScope-$version.zip"
gh release download "$tag" --repo "$REPO" --dir "$work" --pattern "$zip" --pattern "$zip.sha256"

published="$(awk -v name="$zip" '$2 == name || $2 == "*" name { print $1 }' "$work/$zip.sha256")"
actual="$(cd "$work" && shasum -a 256 "$zip" | awk '{ print $1 }')"
if [[ ! "$published" =~ ^[0-9a-f]{64}$ || "$published" != "$actual" ]]; then
    echo "Checksum mismatch for $zip: published '$published', downloaded '$actual'" >&2
    exit 1
fi

sed -i.bak \
    -e "s/^  version \".*\"$/  version \"$version\"/" \
    -e "s/^  sha256 \".*\"$/  sha256 \"$actual\"/" \
    "$CASK"
rm -f "$CASK.bak"
echo "portscope $current -> $version"
