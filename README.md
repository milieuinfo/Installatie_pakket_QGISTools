
Install package for the QGIS-tools for LNE
====

NSIS-scripts that will install the different QGIS-tools developed for LNE.

There are 2 versions:
- LNE_QGIS_TOOLS.nsi: will only write the tools into the user profile, can be uninstalled from within QGIS.
- LNE_QGIS_TOOLS_admin.nsi will also write registry keys and a uninstaller, for administrative installs.

The inputs folder is left empty deliberately and should be filled with the latest compiled version of the different tools.  

In the build-folder will contain the installer after you run the scripts. 