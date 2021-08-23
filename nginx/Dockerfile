FROM ubuntu:focal

LABEL name="nginx"
LABEL version="1.0"
LABEL maintainer="Admin"

RUN apt update -y \
    && apt install nginx curl -y \
    && apt install software-properties-common -y \
    && apt install certbot -y \
    && apt update -y \
    && apt install python3-certbot-nginx -y \
    && apt clean all && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
