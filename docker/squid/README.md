# Squid
* Author:   Pedric Kng  
* Updated:  26 May 2020

Guide on installing squid as a proxy server using proxy

***

## Running squid proxy via docker

1. Run squid container

The proxy port can be changed using the exposed container port.
```docker
 docker run --name $CONTAINER_NAME -d --restart=always \
        --publish 3128:3128 \
        --volume /srv/docker/squid/cache:/var/spool/squid \
        sameersbn/squid:3.5.27-2
```

2. Allow access all

By default, the squid server denys all traffic, this can altered via adding 'http_access allow all' in the configuration file
```docker
docker exec -it -u root $CONTAINER_NAME  nano /etc/squid/squid.conf
```

3. Tailing proxy logs

After configuring the relevant proxy settings, tail the proxy for the relevant traffic

```docker
docker exec -it -u root $CONTAINER_NAME  tail -f /var/log/squid/access.log
```


## Squid proxy on ubuntu

- Installation
```bash
# Update the software repositories
> sudo apt-get update

# Install squid package
> sudo apt-get install squid

# Configuring Squid Proxy Server
> sudo nano /etc/squid/squid.conf

  ## Configure options as below
  # default port is 3128
  http_port <ipaddress>:<port>
  # Allow all http traffic
  http_access allow all

# restart squid service
> sudo systemctl restart squid

# Test via firefox proxy 

```

- Configure proxy authentication
```bash
# Install apache2-utils
> sudo apt-get install apache2-utils

# Create passwd file, and change ownership to the squid user proxy
> sudo touch /etc/squid/passwd
> sudo chown proxy: etc/squid/passwd

# Add a new user and password
> sudo htpasswd /etc/squid/passwd <username>

# Configuring Squid Proxy Server
> sudo nano /etc/squid/squid.conf

  ## add following command lines below
  auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
  auth_param basic children 5
  auth_param basic realm Squid Basic Authentication
  auth_param basic credentialsttl 2 hours
  acl auth_users proxy_auth REQUIRED
  http_access allow auth_users

# restart squid service
> sudo systemctl restart squid

# Test via firefox proxy 

```

## References
Squid as a reverse proxy [[1]]  
Squid docker container [[2]]  
How do i allow access to all requests through squid proxy server [[3]]  

[1]:http://derpturkey.com/squid-as-a-reverse-proxy/ "Squid as a reverse proxy"
[2]:https://hub.docker.com/r/sameersbn/squid/ "Squid docker container"
[3]:https://stackoverflow.com/questions/42901716/how-do-i-allow-access-to-all-requests-through-squid-proxy-server "How do i allow access to all requests through squid proxy server"  
[4]:https://phoenixnap.com/kb/setup-install-squid-proxy-server-ubuntu "Setup install squid proxy on Ubuntu"