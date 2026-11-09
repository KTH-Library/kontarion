#!/bin/bash
set -e

# rocker-org/ml bakes ENV HOME=/home/jovyan for its default jovyan user.
# That's a static image attribute, so it doesn't follow a different runtime
# user set via `docker run --user` or a compose `user:` override - breaking
# any such override's access to its own cache/config dirs (and anything
# relying on HOME-relative paths like .Renviron). The old ml-verse base
# never baked a HOME at all, so $HOME always resolved dynamically from
# /etc/passwd for whichever UID actually ran the container; restore that
# behavior here instead of leaving it pinned to jovyan's home.
runtime_home=$(getent passwd "$(id -u)" | cut -d: -f6 || true)
if [ -n "$runtime_home" ]; then
    export HOME="$runtime_home"
fi

exec /usr/bin/tini -- "$@"
