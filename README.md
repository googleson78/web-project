## Building

0. Have `docker`
1. `./stack.sh instal --local-bin-path=.`
2. _wait a long time the first time around_

You should now have an executable called `service` inside the `assessment` folder.

Note that you can also build (and e.g. also use `ghci`) without using `stack.sh` (which runs a build inside a docker image).
You'll need `libpcre3-dev` + `libmariadbclient-dev` (this is what they're called on debian).

This build is in place so that
* there are no libc mismatches between `deploy` and what you're building
* you can easily run a "dev" server afterwards, using `deploy`

## Running

0. Build the service
1. Copy `service/service-exe` file to `deploy/assessment-service` (TODO: automate this?)
2. `docker build -t <some-name> deploy`
3. `docker run -d -p <some-port>:3000 <some-name>`

You should now have the service running at `<some-port>`.
