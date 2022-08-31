FROM registry.revolt.org/software/containers/base-images:bullseye@sha256:446effbe45d93c44ad2b28e14bcde195310c19930b6cb11f1056c12bb3e8051f AS build

RUN apt-get -q update && env DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends ruby ruby-dev build-essential zlib1g-dev git ca-certificates
RUN gem install amber
ADD . /src
WORKDIR /src/amber
RUN amber rebuild

FROM registry.revolt.org/software/containers/apache2-base:no-masters@sha256:cbf1c32b2a8b370de9c39251f3c68d01dcee68dc82f4ed5a810d0e50b3a8915f

COPY --from=build /src/public /var/www/riseup.net/public
COPY provider.json /var/www/riseup.net
COPY docker/conf /tmp/conf
COPY docker/build.sh /tmp/build.sh

RUN /tmp/build.sh && rm /tmp/build.sh

EXPOSE 8080/tcp
