# trainer

This is a trainer implemented in lua that relies on system-deps to work


### setup

You will need luajit, lua-sec, and lua-socket as well as tor installed. On debian-based distros:

```
sudo apt install luajit lua-sec lua-socket tor
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

Now, you can run the lua server:

```
luajit trainer.lua
```

now you can connect using the local tor-relay

```
torsocks luajit client_test.lua <ADDRESS>.onion 80
```