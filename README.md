# Taskcluster VPN Proxy

The taskcluster vpn proxy is meant to be used as a feature within
[docker-worker](https://github.com/taskcluster/docker-worker). 

There are two pieces to this proxy.  One is a nginx proxy that will forward traffic
from port 80 to a distination specified in the PROXIED_SERVER environment variable.

This environment variable is specified when [starting the docker container](#Running_Proxy).

The VPN proxy will establish a connection with the remote specified
in the [vpn configuration](#Configuration).


## Configuration

The proxy container will load the vpn configuration from /vpn within the container.
The vpn configuration can be copied to this path by [building the docker container](#Building)
using the `build.sh` script.

The vpn configuration is a standard openvpn configuration with keys, certificates,
and a configuration file.  The credentials should be entered into a file and this
will be used while authneticating with the vpn endpoint.


##Building

The docker container can be built using the provided build script.  Clone this repo, adjust
the VERSION and REGSITRY files to match your needed, and run:

```
./build.sh <path to vpn config>
```

The above script will copy the vpn configuration to a /data directory in the
current directory so that it's available for Docker to bundle into the image.
Once build, the data directory will be removed.

##Running Proxy

To run the proxy, the following command could be used:

```
docker run --cap-add=NET_ADMIN --name=<container name> -p <host port>:80 -e PROXIED_SERVER=<url for proxied server> <image>
```

The CAP_NET_ADMIN linux capability is necessary for docker to create a tun device
and change network/routing information.

Once running, you can request http://<container name> and it will be proxied through
the container and vpn connection.

