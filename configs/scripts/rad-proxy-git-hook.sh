#!/usr/bin/env bash

export RAD_HOME="${HOME}/.radicle"
export PATH="${PATH}:/usr/local/bin"

while read oldrev newrev refname; do
    branch=$(echo "$refname" | sed -E 's#^refs/heads/##')

    echo "==> [Radicle Hook] SSH push ontvangen voor branch: $branch"
    echo "==> [Radicle Hook] Synchroniseren met Radicle netwerk..."

    if git push rad "$branch"; then
        echo "==> [Radicle Hook] Succesfully proxied to Radicle!"
    else
        echo "==> [Radicle Hook] ERROR: Could not push to Radicle." >&2
        exit 1
    fi
done
