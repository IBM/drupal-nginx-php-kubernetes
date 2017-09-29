FROM nginx

# Set consistent timezone
ENV CONTAINER_TIMEZONE="UTC"
RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

RUN rm /etc/nginx/conf.d/default.conf

COPY fastcgi.conf /etc/nginx/conf.d/

EXPOSE 80

# Configure the read/write volume for a non-root user
COPY index.html /root/html/
COPY start.sh /root/start.sh
RUN chmod 755 /root/start.sh

ENTRYPOINT ["/root/start.sh"]
