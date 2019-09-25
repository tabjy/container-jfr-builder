# Containfer JFR Builder Image

Builder image for [openshift/source-to-image](https://github.com/openshift/source-to-image) to build [container-jfr](https://github.com/rh-jmc-team/container-jfr).

## Usage

1. Clone this repo:
    ```
    git clone git@github.com:tabjy/container-jfr-builder.git
    ```

2. Build the builder image:
    ```
    docker build -t tabjy/container-jfr-builder builder
    ```
    Yes, you have to do this step. This image is not published.

3. Call `s2i` to build application image:
    ```
    s2i build https://github.com/rh-jmc-team/container-jfr.git tabjy/container-jfr-builder rh-jmc-team/container-jfr
    ```
    This might take quite a while, as it's going to build JMC, container-jfr-core, and container-jfr-web, too.
4. Run your application container:
    ```
    docker run -it --rm -it tabjy/container-jfr
    ```
    Web interface available on [http://localhost:8181](http://localhost:8181).


## TODOs
- cache for maven, gradle, npm 
- use pipelined build to reduce final image size