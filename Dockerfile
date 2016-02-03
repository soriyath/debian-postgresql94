FROM soriyath/debian-swissfr
MAINTAINER Sumi Straessle

RUN	DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install -y postgresql-9.4 postgresql-client-9.4 \
	&& apt-get install -y postgresql-contrib-9.4
USER postgres
RUN DEBIAN_FRONTEND=noninteractive /etc/init.d/postgresql start \
	&& pg_dropcluster --stop 9.4 main \
	&& pg_createcluster --start -e UTF-8 9.4 main \
	&& psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" \
	&& createdb -O docker docker \
	&& echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf \
	&& echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf
EXPOSE 5432
USER root

WORKDIR /srv/www
