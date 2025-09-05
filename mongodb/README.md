
# mongodb

- [mongodb](https://www.mongodb.com/)

#### docker setup

```
docker run --name mongodb \
  -p 27017:27017 \
  -d mongodb/mongodb-community-server

docker exec -it mongodb /bin/bash
mongosh
```

