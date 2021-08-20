# How to configure a website on Digital Ocean using Docker and Let's Encrypt

## Droplet creation

* Create a linux-based server (droplet) and add a domain with your domain name: `domainexample.com`.
* [Optional]: Rename the server.
* Generate an ssh key pair for accessing the server.
* Go to your domain name provider (like google domains):
    * In the external hosts settings (A, AAAA):
        * Add an `A` record with the IPv4 address of your server: `Type: A | TTL: 3600 | Data: 123.456.78.90`
        * [Optional] add an `AAAA` record with IPv6 address of your server: `Type: AAAA | TTL:3600 | Data: 1234:a880:1:1d1:2000`
    * In the subdomains (CNAME) add a redirect from `www.domainexample.com` to `domainexample.com`.
        * `Host name: www | Type: CNAME | TTL: 3600 | domainexample.com`
* Log into the server uring ssh: `ssh root@domainexample.com`
* Copy ssh id from host to server: `ssh-copy-id -i ~/.ssh/id_rsa.pub root@domainexample.com` - this should prompt for your password.
* Log in back again and edit the `etc/ssh/ssh_config`:
    * Uncomment `PasswordAuthentication` and set it to `no`.
    * Add `UsePAM` and set it to `no`.
    * Add `ChallengeResponseAuthentication` and set it to `no`.
* `systemctl reload sshd && systemctl restart sshd`
* `apt update -y && apt upgrade -y`

## Docker solution

Once you have launched all containers using `docker-compose up -d` you need to enter the `nginx` container and setup `SSL` inside of it:

*Note*: this will only work if you pointed your domain name to this IP address.

Once this is done you can check the proper configuration using a DNS lookup site.

```bash
docker exec -it nginx bash  # bash into the container
certbot --nginx -d domainexample.com -d www.domainexample.com  # setup ssl
```

## Docker-less solution (bad)

* `apt install nginx certbot python-certbot-nginx`
* `cp /etc/nginx/sites-available/default /etc/nginx/sites-available/domainexample`
* `vim /etc/nginx/sites-available/domainexample`

Add settings:

```bash
server {
    listen 80 ;
    listen [::]:80 ;

    root /var/www/domainexample;

    index index.html index.htm index.nginx-debian.html;

    server_name domainexample.com www.domainexample.com;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

* `ln -s /etc/nginx/sites-available/domainexample /etc/nginx/sites-enables/`
* `mkdir /var/www/domainexample`

Add your website inside `/var/www/domainexample`:

* `echo "<h1>DOMAINEXAMPLE Hello World!</h1>" >> /var/www/domainexample/index.html`
* `systemctl reload nginx`

## Install certbot

* `certbot --nginx`:
* Add email, do not share it
* Activate `https` for both `www.domainexample.com` and `domainexample.com`.
* Redirect automatically `https` to `http`.

## Auto-update certbot

* `certbot renew`
* Add `1 1 1 * * certbot renew` to crontab: `crontab -e`.
