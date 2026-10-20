#!/usr/bin/env bash
#
# Build every DXE driver used by the BC-250 v3 BIOS and collect the resulting
# firmware files (.ffs) and raw DXE images (.efi) into Build/Output/.
#
# Each driver is a git submodule and is built with its own build_ffs.sh (the
# shared DXEBUILD wrapper).  Nested submodules (DXEBUILD) are initialized first.
#
# Usage: ./build_all_ffs.sh
# Env:   passed through to each driver's build_ffs.sh (CONTAINER_ENGINE,
#        EDK2_IMAGE, ARCH, TARGET, TOOL_CHAIN_TAG, NO_CONTAINER, ...).
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OUT="$ROOT/Build/Output"

DRIVERS=(
  BC250-DXEv3-ACPI-Driver
  BC250-DXEv3-Cold-Boot
  BC250-DXEv3-Core-Unlock
  BC250-DXEv3-CU-Unlock
  BC250-DXEv3-Menu-Driver
  BC250-DXEv3-SMU-Governor
  BC250-DXEv3-SMU-Patch
  BC250-DXEv3-SMU-Unlock
)

echo "== initializing submodules"
git -C "$ROOT" submodule update --init --recursive

mkdir -p "$OUT"
rm -f "$OUT"/*.ffs "$OUT"/*.efi

for d in "${DRIVERS[@]}"; do
  if [[ ! -x "$ROOT/$d/build_ffs.sh" ]]; then
    echo "error: $d is missing build_ffs.sh (submodule not initialized?)" >&2
    exit 1
  fi
  echo
  echo "== building $d"
  ( cd "$ROOT/$d" && ./build_ffs.sh )
  find "$ROOT/$d/Build/Output" -maxdepth 1 -type f \( -name '*.ffs' -o -name '*.efi' \) -exec cp -f {} "$OUT/" \;
done

echo
echo "== collected FFS/EFI files in $OUT"
ls -1 "$OUT"
