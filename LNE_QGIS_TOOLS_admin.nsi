;NSIS Script to create the installation package to deploy QGIS-tools for LNE
;Written by Kay Warrie
   Var pluginDir
;Includes
  !include "MUI2.nsh"
  !include "QGISinstalledUI.nsdinc"
  !include "QGISinstalled_callback.nsh"

;General

  ;Name and file
  Name "LNE QGIS Tools"
  OutFile "build\LNE_QGIS_tools_admin.exe"

  ;Default installation folder
  InstallDir "$PROFILE\.qgis2\python\plugins"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\LNE_QGIS_tools" ""

  ;Request application privileges
  RequestExecutionLevel user

  !define APPNAME "LNE_QGIS_Tools"
  !define COMPANYNAME "LNE"
  
;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_ICON "icon.ico"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "Panel.bmp" 
  !define MUI_WELCOMEPAGE_TITLE "QGIS-tools voor LNE" 
  !define MUI_WELCOMEPAGE_TEXT "De QGIS-tools voor LNE zijn een reeks plugins voor QGIS. Ze zijn speciefiek ontwikkeld voor de gebruikers van LNE aan de hand van hun vragen en behoeften.  Met deze tool kan je deze tools installeren, op je eigen gebruikersprofiel"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "gpl.txt"  
  
  Page custom fnc_QGISinstalledUI_Show
  
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
  RequestExecutionLevel user

  ;Languages
  !insertmacro MUI_LANGUAGE "Dutch"

;--------------------------------
;Installer Sections

SectionGroup /e "QGIS-Plugins"

Section ;always executed, is hidden for user
 ;set installdir to plugins
 StrCpy $INSTDIR $pluginDir
 ;Store installation folder
 WriteRegStr HKCU "Software\LNE_QGIS_tools" "" $INSTDIR
 ;Create uninstaller
 WriteUninstaller "$pluginDir\LNE_Uninstall.exe"
 ;Add icon
 SetOutPath $INSTDIR
 File "LNE_icon.ico"
 
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME}_${APPNAME}" "DisplayName" "QGIS-tools voor LNE"
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME}_${APPNAME}" "DisplayIcon" "$INSTDIR\LNE_icon.ico"
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME}_${APPNAME}" "UninstallString" "$\"$INSTDIR\LNE_Uninstall.exe$\""
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME}_${APPNAME}" "HelpLink" "https://github.com/milieuinfo/Installatie_pakket_QGISTools"
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME}_${APPNAME}" "Publisher" ${COMPANYNAME}
 
SectionEnd

Section "QLR-loader" qlrLoader

  SetOutPath "$INSTDIR\qlrLoader"
  File /r "inputs\qlrLoader\*"

SectionEnd

Section "Stijl laden" styleLoad

  SetOutPath "$INSTDIR\styleLoad"
  File /r "inputs\styleLoad\*"

SectionEnd

Section /o "Spatial Subset Query Tool" SpatialSubset

  SetOutPath "$INSTDIR\Spatial-Subset-Query-Tool"
  File /r "inputs\Spatial-Subset-Query-Tool\*"

SectionEnd

SectionGroupEnd

;Descriptions

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${qlrLoader} "Een tool om QLR-files te laden via een knop op de toolbalk."
    !insertmacro MUI_DESCRIPTION_TEXT ${styleLoad} "Een tool om QML-files te laden een dockvenster."
	!insertmacro MUI_DESCRIPTION_TEXT ${SpatialSubset} "Enkel nuttig voor Postgis gebruikers. Een tool om een van een postgis databank een specifieke subset laden op basis van de intersectie met een andere laag."
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------

;Uninstaller Section 
Section "Uninstall"

  ;Remove if installed
  ${If} ${FileExists} "$INSTDIR\qlrLoader\*.*"
	RMDir /r "$INSTDIR\qlrLoader"
  ${EndIf}
  ${If} ${FileExists} "$INSTDIR\styleLoad\*.*"
	RMDir /r "$INSTDIR\styleLoad"
  ${EndIf}
  ${If} ${FileExists} "$INSTDIR\Spatial-Subset-Query-Tool\*.*"
	RMDir /r "$INSTDIR\Spatial-Subset-Query-Tool"
  ${EndIf}
  
  ;Delete the uninstaller and uninstall directory
  Delete "$INSTDIR\LNE_Uninstall.exe"
  Delete "$INSTDIR\LNE_icon.ico"

  DeleteRegKey /ifempty HKCU "Software\LNE_QGIS_tools"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME}_${APPNAME}"

SectionEnd
