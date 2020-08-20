#!/bin/bash
if [[ $# == 0 ]]; then
  echo -e "usage ./createvm.sh name;\n name 表示虚拟机名称;\n";
  exit;
fi


if [[ $1 = "-h" ]]; then
  echo -e "usage ./createvm.sh name;\n name 表示虚拟机名称;\n";
  exit;
fi

cp CentOS-7-x86_64-GenericCloud-2003.qcow2 $1.qcow2
cp template.xml $1.xml;
sed -i "s/{{name}}/${1}/g" $1.xml;

echo -e "添加虚拟机定义;\n";
virsh define ${1}.xml;

if [[ $2 =~ ^[1-9]{1}([0-9]+)G$ ]]; then
  echo -e "添加磁盘;\n"
  qemu-img create -f qcow2 ${1}_store.qcow2 200G
  virsh attach-disk --domain $1 --source ${1}_store.qcow2 --target vdb --targetbus virtio --driver qemu --subdriver qcow2 --sourcetype file --cache none --persistent
fi

echo -e "启动虚拟机;\n"
virsh start ${1};
