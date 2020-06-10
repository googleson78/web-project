## Running

0. [Build the service](#Building)
1. `docker build -t <some-name> .`
2. `docker run --rm -d -p <some-port>:80 <some-name>`

You should now have an nginx server running at `<some-port>`.

The haskell service should be running at `localhost:<some-port>/api/*`, and you can also see a php info file at `localhost:<some-port>/info.php`.

You can also run the image environemnt interactively with `docker run --rm --entrypoint /bin/bash -it <some-name>`.
However, this will not start the `nginx`/`php-fpm`/`mysql`/etc services automatically, because they are usually started
as the `ENTRYPOINT` for the docker image.


## Building

0. Have `docker`
1. `./stack.sh install --local-bin-path=.`
2. _wait a long time the first time around_

You should now have an executable called `service-exe` inside the `service` folder.

Note that you can also build (and e.g. also use `ghci`) without using `stack.sh` (which runs a build inside a docker image).
You'll need `libpcre3-dev` + `libmariadbclient-dev` (this is what they're called on debian).

This build is in place so that you can easily run a "dev" server afterwards, refer to [Running](#Running).
Building it on your machine might cause a `libc` mismatch between what is in the "deploy" image.
