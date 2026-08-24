# BC250-DXEv3-BIOSMOD
Central repo for the v3 of my bios patch, including three DXE drivers for CPU core unlock WITH ARBITRARY* CORE SELECTION, ACPI injection, SMU unlock, SMU patching, a new menu driver the leaves the original PXE boot functionality available, and cold boot for learning the factory core mask!

\* Special rules apply to the activation of cores. See https://github.com/RescueMei/BC250-DXEv3-Core-Unlock for more information

Drivers used:

- https://github.com/RescueMei/BC250-DXEv3-Menu-Driver
- https://github.com/RescueMei/BC250-DXEv3-SMU-Unlock
- https://github.com/RescueMei/BC250-DXEv3-SMU-Patch
- https://github.com/RescueMei/BC250-DXEv3-Cold-Boot
- https://github.com/RescueMei/BC250-DXEv3-Core-Unlock
- https://github.com/RescueMei/BC250-DXEv3-ACPI-Driver


# CAUTION: Not all cores may be able to be enabled. Uneven numbers of cores are not allowed (if more than one CCX is active), CCX0 MUST always have at least one enabled core, and the total number of cores in each CCX must be equal if both CCX0 and CCX1 are active.

Credit to https://github.com/rw-r-r-0644 for creating an implementation of the core mask write, smu unlock, and smu patch, which I used as a reference when making the DXE drivers.

## For how to use the patch to apply to the BC250_3.00_CHIPSETMENU.ROM BIOS, please see the bottom of this readme

# Why DXE Drivers?

This is so they can run before the OS to perform their tasks, and so they can perform them quickly. 

The Core Unlock driver and the SMU unlock driver can perform the smu exploit much faster than other methods of performing it at boot due to how early the DXE driver executes. 

The SMU patch driver performs the patch for 8 core reporting, but an OS side fix is required to properly handle it still.

The ACPI driver injects an appropriate ACPI table so it is already present for the OS to use for power management, without requiring the OS to have a separate method to load the table on its own outside of what is presented to it by the bios.

The Menu driver injects a menu into the factory bios that allows driver configuration without interfering with the factory bios options.

As DXE Drivers in the BIOS, they are unaffected by reinstallations of operating systems or changes to scripts. 

They are configured in "MeiMeiDXEv3 Menu" under the Advanced settings within the bios.


# Using the Patch

1) Ensure xdelta3 and md5sum are available
2) Place BC250_3.00_CHIPSETMENU.ROM in the Patch directory.
3) Run ApplyDeltaPatch.sh, which will generate the final BC250 bios rom file.
4) Verify the MD5 hash matches the following:

- d298267029fbbe9d29b0bfa0db5fbf9e  BC250_3.00_CHIPSETMENU.ROM
- 38b7f947d6d0fd7e296485524ccd8967  BC250_3.00_MeiMeiDXEv3.ROM
- 0eb8aef4e99409c406b615bb57c2f6e0  BC250_3.00_CHIPSETMENU-to-BC250_3.00_MeiMeiDXEv3.xdelta

5) If the hashes match, you should be set to flash it to the BC250 via whichever method you prefer.
