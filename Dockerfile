# Ruby version.
FROM ruby:2.6.5
MAINTAINER paulhtrott@gmail.com

# Argument for install dependency options.
ARG INSTALL_DEPENDENCIES

# Install dependencies.
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends ${INSTALL_DEPENDENCIES} \
    build-essential libpq-dev nodejs git \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

# Make directory for app.
RUN mkdir -p /app

# Set working directory.
WORKDIR /app

# Copy Gemfile and Gemfile.lock over to working directory.
COPY Gemfile Gemfile.lock ./

# Argument for bundle options.
ARG BUNDLE_INSTALL_ARGS

# Install bundler and install the Gemfile bundled gems.
# Clean up gems to reduce image size.
RUN gem install bundler && bundle install ${BUNDLE_INSTALL_ARGS} \
    && rm -rf /usr/local/bundle/cache/* \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the application over to working directory.
COPY . ./

# Set arg for RAILS_ENV to development.
ARG RAILS_ENV=development

# If Rails environment is production, compile the assets.
RUN if [ "$RAILS_ENV" = "production" ]; then SECRET_KEY_BASE=$(rake secret) bundle exec rake assets:precompile; fi

# Expose Port 3000 to the Docker host.
# EXPOSE 3000

# Run the rails server for container start command. Bind to all interfaces.
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
