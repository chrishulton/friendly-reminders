FROM phusion/passenger-ruby25

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init process
CMD ["/sbin/my_init"]

# Packages
RUN apt-get --quiet update && \
  apt-get --yes install \
  tzdata

# Set the app directory var
ENV APP_HOME /home/app
WORKDIR $APP_HOME

# Dependencies
COPY Gemfile* ./
RUN bundle install

# Enable passenger and nginx
RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default && \
  ln -sf /dev/stdout /var/log/nginx/access.log && \
  ln -sf /dev/stderr /var/log/nginx/error.log

ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf

COPY --chown=app:app . . 

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
