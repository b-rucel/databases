
# postgres

- [postgres](https://www.postgresql.org/)

- [install](#install)
- [basic psql usage](#basic-psql-usage)
- [user management](#user-management)


#### install
https://www.postgresql.org/download/
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

- mac
brew install postgresql

- docker
```sh
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

**Persistent volumes:**
```sh
# Create a named volume for data persistence
docker volume create postgres-data

# Run with volume mounted
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydatabase \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  -d postgres

# Or use bind mount to host directory
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydatabase \
  -p 5432:5432 \
  -v /path/on/host:/var/lib/postgresql/data \
  -d postgres

# postgres 18 is on new data dir
/var/lib/postgresql/18/docker
psql --version
psql (PostgreSQL) 18.0 (Debian 18.0-1.pgdg13+3)

# List volumes
docker volume ls

# Inspect volume
docker volume inspect postgres-data

# Remove volume (data will be deleted!)
docker volume rm postgres-data
```

- docker-compose
```yml
  postgres:
    image: postgres
    container_name: postgres
    restart: always
    ports:
      - 5432:5432
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: example
    volumes:
      - db-data:/etc/data
```
---


#### basic psql usage
**Connections:**
```sh
# Connect to PostgreSQL (local)
psql -U username -d database_name

# Connect to PostgreSQL (remote host)
psql -h hostname -p 5432 -U username -d database_name

# Connect with password prompt
psql -U username -d database_name -W

# Connection string format
psql "postgresql://username:password@hostname:5432/database_name"

# Connect from within psql
\c database_name              -- Switch database (same user)
\c database_name username     -- Switch database and user
\c database_name username hostname port  -- Full connection switch
```

**Meta-commands (backslash commands):**
```sql
\l              -- List all databases
\c dbname       -- Connect to a database
\dt             -- List all tables in current database
\d tablename    -- Describe a table structure
\du             -- List all users/roles
\dn             -- List all schemas
\df             -- List all functions
\dv             -- List all views
\q              -- Quit psql
\h              -- Help on SQL commands
\?              -- Help on psql commands
```

**Database operations:**
```sql
-- Create a new database
CREATE DATABASE testdb;

-- Drop a database
DROP DATABASE testdb;

-- Switch to a database
\c mydatabase
```

**Table operations:**
```sql
-- Create a table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Show table structure
\d users

-- List all tables
\dt

-- Drop a table
DROP TABLE users;
```

**Basic queries:**
```sql
-- Insert data
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');

-- Select data
SELECT * FROM users;
SELECT name, email FROM users WHERE id = 1;

-- Update data
UPDATE users SET name = 'Bob' WHERE id = 1;

-- Delete data
DELETE FROM users WHERE id = 1;

-- Count rows
SELECT COUNT(*) FROM users;
```

**Useful tips:**
- End SQL statements with semicolon `;`
- Use `\x` to toggle expanded display (useful for wide tables)
- Use `\timing` to show query execution time
- Use `CTRL+C` to cancel current input
- Use arrow keys to navigate command history
---


#### user management
**Creating users:**
- The `POSTGRES_USER` environment variable creates a superuser when the container is initialized
- In the example above, `myuser` is created as a superuser with the specified password
- If `POSTGRES_USER` is not specified, the default superuser is `postgres`

**Accessing as root/superuser:**
```sh
# If you set POSTGRES_USER=myuser, connect as:
psql -U myuser -d mydatabase

# If you didn't set POSTGRES_USER, the default superuser is 'postgres':
psql -U postgres -d postgres

# From outside the container:
docker exec -it postgres-db psql -U myuser -d mydatabase
docker exec -it postgres-db psql -U postgres
```

**Creating additional users:**
```sql
-- Connect as superuser first, then:
CREATE USER newuser WITH PASSWORD 'password123';

-- Grant privileges to the user:
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO newuser;

-- Create user with specific roles:
CREATE USER readonly WITH PASSWORD 'pass' NOSUPERUSER NOCREATEDB NOCREATEROLE;

-- List all users:
\du
```

**Important notes:**
- The superuser created via `POSTGRES_USER` has full admin privileges (equivalent to root)
- The default `postgres` user only exists if you don't specify `POSTGRES_USER`
- Users are cluster-wide but database access must be explicitly granted
- Always use strong passwords in production environments
---




