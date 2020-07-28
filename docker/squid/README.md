# Squid
* Author:   Pedric Kng  
* Updated:  26 May 2020

Guide on installing squid as a proxy server using proxy

***

## Guide

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

## References
Squid as a reverse proxy [[1]]  
Squid docker container [[2]]  
How do i allow access to all requests through squid proxy server [[3]]  

[1]:http://derpturkey.com/squid-as-a-reverse-proxy/ "Squid as a reverse proxy"
[2]:https://hub.docker.com/r/sameersbn/squid/ "Squid docker container"
[3]:https://stackoverflow.com/questions/42901716/how-do-i-allow-access-to-all-requests-through-squid-proxy-server "How do i allow access to all requests through squid proxy server"  