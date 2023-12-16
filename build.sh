#! /bin/bash

PTDEB=Packet_Tracer821_amd64_signed.deb
DOCKERFILE=dockerfile
IMG=img_packettracer
CONT=c_packettracer

[ -f ./"$PTDEB" ] || exit 1
[ -f ./"$DOCKERFILE" ] || exit 1
if [ -d ./pt ] ; then
	echo "Please remove './pt' dir"
	exit 1
fi

mkdir pt || exit 1
cp "$PTDEB" ./pt/ || exit 1
cp "$DOCKERFILE" ./pt/ || exit 1
cd ./pt || exit 1

podman build -t $IMG -f "$DOCKERFILE" . || exit 1
podman run --name $CONT -dt -e DISPLAY -v .:/SHARE:Z $IMG || exit 1

podman exec -t -i $CONT /bin/bash -c "apt install /SHARE/$PTDEB"

echo -e "\n\n"
read -p "Accepted EULA successfully? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
	podman stop $CONT	
	podman commit $CONT localhost/$IMG:latest || exit 1
	podman rm $CONT
fi

echo -e "\n\n"
echo "====================================="
echo "==> Run new container with Packet Trancer and shared volume '/home/share' from host as '/SHARE' inside container:"
echo "podman run --name $CONT -dt -e DISPLAY -v /home/share:/SHARE:Z -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt label=type:container_runtime_t $IMG"
echo 
echo "==> Exec Packet Tracer from running container:"
echo "podman exec $CONT packettracer"
echo "====================================="
echo "DONE."
