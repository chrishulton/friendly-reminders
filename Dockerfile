FROM phusion/passenger-ruby25

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init process
CMD ["/sbin/my_init"]

# Set the app directory var
ENV APP_HOME /home/app
WORKDIR $APP_HOME

# Dependencies
COPY Gemfile* ./
RUN bundle install

# Enable passenger and nginx
RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY --chown=app:app . . 

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
