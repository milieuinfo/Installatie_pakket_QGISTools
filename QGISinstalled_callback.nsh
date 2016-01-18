;Callback Functions for QGISinstalledUI
;Written by Kay Warrie

;includes
  !include "EnvVarUpdate.nsh"
  
;Global vars
  Var _DATA_DIR
  Var _Cbx_State
  
  ;set PluginDir var on init  
  Function .onInit
	StrCpy $pluginDir "$PROFILE\.qgis2\python\plugins"
  FunctionEnd
  
  Function updateInstallDirText
	${NSD_SetText} $hCtl_QGISinstalledUI_installDirText  $pluginDir
  FunctionEnd
  
  ;Find where QGIS is installed
  Function setInstallDirGlobal
	${NSD_GetState} $hCtl_QGISinstalledUI_globalCbx $_Cbx_State
	${If} ${BST_UNCHECKED} == $_Cbx_State
		Return
	${EndIf}
	 
    ${If} ${FileExists} "C:\OSGeo4W\apps\qgis\*.*"
	  StrCpy $pluginDir "C:\OSGeo4W\apps\qgis\python\plugins"
	${ElseIf} ${FileExists} "C:\OSGeo4W64\apps\qgis\*.*"
	  StrCpy $pluginDir "C:\OSGeo4W64\apps\qgis\python\plugins"
    ${ElseIf} ${FileExists} "C:\OSGeo4W\apps\qgis-ltr\*.*"
	  StrCpy $pluginDir "C:\OSGeo4W\apps\qgis-ltr\python\plugins"
	${ElseIf} ${FileExists} "C:\OSGeo4W64\apps\qgis-ltr\*.*"
	  StrCpy $pluginDir "C:\OSGeo4W64\apps\qgis-ltr\python\plugins"
	${Else}
	  StrCpy $pluginDir ""
	${EndIf}
	
	${If} $pluginDir == ""
		MessageBox MB_OK "Installatie folder van QGIS kon niet worden gevonden, stel zelf de applicatie folder in." 
		nsDialogs::SelectFolderDialog "Stel de installatie locatie van QGIS" 
		; Get folder
		Pop $_DATA_DIR
		; Check A Folder Has Been Selected
		${If} $_DATA_DIR == "error"
			${NSD_Check} $hCtl_QGISinstalledUI_localCbx
			${NSD_Uncheck} $hCtl_QGISinstalledUI_globalCbx
		${ElseIf} ${FileExists} "$_DATA_DIR\python\*.*"
			StrCpy $pluginDir "$_DATA_DIR\python\plugins"
		${Else}
		    ${NSD_Check} $hCtl_QGISinstalledUI_localCbx
			${NSD_Uncheck} $hCtl_QGISinstalledUI_globalCbx
			MessageBox MB_OK "Deze folder lijkt geen python\plugins folder te bevatten, ben je zeker dat dit de applicatie folder van je QGIS installatie is."
		${EndIf}
	${EndIf}
	Call updateInstallDirText
  FunctionEnd 
 
  ;set the pluginDir to local
  Function setInstallDirLocal
  	${NSD_GetState} $hCtl_QGISinstalledUI_localCbx $_Cbx_State
	${If} ${BST_UNCHECKED} == $_Cbx_State
		Return
	${EndIf}
  	 StrCpy $pluginDir "$PROFILE\.qgis2\python\plugins"
	 Call updateInstallDirText
  FunctionEnd 
 
 Function setInstallDirManual
	${NSD_GetState} $hCtl_QGISinstalledUI_manualCbx $_Cbx_State
	${If} ${BST_UNCHECKED} == $_Cbx_State
		Return
	${EndIf}
 
	nsDialogs::SelectFolderDialog "Stel de installatie locatie van QGIS" 
	Pop $_DATA_DIR
	; Check A Folder Has Been Selected
	${If} $_DATA_DIR == "error"
		${NSD_Check} $hCtl_QGISinstalledUI_localCbx
		${NSD_Uncheck} $hCtl_QGISinstalledUI_manualCbx
	${ElseIf} ${FileExists} "$_DATA_DIR\python\*.*"
		StrCpy $pluginDir "$_DATA_DIR\python\plugins"
	${Else}
		CreateDirectory  "$_DATA_DIR\python\plugins"
		StrCpy $pluginDir "$_DATA_DIR\python\plugins"
		     
		${EnvVarUpdate} $0 "QGIS_PLUGINPATH" "P" "HKCU" "$_DATA_DIR\python\plugins"
	${EndIf}
 
	Call updateInstallDirText
 FunctionEnd