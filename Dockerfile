FROM ruby:2.3
MAINTAINER karthik vasudevan <karthikvasudev@zoho.com>

# To create user and group
RUN groupadd guestbook --gid 6156 && \
    useradd --home /home/guestbook --create-home --shell /bin/false --uid 6157 --gid 6156 guestbook

# Docker Ruby image has got the tricks that disallow it from running as a normal user, so here is the simple hack!!
ENV BUNDLE_APP_CONFIG .

# Run all the perks as guestbook.Taking ownership yeah !
USER guestbook

# Create and switch to the repo dir
ENV SRC_DIR /home/guestbook/app
ENV DATABASE_URL postgres://postgres:postgres123@guestbook.cr3qnf94ta63.eu-central-1.rds.amazonaws.com
#This is provisioned on AWS Elasticache cluster mode for high availablity.
ENV REDIS_HOST guestbook.9q7hng.ng.0001.euc1.cache.amazonaws.com
RUN mkdir $SRC_DIR
WORKDIR $SRC_DIR

#Its time to get the gems!!

#RUN git clone 
# First install gems
COPY Gemfile $SRC_DIR/
COPY Gemfile.lock $SRC_DIR/
RUN bundle install --deployment --without development test

# Now copy over rest of the app
# .dockerignore will ensure that unnecessary files aren't copied
COPY . $SRC_DIR

#Actually the final command depends on the ENV variable which should go first in hand
RUN printenv | grep DATABASE_URL
# This will be the default command
CMD bundle exec rackup -p9292 --host 0.0.0.0

