# trainer

This is a trainer implemented in lua that relies on system-deps to work


### setup

You will need luajit, copas, lua-sec, and lua-socket as well as tor installed. On debian-based distros:

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

```
mkdir -p hidden_service/ssl
cd hidden_service/ssl
echo "00" > file.srl

openssl req -out ca.pem -new -x509 # set a password 4-1024 chars, then hit enter for all other questions
openssl genrsa -out server.key 1024
openssl req -key server.key -new -out server.req # hit enter for all questions
openssl x509 -req -in server.req -CA ca.pem -CAkey privkey.pem -CAserial file.srl -out server.pem

openssl genrsa -out client.key 1024
openssl req -key client.key -new -out client.req # hit enter for all questions
openssl x509 -req -in client.req -CA ca.pem -CAkey privkey.pem -CAserial file.srl -out client.pem

rm *.key *.req *.srl
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