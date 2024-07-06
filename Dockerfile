FROM registry.revolt.org/software/containers/base-images:bullseye@sha256:892606d10ca4ba43b88db8045698c64a48435d089d56dfafa4374247c183b40b AS build

RUN apt-get -q update && env DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends ruby ruby-dev build-essential zlib1g-dev git ca-certificates
RUN gem install amber
ADD . /src
WORKDIR /src/amber
RUN amber rebuild

FROM registry.revolt.org/software/containers/apache2-base:no-masters@sha256:aafe426a72d29e5e9e20acb6d9d7e1ac5f1ed1cfc0289b81e124e75828f5da16

COPY --from=build /src/public /var/www/riseup.net/public
COPY provider.json /var/www/riseup.net
COPY docker/conf /tmp/conf
COPY docker/build.sh /tmp/build.sh

RUN /tmp/build.sh && rm /tmp/build.sh

EXPOSE 8080/tcp
