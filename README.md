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

```bash
docker run -d --name keriovpn --privileged -v $(pwd)/kerio-svc.conf:/etc/kerio-kvc.conf ghcr.io/xeptore/kvpnc
```

## Credits

[@hienduyph](https://github.com/hienduyph)
