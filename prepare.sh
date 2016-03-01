#!/bin/bash

## Clean
if [ "$1" == "clean" ]; then 
  rm -rf packages/**/data/*
  exit 0;
fi
## Check environment
if [ -z "$UGENE_i386_PATH" ]; then 
  echo "UGENE_i386_PATH does not set."
  exit 1;
fi

if [ -z "$UGENE_x86_64_PATH" ]; then 
  echo "UGENE_x86_64_PATH does not set."
  exit 1;
fi

if [ -z "$EXT_TOOLS_i386_PATH" ]; then 
  echo "EXT_TOOLS_i386_PATH does not set."
  exit 1;
fi

if [ -z "$EXT_TOOLS_x86_64_PATH" ]; then 
  echo "EXT_TOOLS_x86_64_PATH does not set."
  exit 1;
fi

if [ -z "$CISTROME_PATH" ]; then 
  echo "CISTROME_PATH does not set."
  exit 1;
fi

if [ -z "$RSCRIPT_PATH" ]; then 
  echo "RSCRIPT_PATH does not set."
  exit 1;
fi

## Copy data to directories
function copy_tool(){ # $1 - i386, x86_64 or none, $2 - toolname in installer, $3 - toolname in repo, $4 - need regexp (1 or 0)
  if [ "$1" != "none" ]; then
    mkdir -p packages/full.tools.$1.$2/data/tools
    if [ "$1" == "i386" ]; then
      if [ "$4" == "1" ]; then
        TOOL_PATH=`find $EXT_TOOLS_i386_PATH -type d -name "$3[-_]*[1-9\-_a-Z]*"`
      else
        TOOL_PATH=$EXT_TOOLS_i386_PATH/$3
      fi
      cp -r $TOOL_PATH packages/full.tools.$1.$2/data/tools
    else
      if [ "$4" == "1" ]; then
        TOOL_PATH=`find $EXT_TOOLS_x86_64_PATH -type d -name "$3[-_]*[1-9\-_a-Z]*"`
      else
        TOOL_PATH=$EXT_TOOLS_x86_64_PATH/$3
      fi
      cp -r $TOOL_PATH packages/full.tools.$1.$2/data/tools
    fi
  else
    mkdir -p packages/full.tools.$2/data/tools
    if [ "$4" == "1" ]; then
      TOOL_PATH=`find $EXT_TOOLS_i386_PATH -type d -name "$3[-_]*[1-9\-_a-Z]*"`
    else
      TOOL_PATH=$EXT_TOOLS_i386_PATH/$3
    fi
    cp -r $TOOL_PATH packages/full.tools.$2/data/tools
  fi
}

# ugene binaries 32-bit
cp -r $UGENE_i386_PATH/* packages/ugene.i386/data/
rm -rf packages/ugene.i386/data/data
# ugene binaries 64-bit
cp -r $UGENE_x86_64_PATH/* packages/ugene.x86_64/data/
rm -rf packages/ugene.x86_64/data/data
# ugene data
cp -r $UGENE_i386_PATH/data packages/ugene.data/data/
# external tools 32-bit
copy_tool i386 bedtools2 bedtools2 1
copy_tool i386 blast blast 1
copy_tool i386 blast+ blast+ 1
copy_tool i386 bowtie bowtie 1
copy_tool i386 bowtie2 bowtie2 1
copy_tool i386 bwa bwa 1
copy_tool i386 clustalo clustalo 1
copy_tool i386 clustalw clustalw 1
copy_tool i386 cutadapt cutadapt 1
copy_tool i386 fastqc fastqc 1
copy_tool i386 mafft mafft 1
copy_tool i386 mrbayes mrbayes 1
copy_tool i386 phyml phyml 1
copy_tool i386 samtools samtools 1
#bad named tools
copy_tool i386 CAP3 CAP3 0
copy_tool i386 python python 0
copy_tool i386 spidey spidey 0
copy_tool i386 tcoffee t-coffee 1

# external tools 64-bit
copy_tool x86_64 bedGraphToBigWig bedGraphToBigWig 1
copy_tool x86_64 bedtools2 bedtools2 1
copy_tool x86_64 blast blast 1
copy_tool x86_64 blast+ blast+ 1
copy_tool x86_64 bowtie bowtie 1
copy_tool x86_64 bowtie2 bowtie2 1
copy_tool x86_64 bwa bwa 1
copy_tool x86_64 clustalo clustalo 1
copy_tool x86_64 clustalw clustalw 1
copy_tool x86_64 cufflinks cufflinks 1
copy_tool x86_64 cutadapt cutadapt 1
copy_tool x86_64 fastqc fastqc 1
copy_tool x86_64 mafft mafft 1
copy_tool x86_64 mrbayes mrbayes 1
copy_tool x86_64 phyml phyml 1
copy_tool x86_64 samtools samtools 1
copy_tool x86_64 SPAdes SPAdes 1
copy_tool x86_64 tophat tophat 1
#bad named tools
copy_tool x86_64 CAP3 CAP3 0
copy_tool x86_64 python python 0
copy_tool x86_64 spidey spidey 0
copy_tool x86_64 tcoffee t-coffee 1

# cross platform external tools
copy_tool none snpEff snpEff 1
copy_tool none vcftools vcftools 1

# cistrome data
mkdir -p packages/NGS.cistrome/data/data
cp -r $CISTROME_PATH packages/NGS.cistrome/data/data/
# rscript
mkdir -p packages/NGS.RScript/data/tools
cp -r $RSCRIPT_PATH packages/NGS.RScript/data/tools/
