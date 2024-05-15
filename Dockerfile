# Use a Ruby base image
FROM ruby:3.0.2-buster

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        nodejs \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install --jobs 4 --retry 3

# Copy the rest of the application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the Rails server
# CMD ["bundle", "exec", "rails", "db:migrate", "&&", "bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD bash -c 'rm -f /app/tmp/pids/server.pid && bundle exec rails db:create db:migrate && bundle exec rails server -b 0.0.0.0'
