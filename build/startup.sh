#!/bin/sh

set -e

readonly \
    cred_cooks=/opt/config/cred-parts/cooks.yml \
    cred_users=/opt/config/cred-parts/users.yml \
    cred_merged=/opt/config/credentials.yml

readonly sleep_secs="${WPWRAPPER_SLEEP:-10}" # seconds

trap 'kill $(jobs -p)' EXIT

while :; do
    lastmod_users=$(date -r "$cred_users" +%s.%N)

    cat "$cred_cooks" "$cred_users" | grep -v '^---$' > "$cred_merged"

    /opt/webauthn_proxy &

    while [ "$(date -r "$cred_users" +%s.%N)" = "$lastmod_users" ]
        do sleep "$sleep_secs"; done

    kill %%
    wait # until the webauthn_proxy job actually finishes
done
