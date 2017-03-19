# cryptsetup-arm-asuswrt


### HOWTO: Patch AsusWRT kernel to enable user-space interface for crypto algorithms
```
cd ~/asuswrt-merlin
patch -p2 -i ~/cryptsetup-arm-asuswrt/asuswrt_arm_dm-crypt+skcipher.patch
```

### HOWTO: Compile Cryptsetup with support for Veracrypt/Truecrypt
```
cd ~/cryptsetup-arm-asuswrt
./cryptsetup.sh
```
