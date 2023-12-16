# Container for Cisco Packet Tracer 8.2.1 with Podman

This is my personal repos to build Packet Tracer container on Fedora (running **Xorg** not Wayland).

- Packet Tracer is only supported on Ubuntu so I'm building a Ubuntu container with Podman. 
- Packet Tracer has a mandatory login process (skillsforall.com) so I added firefox.
- Also added a missing qt5 lib for version **8.2.1**.

Install the application with [Podman](https://docs.fedoraproject.org/en-US/neurofedora/containers/):

Note you need to **accept EULA (End-User-License-Agreement)** from Cisco to install the software on your system. A **dialog will show up** during the installation.

# build.sh script

The script will run a container then create a local image with Packet Tracer installed. 

You can then use that image to run a container with the application already installed: tags are editable on top of the script (variables).

# Download Ubuntu package from Cisco

Signup or login to [skillsforall.com](https://skillsforall.com/resources/lab-downloads) to download the Ubuntu version.

You should get a .deb file (e.g Packet_Tracer821_amd64_signed.deb).

# build the image

```
mkdir tmp && cd tmp
git clone https://github.com/lpwprojects/packettracer_container.git . 
cp ~/Downloads/Packet_Tracer821_amd64_signed.deb .
chmod +x ./build.sh
./build.sh
```

# Create new container from local image with the application

```
# Example with shared volume '/home/share' from host as '/SHARE' inside container (e.g import labs you download into Packet Tracer)
podman run --name <CONTAINER NAME> -dt -e DISPLAY -v /home/share:/SHARE:Z -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt label=type:container_runtime_t <LOCAL IMAGE NAME>
```

# Run the application

```
podman exec <CONTAINER NAME> packettracer

# ==> bashr: alias packettracer='podman start <CONTAINER NAME> && podman exec <CONTAINER NAME> packettracer ; podman stop <CONTAINER NAME>'
```

