# Using shinyproxy-docker

This is a customization of shinyproxy for KTH. 

Differences versus the official image:

- Some extra certificates are built into the container image.
- The image size is 340 MB instead of 550 MB for the official image.

## Links

Documentation and release notes:

- https://shinyproxy.io/
- https://shinyproxy.io/downloads/#310

## Gotcha

See <https://stackoverflow.com/questions/77969011/unable-to-add-certs-to-cacerts-with-eclipse-temurin-jdk-image>

To avoid "unable to write file" during "make build".... this is how cacerts are installed using the script in `/__cacert_entrypoint.sh`:

```bash
#!/usr/bin/env sh
# Converted to POSIX shell to avoid the need for bash in the image

set -e

# Opt-in is only activated if the environment variable is set
if [ -n "$USE_SYSTEM_CA_CERTS" ]; then

    # Copy certificates from /certificates to the system truststore, but only if the directory exists and is not empty.
    # The reason why this is not part of the opt-in is because it leaves open the option to mount certificates at the
    # system location, for whatever reason.
    if [ -d /certificates ] && [ -n "$(ls -A /certificates 2>/dev/null)" ]; then
        cp -a /certificates/* /usr/local/share/ca-certificates/
    fi

    CACERT="$JAVA_HOME/lib/security/cacerts"

    # JDK8 puts its JRE in a subdirectory
    if [ -f "$JAVA_HOME/jre/lib/security/cacerts" ]; then
        CACERT="$JAVA_HOME/jre/lib/security/cacerts"
    fi

    # OpenJDK images used to create a hook for `update-ca-certificates`. Since we are using an entrypoint anyway, we
    # might as well just generate the truststore and skip the hooks.
    update-ca-certificates

    trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$CACERT"
fi

exec "$@"

```
