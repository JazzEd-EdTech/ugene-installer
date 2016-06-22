#!/usr/bin/env python2

import os
import platform
import sys
import shutil

## Clean
if len(sys.argv) > 1 and sys.argv[1] == "clean" :
    print "Cleaning..."
    for f in os.listdir('packages'):
        if os.access('packages/'+f+'/data', os.F_OK):
            shutil.rmtree('packages/'+f+'/data/')
    exit()

if len(sys.argv) > 1 and sys.argv[1] == "x32" :
    is32bit=True;

## Check environment
if os.environ.get('UGENE_PATH') == None :
    print "UGENE_PATH does not set."
    exit(1)
if os.environ.get('EXT_TOOLS_PATH') == None :
    print "EXT_TOOLS_PATH does not set."
    exit(1)
if not is32bit and os.environ.get('CISTROME_PATH') == None :
    print "CISTROME_PATH does not set."
    exit(1)
if not is32bit and os.environ.get('RSCRIPT_PATH') == None :
    print "RSCRIPT_PATH does not set."
    exit(1)

if platform.system() == "Darwin":
    midPath="Contents/MacOS/"
else:
    midPath=""
## Copy data to directories
# installerToolNname - toolname in installer
# repoToolName - toolname in repo
# needRegExp - need regexp (1 or 0)
def copy_tool(installerToolName, repoToolName, needRegExp):
    os.makedirs('packages/full.tools.'+installerToolName+'/data/'+midPath+'tools')
    toolName=repoToolName
    basePath=os.environ.get('EXT_TOOLS_PATH')
    if needRegExp :
      for f in os.listdir(basePath):
        if repoToolName in f:
          toolName=f
      print toolName
      if os.access(basePath+"/"+toolName, os.F_OK):
        shutil.copytree(basePath+"/"+toolName,'packages/full.tools.'+installerToolName+'/data/'+midPath+'tools/'+toolName)
      else:
        print "Warning: Tool "+basePath+"/"+toolName+" not exist"
    return


# ugene binaries
#shutil.rmtree('packages/ugene.x86_64/data')
shutil.copytree(os.environ.get('UGENE_PATH'),'packages/ugene/data/')
shutil.rmtree('packages/ugene/data/'+midPath+'data')
# ugene data
#shutil.rmtree('packages/ugene.data/data/')
shutil.copytree(os.environ.get('UGENE_PATH')+'/'+midPath+'data','packages/ugene.data/data/'+midPath+'data')

# Create empty tools folder for correct windows (un)installer work
os.makedirs('packages/full.tools/data/'+midPath+'tools')

# external tools
copy_tool("bedGraphToBigWig","bedGraphToBigWig",True)
copy_tool("bedtools2","bedtools2",True)
copy_tool("blast","blast",True)
copy_tool("blast+","blast+",True)
copy_tool("bowtie","bowtie-",True)
copy_tool("bowtie2","bowtie2-",True)
copy_tool("bwa","bwa",True)
copy_tool("clustalo","clustalo",True)
copy_tool("clustalw","clustalw",True)
copy_tool("cufflinks","cufflinks",True)
copy_tool("cutadapt","cutadapt",True)
copy_tool("fastqc","fastqc",True)
copy_tool("mafft","mafft",True)
copy_tool("mrbayes","mrbayes",True)
copy_tool("perl","perl",True)
copy_tool("phyml","phyml",True)
copy_tool("samtools","samtools",True)
copy_tool("SPAdes","SPAdes",True)
copy_tool("tophat","tophat",True)
#bad named tools
copy_tool("CAP3","CAP3",False)
copy_tool("cistrome","cistrome",False)
copy_tool("python","python",False)
copy_tool("spidey","spidey",False)
copy_tool("tcoffee","t-coffee",True)

# cross platform external tools
copy_tool("snpEff","snpEff",True)
copy_tool("vcftools","vcftools",True)

if is32bit:
    exit(0);
# rscript
os.makedirs('packages/NGS.RScript/data/'+midPath+'tools')
rver = os.environ.get('RSCRIPT_PATH').split('-')
rver = rver[len(rver)-1]
shutil.copytree(os.environ.get('RSCRIPT_PATH'),'packages/NGS.RScript/data/'+midPath+'tools/R-'+rver)

# cistrome data
os.makedirs('packages/NGS.cistrome/data/'+midPath+'data')
shutil.copytree(os.environ.get('CISTROME_PATH'),'packages/NGS.cistrome/data/'+midPath+'data/cistrome')
