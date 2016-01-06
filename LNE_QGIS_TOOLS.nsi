;NSIS Script to create the installation package to deploy QGIS-tools for LNE
;Written by Kay Warrie

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "LNE QGIS Tools"
  OutFile "build\LNE_QGIS_tools.exe"

  ;Default installation folder
  InstallDir "$PROFILE\.qgis2\python\plugins"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_ICON "icon.ico"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "Panel.bmp" 
  !define MUI_WELCOMEPAGE_TITLE "QGIS-tools voor LNE" 
  !define MUI_WELCOMEPAGE_TEXT "De QGIS-tools voor LNE zijn een reeks plugins voor QGIS. Ze zijn speciefiek ontwikkeld voor de gebruikers van LNE aan de hand van hun vragen en behoeften.  Met deze tool kan je deze tools installeren, op je eigen gebruikersprofiel"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "gpl.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "Dutch"

;--------------------------------
;Installer Sections

SectionGroup /e "QGIS-Plugins"

Section ;always executed, is hidden for user
	;Add stuff that should be hidden from user here

SectionEnd

Section "QLR-loader" qlrLoader

  SetOutPath "$INSTDIR\qlrLoader"

  File /r "inputs\qlrLoader\*"

SectionEnd

Section "Stijl laden" styleLoad

  SetOutPath "$INSTDIR\styleLoad"

  File /r "inputs\styleLoad\*"

SectionEnd

SectionGroupEnd

;Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${qlrLoader} "Een tool om QLR-files te laden via een knop op de toolbalk."
	!insertmacro MUI_DESCRIPTION_TEXT ${styleLoad} "Een tool om QML-files te laden een dockvenster."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------

