# cryptsetup-arm-asuswrt

It's possible to mount a Veracrypt or Truecrypt formatted device on your Asus ARM router.  However, a custom firmware is necessary.  As of March 20, 2017, all Asus ARM routers use Linux kernel 2.6.36.4. Therefore, a backport from Linux 2.6.38.8 to include the `algif_skcipher` kernel module and the user-space interface to the kernel cryptoAPI, is needed.  

The `cryptsetup` program must also be compiled without `--disable-kernel_crypto`.  I found that the choice of crypto backend, for `cryptsetup`, makes a very big difference in the time to initially unlock a file container or device.  *Nettle* seems to be the fastest at 90 seconds on my RT-AC68U overclocked to 1200 MHz.  The crypto backends *gcrypt* and *openssl* take more than 4 minutes each.

Once the file container or device has been unlocked, after typing the correct password, the encryption/decryption speed is very good.

### HOWTO: Compile Cryptsetup with Veracrypt/Truecrypt support for AsusWRT firmware
```
cd
git clone https://github.com/blackfuel/cryptsetup-arm-asuswrt.git
cd cryptsetup-arm-asuswrt
./cryptsetup.sh
```

### HOWTO: Patch AsusWRT to enable dm-crypt and the Linux kernel cryptoAPI
```
cd ~/asuswrt-merlin
patch -p2 -i ~/cryptsetup-arm-asuswrt/asuswrt_arm_dm-crypt+skcipher.patch
```

### Example: An encrypted file container, created on Microsoft Windows using Veracrypt, may now be opened on your Asus ARM router.
```
# first, use Veracrypt to create an encrypted file container named "vctest.img"
# then copy it to the router and run this script
losetup /dev/loop6 ./vctest.img

# you'll need my kernel patch (see above)
modprobe dm-mod
modprobe dm-crypt
modprobe gf128mul
modprobe xts
modprobe sha256_generic
modprobe sha512_generic  
modprobe algif_skcipher

cryptsetup -v --veracrypt tcryptOpen /dev/loop6 vctest
# now wait 5 minutes; yes, it takes a very long time
mkdir /mnt/vctest
mount /dev/mapper/vctest /mnt/vctest
# now copy some files that you want encrypted, to the /mnt/vctest folder
umount /mnt/vctest
cryptsetup -v tcryptClose vctest
losetup -d /dev/loop6
```
