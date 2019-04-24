Web Application Firewall (WAF) built on ModSecurity, CRS and NGINX
====  

[![Build Status](https://travis-ci.org/justin-p/Docker-CI-Test.svg?branch=master)](https://travis-ci.org/justin-p/Docker-CI-Test)

Heavily based of [docker-waf](https://github.com/theonemule/docker-waf) by @theonemule and the official NGINX container. Combines NGINX, ModSecurity and the CRS into 1 Dockerfile.  

### Usage

    docker-compose -f *docker-compose.TYPE.yml* build up