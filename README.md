
Install package for the QGIS-tools for LNE
====

*I have create 2 ways of deploy QGIS-plugins without having go through the official channels:*

A Windows install package
----

NSIS-scripts that will install the different QGIS-tools developed for LNE.

There are 2 versions:
- LNE_QGIS_TOOLS.nsi: will only write the tools into the user profile, can be uninstalled from within QGIS.
- LNE_QGIS_TOOLS_admin.nsi will also write registry keys and a uninstaller, for administrative installs.

The inputs folder is left empty deliberately and should be filled with the latest compiled version of the different tools.  

In the build-folder will contain the installer after you run the scripts.


Repository generator
----

If you deploy the contents of plugin_server on a webserver and add {url_of_server}/plugins/plugins.xml to the plugins repository list the plugins will be available for installation just like other plugins. 

createPluginServerContent.py {url_of_server}    
    
For example, if running locally on localhost:


    createPluginRepoContent.py https://www.mercator.vlaanderen.be/qgis-plugins 
   
Then just add https://www.mercator.vlaanderen.be/qgis-plugins/plugins/plugins.xml to the list of repositories in QGIS:
Plugins > Manage and install Plugins > Settings > Plugin repositories > Add
