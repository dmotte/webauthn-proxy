# syntax=docker/dockerfile:1

# Tested with docker.io/quiq/webauthn_proxy:0.6
FROM docker.io/quiq/webauthn_proxy:latest

USER root

RUN <<'EOF' /bin/sh -e
    apk add --no-cache tini bash coreutils

    install -dvm755 /opt/webauthn-proxy
EOF

RUN <<'EOF' /bin/bash -e
    # Note: the owners and permissions are important here, because the
    # entrypoint.sh script running inside the container must be able to
    # write to the /opt/config/credentials.yml file

    install -onobody -gnobody -Tvm644 /dev/null /opt/config/credentials.yml

    install -dv -onobody -gnobody /opt/config/cred-parts
    printf '%s\n' '---' 'cookie_session_secrets: []' |
        install -onobody -gnobody -Tvm644 /dev/stdin \
            /opt/config/cred-parts/cooks.yml
    printf '%s\n' '---' 'user_credentials: {}' |
        install -onobody -gnobody -Tvm644 /dev/stdin \
            /opt/config/cred-parts/users.yml
EOF

COPY --chown=root:nobody --chmod=644 static/* /opt/static/

COPY --chown=root:root --chmod=755 *.sh /opt/webauthn-proxy/

USER nobody

ENTRYPOINT ["/sbin/tini", "--", \
    "/bin/bash", "/opt/webauthn-proxy/entrypoint.sh"]
