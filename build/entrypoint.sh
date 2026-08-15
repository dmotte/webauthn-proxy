#!/bin/bash

set -e

readonly \
    cred_cooks=/opt/config/cred-parts/cooks.yml \
    cred_users=/opt/config/cred-parts/users.yml \
    cred_merged=/opt/config/credentials.yml

# Some examples: ".5", "0.5", "0.5s", "30", "30s", "5m", "1h"
readonly sleep_interval=${WPWRAPPER_SLEEP:-10s}

# We don't use "xargs" here because we want to use Bash's builtin "kill"
trap 'builtin kill $(jobs -p) 2>/dev/null || :; wait' EXIT

while :; do
    lastmod_users=$(date -r "$cred_users" +%s.%N)

    cat "$cred_cooks" "$cred_users" | grep -Fxv -- '---' > "$cred_merged"

    /opt/webauthn_proxy &

    while [ "$(date -r "$cred_users" +%s.%N)" = "$lastmod_users" ]
        do sleep "$sleep_interval"; done

    kill %%
    wait # until the webauthn_proxy job actually finishes
done
