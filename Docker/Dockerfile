FROM seapy/ruby:2.2.0
MAINTAINER Rotatyy Dmitriy <flamine@list.com>

RUN apt-get update

# Install nodejs
RUN apt-get install -qq -y nodejs

# Install Nginx.
RUN apt-get -y install nginx

# Add default palladium nginx config
ADD palladium.conf /etc/nginx/sites-enabled/

# Install the latest postgresql lib for pg gem
RUN sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-common
RUN apt-get install -y postgresql-9.3 libpq-dev
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Install Rails App
WORKDIR /opt
RUN sudo apt-get install git
RUN git clone https://github.com/flaminestone/palladium.git
WORKDIR /opt/palladium
RUN bundle install

USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER root WITH SUPERUSER PASSWORD 'root';" &&\
    createdb -O root root
USER root
CMD bash -C '/opt/palladium/initializer.sh';'bash'

