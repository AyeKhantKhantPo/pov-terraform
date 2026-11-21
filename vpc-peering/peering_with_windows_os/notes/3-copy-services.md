
# Step 2: Download fake-service Windows binary on local machine
curl -LO https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_windows_amd64.zip
unzip fake_service_windows_amd64.zip
chmod +x fake-service.exe

# Step 3: Copy both binaries directly to the Windows instance (uses ~/.ssh/config)
./copy-nssm-and-fake-sevice.sh