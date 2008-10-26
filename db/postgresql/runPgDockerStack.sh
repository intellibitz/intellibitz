#!/usr/bin/env sh
#https://github.com/docker-library/docs/blob/master/postgres/README.md

docker stack deploy -c stack.yml postgres 
# (or) 
docker-compose -f stack.yml up

# , wait for it to initialize completely, and visit 
http://swarm-ip:8080, 
http://localhost:8080, or 
http://host-ip:8080 (as appropriate).
