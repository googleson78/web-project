lines=$(docker ps | wc -l)
if [ $lines -gt 1 ]; then
  docker kill $(docker ps | tail -n1 | tr -s '[:space:]' | cut -d" " -f1)
  docker build -t myserver .
  docker run --rm -d -p 8888:80 -p 8080:22 myserver
else
  docker build -t myserver .
  docker run --rm -d -p 8888:80 -p 8080:22 myserver
fi
