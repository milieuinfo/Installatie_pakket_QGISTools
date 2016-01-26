#!/usr/bin/env python
import sys, os, ConfigParser, glob, datetime
import zipfile

defaultPluginPage = 'http://localhost:8000'
currentDir = os.path.dirname(os.path.realpath(__file__))

def readIni(iniFile):
    meta ={}
    
    config = ConfigParser.ConfigParser()
    config.readfp( open(iniFile) )

    meta['name'] = config.get('general', 'name')
    meta['qgisMinimumVersion'] = config.get('general', 'qgisMinimumVersion')
    meta['description'] = config.get('general', 'description')
    if config.has_option('general', 'about'):
        meta['about'] = config.get('general', 'about')
    else:
        meta['about'] = ""
    meta['version'] = config.get('general', 'version')
    
    meta['author'] = config.get('general', 'author')
    meta['email'] = config.get('general', 'email')
    
    meta['repository'] = config.get('general', 'repository')
    meta['homepage'] = config.get('general', 'homepage')
    meta['tracker'] = config.get('general', 'tracker')
    
    meta['experimental'] = config.get('general', 'experimental')
    meta['tags'] = config.get('general', 'tags')
    return meta

def createPluginXML(metaParams, DLsite):
    head= """<?xml version = '1.0' encoding = 'UTF-8'?>
    <?xml-stylesheet type="text/xsl" href="../static/style/plugins.xsl" ?>
    <plugins>"""
    foot = "</plugins>"

    xml = head 
    count = 0
    
    for metaParam in metaParams:
        count += 1
        now = datetime.datetime.now().isoformat()
        DLpath = DLsite + '/download/' + metaParam['zip'] 

        xml += """<pyqgis_plugin name="{name}" version="{version}" plugin_id="{c}">
        <description><![CDATA[ {description} ]]></description>
        <about>{about}</about>
        <author_name>{author}</author_name>
        <version>{version}</version>
        <qgis_minimum_version>{qgisMinimumVersion}</qgis_minimum_version>
        <qgis_maximum_version>2.99</qgis_maximum_version>
        <file_name>{zip}</file_name>
        <download_url>{site}</download_url>
        <create_date>{now}</create_date>
        <update_date>{now}</update_date>
        <experimental>{experimental}</experimental>
        <deprecated>False</deprecated>
        <homepage>{homepage}</homepage>
        <tracker>{tracker}</tracker>
        <repository>{repository}</repository>
        <tags>{tags}</tags>
    </pyqgis_plugin>""".format(site=DLpath, now=now, c=count, **metaParam )
    
    xml += foot
    
    return xml

def zipPath(root, target):
    if os.path.exists( target ):
       os.remove(target)
    zipf = zipfile.ZipFile( target , 'w')
    
    files = []
    for path, subdirs, filenames in os.walk(root):
        for filename in filenames:
            files.append( os.path.join(path, filename) )
            
    for zfile in files: 
        sbase = os.path.dirname(root)
        arcName = zfile.replace( sbase ,"")
        zipf.write( zfile , arcName) 

    zipf.close() 

def main( pluginPage, cwd):
   metaParams = []
   pluginDir = cwd + "/inputs/"
   
   pluginMetadata = glob.glob( pluginDir + "*/metadata.txt")
   
   for ini in pluginMetadata:
       meta = readIni(ini)
       
       dir2zip = os.path.dirname(ini) 
       zipName = meta['name'].replace(' ', '_') + '.zip'
       zipTarget = os.path.join( cwd, 'plugin_server/download', zipName )
       zipPath(dir2zip, zipTarget)
       
       meta['zip'] = zipName
       metaParams.append(meta)
   
   with open( os.path.join(cwd, 'plugin_server/plugins/plugins.xml'), 'w') as plugins:
        plugins.write( createPluginXML(metaParams, pluginPage) )  
        
   
if __name__ == '__main__': 
    if len( sys.argv ) == 3:
        main(sys.argv[1],sys.argv[2])
    elif len( sys.argv ) == 2:
        main(sys.argv[1], currentDir)
    else:
        main( defaultPluginPage, currentDir)
        
        
