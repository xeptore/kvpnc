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
docker container run --pull=always --rm -it --name=kvpnc --privileged --mount=type=bind,source=$(pwd)/kerio-svc.conf,target=/etc/kerio-kvc.conf,readonly ghcr.io/xeptore/kvpnc:latest
```

And once the VPN is connected, you can use a different shell to attach to the container:

```sh
docker container exec -it kvpnc bash
```

## PostgreSQL Client Image

There is also `pgc` image provided, which is based on the main `kvpnc` image with `postgresql-client-common` and `postgresql-client-16` packages installed.

It can be run similar to the main image:

```sh
docker container run --pull=always --rm -it --name kvpnc --privileged --mount=type=bind,source=$(pwd)/kerio-svc.conf,target=/etc/kerio-kvc.conf,readonly ghcr.io/xeptore/kvpnc/pgc:latest
```

Example of dumping a database and saving the output file on host machine:

```sh
docker container exec -it kvpnc pg_dump --verbose --dbname=D --host=H --port=P --user=U --format=custom --file=o --compress=gzip:9 && docker container cp kvpnc:/o db.dump
```

Enter database password, and wait for the command to exit. Upon successful command completion, dump file should be available in the current directory as `db.dump`.

## Stop

Either press `^C` (control+c) to the shell the started the container, or execute the following command in a different shell:

```sh
docker container stop --time=5 --signal=INT kvpnc
```

## Credits

[@hienduyph](https://github.com/hienduyph)
