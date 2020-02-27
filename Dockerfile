FROM alpine:3.11

LABEL maintainer="Ztj <ztj1993@gmail.com>"

ADD . /flarum

RUN echo "http://mirrors.aliyun.com/alpine/v3.11/main" > /etc/apk/repositories \
  && echo "http://mirrors.aliyun.com/alpine/v3.11/community" >> /etc/apk/repositories \
  && apk update \
  && apk search -qe php7-* | grep -v gmagick | xargs apk add \
  && sed -i 's/^#ServerName.*/ServerName localhost/' /etc/apache2/httpd.conf \
  && sed -i "s@Require ip 127@Require ip 127 192 10@" /etc/apache2/conf.d/info.conf \
  && sed -i "s@AllowOverride None@AllowOverride All@" /etc/apache2/httpd.conf \
  && sed -i "s@AllowOverride none@AllowOverride all@" /etc/apache2/httpd.conf \
  && sed -i "s@^#LoadModule rewrite_module@LoadModule rewrite_module@" /etc/apache2/httpd.conf \
  && sed -i "s@^#LoadModule info_module@LoadModule info_module@" /etc/apache2/httpd.conf \
  && mkdir -p /run/apache2 \
  && ln -sf /dev/stdout /var/log/apache2/access.log \
  && ln -sf /dev/stderr /var/log/apache2/error.log \
  && rm -rf /var/cache/apk/* \
  && rm -rf /var/www/localhost/htdocs \
  && ln -s /flarum/public /var/www/localhost/htdocs \
  && find /flarum -type d -exec chmod 755 {} \; \
  && find /flarum -type f -exec chmod 644 {} \; \
  && find /flarum -type f -exec chmod 644 {} \; \
  && chmod 744 /flarum/flarum \
  && chown -R apache:apache /flarum

EXPOSE 80/tcp

VOLUME /flarum/public/assets

WORKDIR /flarum

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
