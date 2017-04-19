#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

ARGSU=" ${list} ${SRA} "
LISTU="${list}"
echo "list file is " "${LISTU}"
echo "arguments are "${ARGSU}


if [ -n "${list}" -a -n "${SRA}" ]
  then
    >&2 echo "please provide a file OR a write the SRA accessions to download"
    debug
    exit 1;
fi

GENPATH="anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/"
CMDLINEARG=""

if [ -n "${list}" ]
  then
    filelist=$(<"${list}")
    for accession in ${filelist}
      do
        CMDLINEARGS+=${GENPATH}${accession:0:3}/${accession:0:6}/${accession}/${accession}.sra" "
      done
  else
    for accession in ${SRA}
      do
        CMDLINEARGS+=${GENPATH}${accession:0:3}/${accession:0:6}/${accession}/${accession}.sra" "
      done
fi

CMDLINEARGS+="/data"
echo ${CMDLINEARGS}

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/ncbi_sra_import:v0.0.0 >> lib/condorSubmitEdit.htc
echo arguments                          = ${CMDLINEARGS} >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/ncbi_sra_import/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
