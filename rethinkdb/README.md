
# rethinkdb

- [rethinkdb](https://www.rethinkdb.com/)


#### docker setup
```
docker run -p 8080:8080 -p 28015:28015 -p 29015:29015 -P --name rethink-server -d rethinkdb

- admin dashboard
https://localhost:8080

r.db('test').table('testing')

r.db('test').table('testing').insert({
  name: 'test',
  age: 10
})
```
