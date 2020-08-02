# Startup files for Using docker compose with rails

source documentation: https://docs.docker.com/compose/rails/

#### 1. Install dependencies

- [docker & docker-compose](https://docs.docker.com/compose/install/)

#### 2. Clone this repository and change directory to root

```sh
git clone <path-to-repo> && cd <path-to-repo>
```

#### 3. Build the project


Generate files
```sh
docker-compose run web rails new . --force --no-deps --database=postgresql
```

Change ownership to non-root user
```sh
sudo chown -R $USER:$USER .
```

Build image
```sh
docker-compose build
```

#### 3. Update Database configuration

Update `config/database.yml`

With

```yml
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: password
  pool: 5

development:
  <<: *default
  database: myapp_development


test:
  <<: *default
  database: myapp_test
```

#### 5. Start the containers

```sh
docker-compose up
```