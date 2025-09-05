
# mariadb

- [mariadb](https://mariadb.org/)

#### docker setup
```
docker run -d --name mariadb_server \
  -e MARIADB_ROOT_PASSWORD=my_secret_password \
  -v mariadb_data:/var/lib/mysql \
  -p 3306:3306 \
  mariadb

docker ps -a
netstat -na -f inet | grep LISTEN | grep 3306
```

#### connect to mariadb server
```
docker exec -it mariadb_server /bin/bash
mariadb -u root -p

docker exec -it mariadb_server mariadb -u root -p
```
