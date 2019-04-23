$ErrorActionPreference = 'Stop';
cinst docker-compose -y
docker-compose -f docker-compose.development.yml build 
test: off
