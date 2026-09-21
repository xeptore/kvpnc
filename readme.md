# Kerio VPN Client Docker Image

## Configure

1. Obtain the server's fingerprint:

   ```bash
   openssl s_client -connect SERVER_HOST:SERVER_PORT < /dev/null 2>/dev/null | openssl x509 -fingerprint -md5 -noout -in /dev/stdin
   ```

   **Note:** Default `SERVER_PORT` value is `4090`.

2. Create configuration file

   Store the following in `kerio-svc.conf` file:

   ```xml
   <config>
     <connections>
       <connection type="persistent">
         <server>SERVER_HOST</server>
         <port>SERVER_PORT</port>
         <username>USERNAME</username>
         <password>PASSWORD</password>
         <fingerprint>FINGERPRINT</fingerprint>
         <active>1</active>
       </connection>
     </connections>
   </config>
   ```

## Run

```sh
docker container run --pull=always --rm -it --name=kvpnc --device=/dev/net/tun --cap-add=NET_ADMIN --mount=type=bind,source=$(pwd)/kerio-svc.conf,target=/etc/kerio-kvc.conf,readonly ghcr.io/xeptore/kvpnc:latest
```

And once the VPN is connected, you can use a different shell to attach to the container:

```sh
docker container exec -it kvpnc bash
```

## Stop

Either press `^C` (control+c) to the shell the started the container, or execute the following command in a different shell:

```sh
docker container stop --time=5 --signal=INT kvpnc
```

## Credits

[@hienduyph](https://github.com/hienduyph)
