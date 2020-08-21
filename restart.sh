proc=$(docker ps -q  --filter ancestor=myserver --format "{{.ID}}")
if [ ! -z "${proc}" ]; then
  echo "killing \"${proc}\""
  docker kill "${proc}"
fi

docker build -t myserver .
docker run --rm -d -p 8888:80 -p 8080:22 myserver
