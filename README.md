# Essential Services for Harness

This project starts localhost services that are used by harness. This enables running Harness and the Harness CLI **installed natively** on the same machine as this project.

 - MongoDB on mongo://localhost:27017
 - Elasticsearch on http://localhost:9200

These can be in synced with the docker-compose and Kubernetes containers the projects listed, by updating these containers using `docker-compose pull` or other refresh method.
 
 - [harness-docker-compose](https://github.com/actionml/harness-docker-compose)
 - [k8s-harness](https://github.com/actionml/k8s-harness-private), which is a private repo.

**Note**: This project is not meant for production deployments and cannot be used as-is with the other container deployments, it is strictly meant as a debug aid to deploy service Harness uses in exactly the form used on the other container-based Harness projects. In particular these will help in running Harness in a debugger.

## Configure

Map container directories into the host filesystem for all of the composed containers.

 - `cd harness-docker-compose`
 - `cp .env.sample .env`
 - edit the `.env` file if the defaults are not adequate. 

## Deployment

With the docker daemon running:

 - `docker-compose up -d --build` for first time setup

Once deployed one or more containers in the collection can be updated. It is best to explore the docker-compose cli and options as well as docker commands. Some useful commands for updates are:
 
 - `docker-compose down` stops all container in the local yaml file. Do this before any other docker-compose updates.
 - `git pull origin <branch>` for this repo the lastest vesion under test is in branch `develop`, the last stable release is in `master`. The `git` repo contains the latest project structure and `docker-compose.yml`.
 - `docker-compose up -d --build --force-recreate` to bring up all updated containers by recreating all images.
 - `docker-compose pull` is a very important command that will get the latest image version from the ActionML automated CI/CD pipeline. **Note**: this project uses a possibly unstable develop/SNAPSHOT version of Harness. To change this, edit docker-compose.yml and change the versions to `harness:latest` and `harness-cli:latest`, which will get stable released versions.

