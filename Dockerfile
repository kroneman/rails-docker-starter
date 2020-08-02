FROM ruby:2.5

# Install Dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Create working Directory
RUN mkdir /myapp
WORKDIR /myapp

# Copy install files into working directory
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose internal port
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]