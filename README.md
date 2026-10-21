# Shopware Images

Images to run Shopware 6 in containers

## Status
* [![Publish Images to Registry](https://github.com/TotalcomNetwork/shopware-images/actions/workflows/build-and-push.yaml/badge.svg)](https://github.com/TotalcomNetwork/shopware-images/actions/workflows/build-and-push.yaml)

## Quick reference

### Build the image

```
docker buildx build --tag artifacts.totalcom.it/library/shopware:[tagname-dir_name] -o type=image --platform=linux/amd64 ./[tagname-dir_name]
```

E.g.:

```
docker buildx build --tag artifacts.totalcom.it/library/shopware:php-8.5-fpm -o type=image --platform=linux/amd64 ./php-8.5-fpm
```

### Push image to registry

```
docker push artifacts.totalcom.it/library/shopware:tagname
```

E.g.:

```
docker push artifacts.totalcom.it/library/shopware:php-8.5-fpm
```

###  Build and push everything

Execute the `./build-and-push.sh` script to build and push all images to Docker Hub at once.


## How to use

> **This is a base image. It does not contain Shopware code.** Use it either as a base to build a production image that includes your application code, or for development, bind-mounting your application code into `/var/www/html`.

Available tags: `php-8.2`, `php-8.3`, `php-8.4`, `php-8.5`, each in `-fpm` and `-cli` variants.

### Development: bind-mount the application code

```yaml
services:
    shopware:
        image: artifacts.totalcom.it/library/shopware:php-8.4-fpm
        volumes:
            - ./:/var/www/html
```

### Production: build an image that contains the application code

```dockerfile
FROM artifacts.totalcom.it/library/shopware:php-8.4-fpm

COPY --chown=www-data:www-data . /var/www/html

RUN composer install --no-dev --optimize-autoloader --no-interaction
```

### Configuration

This image is created starting from the official PHP Docker image. Look at the "How to use this image" section of the [official image readme](https://hub.docker.com/_/php) to learn how to configure and use this image.

The image uses a production-optimized php.ini file. To customize the PHP settings to your needs it is sufficient to bind-mount a custom ini file in the container's `/usr/local/etc/php/conf.d/` directory.

E.g.:

```yaml
shopware:
    # ... other settings here ...
    volumes:
        # ... other volumes and mounts here ...
        - ./my/custom/999-php.ini:/usr/local/etc/php/conf.d/999-php.ini:ro
```

### Debugging

The `XDebug` extension is available in the image, but is disabled by default. To enable it, use a custom `ini` file, like explained above.
