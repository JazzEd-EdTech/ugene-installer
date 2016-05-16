#!/usr/bin/env python2

import os
import platform
import sys
import shutil

## Clean
if len(sys.argv) > 1 and sys.argv[1] == "clean" :
    print "Cleaning..."
    #rm -rf packages/**/data/*
    for f in os.listdir('packages'):
        if os.access('packages/'+f+'/data', os.F_OK):
            shutil.rmtree('packages/'+f+'/data/')
    exit()
## Check environment
if platform.system() != "Darwin" and os.environ.get('UGENE_i386_PATH') == None :
    print "UGENE_i386_PATH does not set."
    exit(1)
if os.environ.get('UGENE_x86_64_PATH') == None :
    print "UGENE_x86_64_PATH does not set."
    exit(1)
if platform.system() != "Darwin" and os.environ.get('EXT_TOOLS_i386_PATH') == None :
    print "EXT_TOOLS_i386_PATH does not set."
    exit(1)
if os.environ.get('EXT_TOOLS_x86_64_PATH') == None :
    print "EXT_TOOLS_x86_64_PATH does not set."
    exit(1)
if os.environ.get('CISTROME_PATH') == None :
    print "CISTROME_PATH does not set."
    exit(1)
if os.environ.get('RSCRIPT_PATH') == None :
    print "RSCRIPT_PATH does not set."
    exit(1)

if platform.system() == "Darwin":
    midPath="Contents/MacOS/"
else:
    midPath=""
## Copy data to directories
# systemType - i386, x86_64 or none
# installerToolNname - toolname in installer
# repoToolName - toolname in repo
# needRegExp - need regexp (1 or 0)
def copy_tool(systemType, installerToolName, repoToolName, needRegExp):

    if systemType != 'none':
       os.makedirs('packages/full.tools.'+systemType+'.'+installerToolName+'/data/'+midPath+'tools')
       toolName=repoToolName
       basePath=os.environ.get('EXT_TOOLS_'+systemType+'_PATH')
       if needRegExp :
           for f in os.listdir(basePath):
               if repoToolName in f:
                   toolName=f
           print toolName
       if os.access(basePath+"/"+toolName, os.F_OK):
           shutil.copytree(basePath+"/"+toolName,'packages/full.tools.'+systemType+'.'+installerToolName+'/data/'+midPath+'tools/'+toolName)
       else:
           print "Warning: Tool "+basePath+"/"+toolName+" not exist"
    else:
       os.makedirs('packages/full.tools.'+installerToolName+'/data/'+midPath+'tools')
       toolName=repoToolName
       basePath=os.environ.get('EXT_TOOLS_x86_64_PATH')
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


# ugene binaries 32-bit
if platform.system() != "Darwin" :
#    shutil.rmtree('packages/ugene.i386/data/')
    shutil.copytree(os.environ.get('UGENE_i386_PATH'),'packages/ugene.i386/data/')
    shutil.rmtree('packages/ugene.i386/data/data')
# ugene binaries 64-bit
#shutil.rmtree('packages/ugene.x86_64/data')
shutil.copytree(os.environ.get('UGENE_x86_64_PATH'),'packages/ugene.x86_64/data/')
shutil.rmtree('packages/ugene.x86_64/data/'+midPath+'data')
# ugene data
#shutil.rmtree('packages/ugene.data/data/')
shutil.copytree(os.environ.get('UGENE_x86_64_PATH')+'/'+midPath+'data','packages/ugene.data/data/'+midPath+'data')

# Create empty tools folder for correct windows (un)installer work
os.makedirs('packages/full.tools/data/'+midPath+'tools')
# external tools 32-bit
if platform.system() != "Darwin" :
    copy_tool("i386","bedtools2","bedtools2", True)
    copy_tool("i386","blast","blast",True)
    copy_tool("i386","blast+","blast+",True)
    copy_tool("i386","bowtie","bowtie-",True)
    copy_tool("i386","bowtie2","bowtie2-",True)
    copy_tool("i386","bwa","bwa",True)
    copy_tool("i386","clustalo","clustalo",True)
    copy_tool("i386","clustalw","clustalw",True)
    copy_tool("i386","cutadapt","cutadapt",True)
    copy_tool("i386","fastqc","fastqc",True)
    copy_tool("i386","mafft","mafft",True)
    copy_tool("i386","mrbayes","mrbayes",True)
    copy_tool("i386","perl","perl",True)
    copy_tool("i386","phyml","phyml",True)
    copy_tool("i386","samtools","samtools",True)
#bad named tools
    copy_tool("i386","CAP3","CAP3",False)
    copy_tool("i386","python","python",False)
    copy_tool("i386","spidey","spidey",False)
    copy_tool("i386","tcoffee","t-coffee",True)

# external tools 64-bit
copy_tool("x86_64","bedGraphToBigWig","bedGraphToBigWig",True)
copy_tool("x86_64","bedtools2","bedtools2",True)
copy_tool("x86_64","blast","blast",True)
copy_tool("x86_64","blast+","blast+",True)
copy_tool("x86_64","bowtie","bowtie-",True)
copy_tool("x86_64","bowtie2","bowtie2-",True)
copy_tool("x86_64","bwa","bwa",True)
copy_tool("x86_64","clustalo","clustalo",True)
copy_tool("x86_64","clustalw","clustalw",True)
copy_tool("x86_64","cufflinks","cufflinks",True)
copy_tool("x86_64","cutadapt","cutadapt",True)
copy_tool("x86_64","fastqc","fastqc",True)
copy_tool("x86_64","mafft","mafft",True)
copy_tool("x86_64","mrbayes","mrbayes",True)
copy_tool("x86_64","perl","perl",True)
copy_tool("x86_64","phyml","phyml",True)
copy_tool("x86_64","samtools","samtools",True)
copy_tool("x86_64","SPAdes","SPAdes",True)
copy_tool("x86_64","tophat","tophat",True)
#bad named tools
copy_tool("x86_64","CAP3","CAP3",False)
copy_tool("x86_64","python","python",False)
copy_tool("x86_64","spidey","spidey",False)
copy_tool("x86_64","tcoffee","t-coffee",True)

# cross platform external tools
copy_tool("none","snpEff","snpEff",True)
copy_tool("none","vcftools","vcftools",True)

# rscript
os.makedirs('packages/NGS.RScript/data/'+midPath+'tools')
rver = os.environ.get('RSCRIPT_PATH').split('-')
rver = rver[len(rver)-1]
shutil.copytree(os.environ.get('RSCRIPT_PATH'),'packages/NGS.RScript/data/'+midPath+'tools/R-'+rver)

# cistrome data
os.makedirs('packages/NGS.cistrome/data/'+midPath+'data')
shutil.copytree(os.environ.get('CISTROME_PATH'),'packages/NGS.cistrome/data/'+midPath+'data/cistrome')
