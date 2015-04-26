# mimir-docker

Build the data container:

docker build -t cassj/mimir-data --file=Dockerfile.dataContainer  .

Build the mimir server container

docker build -t cassj/mimir .

Start the data container (this will then exit, but that's fine, because the volume will persist)

MIMIRDATA=$(docker run -d cassj/mimir-data)

Start the mimir container

MIMIR=$(docker run -d --volumes-from $MIMIRDATA -p 8080:8080 cassj/mimir)

Make sure you configure mimir to put its indices in /home/mimir/data

You should now be able to access your mimir instance at <dockerhost>:8080

If you want to look at your index data, you can just run another container mounting the same volume:

docker run --rm -it --volumes-from $MIMIRDATA ubuntu /bin/bash
ls /home/mimir/data


