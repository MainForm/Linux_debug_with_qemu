# Debugging Linux via Qemu
### 1. Installing the required package
```bash
sudo apt install sed make binutils build-essential diffutils bash patch gzip bzip2 perl tar cpio unzip rsync file bc findutils libncurses5-dev libncursesw5-dev bzr curl cvs git mercurial openssh-server subversion
```

### 2. Pulling the buildroot from the github
```bash
git submodule update --init
```

### 3. Building the linux to debug
```bash
# Create the output folder to build linux
cd buildroot
make O=../output BR2_EXTERNAL=.. outputmakefile

# move to output folder and set up the target board
cd ../output
make qemu_aarch64_virt_debug_defconfig

# build linux
make
```

### 4. Debugging linux
```bash
# move to top of project
cd ..

# run qemu to debug linux
make qemu_debug

# attach to qemu server to debug linux via gdb
make gdb
```