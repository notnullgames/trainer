FROM bitnami/minideb

EXPOSE 12345/tcp

RUN install_packages luajit lua-sec lua-socket lua-copas tor
COPY torrc trainer.lua /app/
RUN sed -i 's/HiddenServiceDir ./HiddenServiceDir \/app/' /app/torrc

WORKDIR /app/
VOLUME /app/hidden_service

CMD chmod 700 /app/hidden_service && tor -f /app/torrc --runasdaemon 1 && luajit /app/trainer.lua
