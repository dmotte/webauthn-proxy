# Tested with docker.io/quiq/webauthn_proxy:0.1
FROM docker.io/quiq/webauthn_proxy:latest

COPY --chown=root:nobody --chmod=644 static/* /opt/static/

# Note: the owners and permissions are important here, because the startup.sh
# script running inside the container must be able to write to the
# /opt/config/credentials.yml file
USER root
RUN install -onobody -gnobody -m644 /dev/null /opt/config/credentials.yml && \
    install -d -onobody -gnobody /opt/config/cred-parts && \
    echo -e '---\ncookie_session_secrets: []' | \
        install -onobody -gnobody -m644 /dev/stdin \
            /opt/config/cred-parts/cooks.yml && \
    echo -e '---\nuser_credentials: {}' | \
        install -onobody -gnobody -m644 /dev/stdin \
            /opt/config/cred-parts/users.yml
USER nobody

COPY --chown=root:nobody --chmod=755 startup.sh /

ENTRYPOINT ["/startup.sh"]
