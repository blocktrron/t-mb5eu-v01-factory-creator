#!/bin/bash

# Path to OpenWrt sysupgrade image
FW_PATH=$1
WORK_PATH=work
FW_WORK_PATH=work/firmware

mkdir -p ${FW_WORK_PATH}
cp $FW_PATH ${FW_WORK_PATH}/UploadBrush-bin.img

get_firmware_model="TB-DM2-T-MB5EU-MT7621-CPE"
product_type="DM2-T-MB5EU"
old_version="TB-DM2-T-MB5EU-MT7621-CPE-DM2-T-MB5EU"

# This is ugly. But it is what the vendor does.
bin_random1=`md5sum ${FW_WORK_PATH}/UploadBrush-bin.img | awk '{print $1}'`
bin_random1=${bin_random1}`echo -n ${old_version} | md5sum | awk '{print $1}'`
bin_random1=`echo -n ${bin_random1} | md5sum | awk '{print $1}'`

echo -n $bin_random1 > ${FW_WORK_PATH}/bin_random_oem.txt
echo -n "99999999999999" > ${FW_WORK_PATH}/version.txt

cd ${FW_WORK_PATH}
tar -czf ../out_unenc.tar.gz *
cd ..

openssl aes-256-cbc -e -salt -in out_unenc.tar.gz -out out.enc -k "QiLunSmartWL"

fw_size=`ls -l out.enc | awk '{print $5}'`
target_fw_size=$((fw_size+32))
echo -n "DM2-T-MB5EU" >> out.enc

dd if=out.enc of=out.enc.bin bs=$target_fw_size count=1 conv=sync
rm -rf out.enc
cd ..

mv ${WORK_PATH}/out.enc.bin factory.bin
