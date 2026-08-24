# CAUTION: Not all cores may be able to be enabled. Uneven numbers of cores are not allowed (if more than one CCX is active), and the number of cores in each CCX must be equal.

Credit to https://github.com/rw-r-r-0644 for creating an implementation of the core mask write, smu unlock, and smu patch, which I used as a reference when making the DXE drivers.

- Rescue Mei

# Using the Patch

1) Ensure xdelta3 and md5sum are available
2) Place BC250_3.00_CHIPSETMENU.ROM in the Patch directory.
3) Run ApplyDeltaPatch.sh, which will generate the final BC250 bios rom file.
4) Verify the MD5 hash matches the following:

- d298267029fbbe9d29b0bfa0db5fbf9e  BC250_3.00_CHIPSETMENU.ROM
- 38b7f947d6d0fd7e296485524ccd8967  BC250_3.00_MeiMeiDXEv3.ROM
- 0eb8aef4e99409c406b615bb57c2f6e0  BC250_3.00_CHIPSETMENU-to-BC250_3.00_MeiMeiDXEv3.xdelta

5) If the hashes match, you should be set to flash it to the BC250 via whichever method you prefer.