FROM registry.revolt.org/software/containers/base-images:bullseye@sha256:33e68f47f7c29158dbb646bfd87bdaa08f18aed100610146d9ce22fafed4af93 AS build

RUN apt-get -q update && env DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends ruby ruby-dev build-essential zlib1g-dev git ca-certificates
RUN gem install amber
ADD . /src
WORKDIR /src/amber
RUN amber rebuild

FROM registry.revolt.org/software/containers/apache2-base:no-masters@sha256:188b7b4cdb545d1d8d5cbc9ae3ed937e40f639ccb8d5be4e574e106eb05f70b2

COPY --from=build /src/public /var/www/riseup.net/public
COPY provider.json /var/www/riseup.net
COPY docker/conf /tmp/conf
COPY docker/build.sh /tmp/build.sh

RUN /tmp/build.sh && rm /tmp/build.sh

EXPOSE 8080/tcp
