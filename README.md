# cryptsetup-arm-asuswrt

It's possible to mount a Veracrypt or Truecrypt formatted device on the Asus ARM router.  However, a custom firmware is necessary.  As of March 20, 2017, all Asus ARM routers use Linux kernel 2.6.36.4. Therefore, a backport from Linux 2.6.38.8 to add the `algif_skcipher` kernel module and the socket interface for user-space crypto algorithms is needed.  

The `cryptsetup` program must also be compiled without `--disable-kernel_crypto`.  I found that the choice of crypto backend, for `cryptsetup`, makes a very big difference in the time to unlock a file container or device.  *Nettle* seems to be the fastest at 90 seconds on my RT-AC68U overclocked to 1200 MHz.  The crypto backends *gcrypt* and *openssl* take more than 4 minutes each.  And, still trying to get the *kernel* crypto backend to work.

### Clone the project and let's get begin.
```
cd
git clone https://github.com/blackfuel/cryptsetup-arm-asuswrt.git
cd cryptsetup-arm-asuswrt
```

### HOWTO: Patch AsusWRT kernel to enable dm-crypt, hashes, ciphers, and the user-space socket interface to kernel crypto algorithms for Veracrypt/Truecrypt support
```
cd ~/asuswrt-merlin
patch -p2 -i ~/cryptsetup-arm-asuswrt/asuswrt_arm_dm-crypt+skcipher.patch
```

### HOWTO: Compile Cryptsetup with support for Veracrypt/Truecrypt
```
cd ~/cryptsetup-arm-asuswrt
./cryptsetup.sh
```
