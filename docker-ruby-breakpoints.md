# Setting up breakpoints with ruby, docker & rails

#### 1. Complete the steps in the the root [readme file](./readme.md)

You should have generated a rails application that runs in docker at this point.

#### 2. Add gems to local development

add ruby-debug-ide gem
```ruby
group :development do
  # more gems
  gem 'ruby-debug-ide'
  # more gems
end
```

add debase gem
```ruby
group :development do
  # more gems
  gem 'debase'
  # more gems
end
```

#### 3. Rebuild the docker container to apply changes

```
docker-compose build
```

#### 4. Start the debugger and the application

Without docker this looks something like this
```sh
rdebug-ide --host <debug_ip> --port <debug_port> -- bin/rails s -p <app_port> -b <app_ip>
```

In our case we add it to the docker-compose file.

Update the line from the initial setup
```yml
command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
```

and change it to
```yml
command: bash -c "rm -f tmp/pids/server.pid && rdebug-ide --host '0.0.0.0' --port 9000 --dispatcher-port 26162 -- bin/rails s -p 3000 -b '0.0.0.0'"
```

and map the debug port to the host port as well

```yml
ports:
  - "9000:9000"
```

your full docker-compose file will look similar to

```yml
version: '3'
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && rdebug-ide --host '0.0.0.0' --port 9000 --dispatcher-port 26162 -- bin/rails s -p 3000 -b '0.0.0.0'"
    # command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
      - "9000:9000"
    depends_on:
      - db
```

#### 5. Add a launch.json file to your project

```
mkdir -p .vscode && touch ./.vscode/launch.json
```

and paste the following into that file

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Attach to Docker",
            "type": "Ruby",
            "request": "attach",
            "remotePort": "9000",
            "remoteHost": "0.0.0.0",
            "remoteWorkspaceRoot": "/myapp",
            "cwd": "${workspaceRoot}",
        }
    ]
}
```

`remotePort` corresponds to the config in the docker-compose file

`remoteHost` should be 0.0.0.0 or localhost

`remoteWorkspaceRoot` corresponds to the Dockerfile and docker-compose volume mapping

#### 6. Spin up rails server & launch debugger

```
docker-compose up
```

1. Set some breakpoints in a controller
2. Hit cmd + shift + D and press play. (this should start rails)
3. Alternatively press F5
4. Refresh the page related to a given controller with a breakpoint in it

resources: 

https://share.atelie.software/using-visual-studio-code-to-debug-a-rails-application-running-inside-a-docker-container-3416918d8cc8