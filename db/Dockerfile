FROM mdillon/postgis

RUN apk update && \
    apk add -q --purge --no-progress bash wget sudo 

RUN mkdir -p /nola311/db

COPY . /nola311/db/.

WORKDIR /nola311/db

CMD ["/nola311/db/setup_container_db.sh"]
