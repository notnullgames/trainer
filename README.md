# trainer

This is a trainer implemented in lua that relies on system-deps to work


### setup

You will need luajit, copas, lua-sec, lua-luaossl, and lua-socket as well as tor installed. On debian-based distros:

```
sudo apt install luajit lua-sec lua-socket lua-copas tor
```

It will try to setup a running tor service, which you should disable:

```
sudo systemctl stop tor.service
sudo systemctl disable tor.service
```


After this, startup tor service using the included torrc:

```
tor -f torrc
```

Your address is in `./hidden_service/hostname`

You need to generate your ssl keys:

> **TODO** read more [here](https://www.scottbrady91.com/OpenSSL/Creating-RSA-Keys-using-OpenSSL)

```
luajit genkeys.lua
```


Now, you can run the lua server:

```
luajit trainer.lua
```

now you can connect using the local tor-relay

```
torsocks luajit client_rattata.lua <ADDRESS>.onion
```

and you can test the local (pakemon) service:

```
luajit client_pakemon.lua
```