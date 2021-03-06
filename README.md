# trainer

This is a trainer implemented in lua that relies on system-deps to work

This is the trainer (manager) system for [pakemon](https://github.com/notnullgames/pakemon). See [this](https://github.com/notnullgames/pakemon/wiki/Projects) for a full breakdown of the Pakémon ecosystem.


## dependencies

I will keep a running list of packagaes here, so you cna install them:

```
tor luajit lua-sec lua-filesystem lua-socket lua-copas lua-penlight lua-filesystem
```

In most distros they have similar names.


## usage

You will need valid SSL keys for client & server. You can generate some with this:

```
make keys
```


### docker

You can run a test-trainer in docker:

```
make trainer
```


### local

On debian-based distros:

```
sudo apt install tor luajit lua-sec lua-filesystem lua-socket lua-copas lua-penlight
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

Now you can start the service:

```
luajit trainer.lua
```

## commands

For pakemon and rattata, the commands are a single line, first is command, the rest are args

Example:

```
HELLO World
QUIT
```

Since `HELLO` takes 1 param (name) `World` is that.

Once we have all the commands worked out, I will document them here.

