#/bin/bash
source /root/ds3_java_cli-3.5.0/bin/auth-bpa
unset $VALUE
unset $OPERATION
OPERATION=${1}
VALUE=${2}


find_tapes(){
FILE_NAME=${VALUE}
tapes=$(/root/ds3_java_cli-3.5.0/bin/ds3_java_cli -c get_physical_placement -b gdc_backup -o ${FILE_NAME} --output-format json  --http | jq ".Data.result.Object[].PhysicalPlacement.Tapes[].BarCode" | sort -n | uniq | cut -d "\"" -f2)
echo "The file ${FILE_NAME} resides on the following tapes: "
echo "${tapes}"
}


find_object(){
TAPE_ID=${VALUE}
objects=$(/root/ds3_java_cli-3.5.0/bin/ds3_java_cli -c get_objects_on_tape -i ${TAPE_ID} --output-format json --http | jq ".Data.result[].name" | sort -n | uniq | cut -d "\"" -f2)
#echo "The tape ${TAPE_ID} has the following file parts: "
echo "${objects}"
}

if [ ${OPERATION} == "tapes" ]; then
    find_tapes
elif [ ${OPERATION} == "object" ]; then
    find_object
else
    echo "something went wrong"
fi
