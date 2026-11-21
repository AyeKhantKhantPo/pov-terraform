#!/bin/bash

set -e

echo "Copying to Customer Profile instance 01 ..."
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/nssm.exe profile-instance-01:"C:/Windows/System32/nssm.exe"
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/fake-service.exe profile-instance-01:"C:/fake-service.exe"

echo "Copying to Customer Profile instance 02 ..."
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/nssm.exe profile-instance-02:"C:/Windows/System32/nssm.exe"
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/fake-service.exe profile-instance-02:"C:/fake-service.exe"

echo "Copying to Account instance 01 ..."
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/nssm.exe account-instance-01:"C:/Windows/System32/nssm.exe"
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/fake-service.exe account-instance-01:"C:/fake-service.exe"

echo "Copying to Account instance 02 ..."
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/nssm.exe account-instance-02:"C:/Windows/System32/nssm.exe"
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/fake-service.exe account-instance-02:"C:/fake-service.exe"

echo "Copying to Statement instance 01 ..."
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/nssm.exe statement-instance-01:"C:/Windows/System32/nssm.exe"
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/fake-service.exe statement-instance-01:"C:/fake-service.exe"

echo "Copying to Statement instance 02 ..."
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/nssm.exe statement-instance-02:"C:/Windows/System32/nssm.exe"
scp /home/HninPhyu/HelloCloud/CAP/VPC_Intra_Region_Peering/manual/window_image/fake-service.exe statement-instance-02:"C:/fake-service.exe"

# rm -rf fake_service_linux_amd64.zip fake-service