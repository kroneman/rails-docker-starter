# Startup files for Using docker compose with rails

source documentation: https://docs.docker.com/compose/rails/

#### 1. Install dependencies

- [docker & docker-compose](https://docs.docker.com/compose/install/)

#### 2. Clone this repository and change directory to root

```sh
git clone https://github.com/kroneman/rails-docker-starter.git && cd rails-docker-starter
```

#### 3. Build the project

Generate files
```sh
docker-compose run web rails new . --force --no-deps --database=postgresql
```

Change ownership to non-root user (optional)
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

#### 6. Build databases

```sh
docker-compose run web rails db:create
```