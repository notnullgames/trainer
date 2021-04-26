# trainer

This is a trainer implemented in lua that relies on system-deps to work


## dependencies

You will need luajit, copas, lua-sec, and lua-socket as well as tor installed.


## docker

I included a Dockerfile, so you can test the trainer/

```
docker build -t trainer .
docker run --rm -it trainer -v ${PWD}/hidden_service:/app/hidden_service -p 12345:12345 -p 12346:12346
```


## local

On debian-based distros:

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


#### keys

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

### notes

Use control-port to generate a new circuit
```
echo -e 'AUTHENTICATE ""\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 9051
```
