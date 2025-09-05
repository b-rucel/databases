
# postgres

- [postgres](https://www.postgresql.org/)


#### docker setup
```
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydatabase \
  -p 5432:5432 \
  -d postgres

docker ps -a
netstat -na -f inet | grep LISTEN | grep 5432

docker exec -it postgres-db /bin/bash
psql -U myuser -d mydatabase
--
docker exec -it postgres-db psql -U myuser -d mydatabase
```
