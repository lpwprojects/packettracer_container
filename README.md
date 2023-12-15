# Container for Cisco Packet Tracer 8.2.1 with Podman

This is my personal repos to build Packet Tracer container on Fedora (running Xorg not Wayland).

- Packet Tracer is only supported on Ubuntu so I'm building a Ubuntu container with Podman. 
- Packet Tracer has a mandatory login process (skillsforall.com) so I added firefox.
- Also added a missing qt5 lib for version **8.2.1**.

Install the application with [Podman](https://docs.fedoraproject.org/en-US/neurofedora/containers/):

# Download Ubuntu package from [skillsforall.com](https://skillsforall.com/resources/lab-downloads):

```
# Will install current Packet_Tracer821_amd64_signed.deb from the container and accept EULA (End-User-License-Agreement) (needs working tty)
cp ./Packet_Tracer821_amd64_signed.deb /tmp/share/
```

# Build the image and start new container

Note: the container needs access to X11 socket for GUI apps to run. Sharing Display env + X11 socket and granting access to it with SELinux label.

```
podman build -t img_packettracer -f dockerfile .
podman run --name c_packettracer -dt -e DISPLAY -v /tmp/share:/SHARE:Z -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt label=type:container_runtime_t img_packettracer
```

# Install the app

```
podman exec -t -i c_packettracer /bin/bash
cp /SHARE/Packet_Tracer821_amd64_signed.deb .
apt install ./Packet_Tracer821_amd64_signed.deb
[...]
exit
```
# Run the app

```
# bashr: alias packettracer='podman start c_packettracer && podman exec c_packettracer packettracer ; podman stop c_packettracer'

podman start c_packettracer
podman exec c_packettracer packettracer
# podman stop c_packettracer
```

