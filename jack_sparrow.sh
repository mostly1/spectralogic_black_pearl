#!/bin/bash
#
#Author: Jeff Mazzone 3-29-2018
#This script is to quickly test functionality of the blackpearl.
#this script also requires spectra's s3 client to be installed, working and configured correctly..
#https://github.com/SpectraLogic/ds3_java_cli/releases
#the 10G test file is can be uploaded, downloaded and deleted.
#choose a black pearl to connect to. either bpa or bpb.
#use the --verbose option after the command to see a full output.
#Commands are [ put | get | delete ]
#Example ./jack_sparrow.sh bpa put --verbose


#make sure black pearl is chosn so we can get the right auth file.
if [ -z ${1}  ]; then
    echo "Please enter a Black pearl server to connect to. (BPA or BPB)"
    echo "Example: ./jack_sparrow.sh bpa put --verbose"
    exit 0
fi

#filter for caps
if [ ${1} == "BPA" ] || [ ${1} == "bpa" ]; then
    source /root/ds3_java_cli-3.5.0/bin/auth-bpa
elif [ ${1} == "BPB" ] || [ ${1} == "bpb" ]; then
    source /root/ds3_java_cli-3.5.0/bin/auth-bpb
else
    echo "No source file found for ${1}"
    echo "Please enter a Black pearl server to connect to. (BPA or BPB)"
fi


ds3="/root/ds3_java_cli-3.5.0/bin/ds3_java_cli"
bucket="ops_bucket"
if [ -z ${4} ]; then
  file="\"tests/test_file2.txt\""
else
  file="\"tests/test_file${4}.txt\""
fi
#command functions.
case ${2} in
    put)
        put="put_object"
        ${ds3} -c ${put} -b ${bucket} -o ${file} --http ${3}
        ;;
    get)
        get="get_object"
        ${ds3} -c ${get} -b ${bucket} -o ${file} --http ${3}
        ;;
    delete)
        delete="delete_object"
        ${ds3} -c ${delete} -b ${bucket} -o ${file} --http ${3}
        ;;
    *)
	echo "you have entered an invalid option. Please choose put|get|delete"
        echo "You can add --verbose after each option to give a detailed output."
        ;;
esac

#show date of file after downloading but only show if "get" is called
if [ ${2} == "get" ]; then
    ls -lha tests/test_file2.txt
fi
