#!/bin/bash

set -e

echo "Copying to Customer Profile instance 01 ..."
scp certfiles/rootcert.pem profile-instance-01:C:/Temp/account-root-ca.cer

echo "Copying to Account instance 01 ..."
scp certfiles/account-root-ca.pem account-instance-01:/home/ubuntu/
scp certfiles/profile-root-ca.pem account-instance-01:/home/ubuntu/
scp certfiles/statement-root-ca.pem account-instance-01:/home/ubuntu/

echo "Copying to Statement instance 01 ..."
scp certfiles/account-root-ca.pem statement-instance-01:/home/ubuntu/
scp certfiles/profile-root-ca.pem statement-instance-01:/home/ubuntu/
scp certfiles/statement-root-ca.pem statement-instance-01:/home/ubuntu/


echo "Copying to Customer Profile instance 02 ..."
scp certfiles/profile-root-ca.pem profile-instance-02:/home/ubuntu/
scp certfiles/account-root-ca.pem profile-instance-02:/home/ubuntu/
scp certfiles/statement-root-ca.pem profile-instance-02:/home/ubuntu/


echo "Copying to Account instance 02..."
scp certfiles/profile-root-ca.pem account-instance-02:/home/ubuntu/
scp certfiles/account-root-ca.pem account-instance-02:/home/ubuntu/
scp certfiles/statement-root-ca.pem account-instance-02:/home/ubuntu/


echo "Copying to Statement instance 02 ..."
scp certfiles/profile-root-ca.pem statement-instance-02:/home/ubuntu/
scp certfiles/account-root-ca.pem statement-instance-02:/home/ubuntu/
scp certfiles/statement-root-ca.pem statement-instance-02:/home/ubuntu/
