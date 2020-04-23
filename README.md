# Installer for VATSIM - RG Berlin

This repository contains an initial installer to set up an EuroScope & AudioForVATSIM installation for
trainees of the RG Berlin. It contains the newest releases of EuroScope, AIRAC, ModeS, GRplugin and VCH.

## Required tools to create the Installer

The installer is written in ISS-files which can be interpreted by InnoSetup.
To download the newest files, it requires an extension of InnoSetup.

You need to download and install the following packages:
 * [InnoSetup] (https://jrsoftware.org/isinfo.php) - The installer generation tool
 * [Inno Download Plugin] (https://mitrichsoftware.wordpress.com/inno-setup-tools/inno-download-plugin/) - The InnoSetup extension

## Behavior of the installer

In a first step will the newest information about EuroScope and the AIRAC be downloaded and marked for installation.
Thereafter will be the newest versions of the ModeS- and VCH-plugin be downloaded.

All downloaded files will be extracted and installed into the installation directory.
The final stage configures some configuration files with the required information.
 * ATCStartup.bat - Replace the directory-marker by the installation directory
 * EDDT_Field.prf - Replace the directory-marker by the installation directory
 * EDDT_Field.prf - Replace the sector-file-marker by the downloaded AIRAC file
 * SectorFileProviderDescriptor.txt - Replace the sector-file-marker by the downloaded AIRAC file
 * settings/TWR.asr - Replace the directory-marker by the installation directory
 * settings/TWR.asr - Replace the sector-file-marker by the downloaded AIRAC file

## Remarks after installation

### Ground Radar

The ground radar plugin is initialy activated and uses [Stands](https://de.wiki.vatsim-germany.org/Tegel_Ground#Ziviler_Apron)
to assign stands to incoming traffic.

### AudioForVATSIM

If AudioForVATSIM suggest to perform an update, do so.
But you need to define %INSTALL_DIR%/AudioForVATSIM as the installation directory.
This is needed that the installer overwrites the current version of the audio module.
