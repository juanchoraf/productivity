apt install -y qemu-system-x86 libvirt-daemon-system virt-manager virtiofsd
usermod -aG libvirt $USER

echo -e "\n IF you want to enable clipboard and folder sharing between the host and"    \
        "guest on windows you have to execute the following script on the guest:\n\n"  \
        "https://github.com/juanchoraf/productivity/blob/main/VMs/windows/install_virtio_guest_tools_windows.ps1\n"
