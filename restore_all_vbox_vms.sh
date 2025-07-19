#!/bin/bash

# restores a snapshot of virtual box VMs
# considering that all VMs and snapshots have identical names, like node1, node2, Snapshot1, Snapshot2 etc.

vmname=node
snapname="Snapshot 1"

# stop all nodes
for n in {1..5}; do  
  VBoxManage controlvm "$vmname$n" acpipowerbutton > /dev/null 2>&1
done

ec=$?
if [[ "$ec" -eq 0 ]];
then
  echo "[SUCCESS] all managed nodes stopped"
else
  echo "[FAIL] managed nodes did not stop"  
fi

sleep 3 

# restore "$snapname" on all nodes
for n in {1..5}; do
  VBoxManage snapshot "$vmname$n" restore "$snapname" > /dev/null 2>&1
done

ec=$?
if [[ "$ec" -eq 0 ]]; 
then
  echo "[SUCCESS] $snapname restored on all managed nodes"
else 
  echo "[FAIL] managed nodes did not restore"  
fi

# restore "$snapname" on all nodes
for n in {1..5}; do
  VBoxManage startvm --type=headless "$vmname$n" > /dev/null 2>&1
done

ec=$?
if [[ "$ec" -eq 0 ]];
then
  echo "[SUCCESS] all managed nodes started"
else
  echo "[FAIL] managed nodes did not start"
fi

sleep 7
vboxmanage list --long vms | egrep -E "State|Name"
