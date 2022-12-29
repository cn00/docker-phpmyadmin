FROM alpine
MAINTAINER Peter Leitzen <peter@leitzen.de>

ENV RELEASE_DATE 2022-05-11
ENV PHPMYADMIN_VERSION 5.2.0

ENV PHPMYADMIN_DIR /usr/share/webapps/phpmyadmin/
ENV PHPMYADNIN_PACKAGE phpMyAdmin-$PHPMYADMIN_VERSION-all-languages
ENV PHPMYADMIN_DOWNLOAD https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/$PHPMYADNIN_PACKAGE.zip

ENV REQUIRED_PACKAGES \
  apache2 \
  php81 \
  php81-apache2 \
  php81-bz2 \
  php81-ctype \
  php81-gd \
  php81-json \
  php81-mbstring \
  php81-mysqli \
  php81-openssl \
  php81-session \
  php81-zip \
  php81-zlib

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; apk update; \
  apk add -U --no-cache $REQUIRED_PACKAGES && \
  rm /usr/bin/php81

RUN \
  mkdir -p /usr/share/webapps && \
  cd /tmp && \
  wget -q -O pma.zip $PHPMYADMIN_DOWNLOAD ; unzip pma.zip && \
  mv $PHPMYADNIN_PACKAGE $PHPMYADMIN_DIR && \
  rm -fr $PHPMYADMIN_DIR/{setup,config.sample.inc.php} && \
  chown -R apache:apache $PHPMYADMIN_DIR && \
  echo "Done"

ADD config.inc.php $PHPMYADMIN_DIR
ADD phpmyadmin.conf /etc/apache2/conf.d/

RUN mkdir -p /run/apache2

WORKDIR $PHPMYADMIN_DIR

EXPOSE 80

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
