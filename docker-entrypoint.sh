#!/usr/bin/env bash

set -e

# Enable jemalloc for reduced memory usage and latency.
if [ -z "${LD_PRELOAD+x}" ]; then
  LD_PRELOAD=$(find /usr/lib -name libjemalloc.so.2 -print -quit)
  export LD_PRELOAD
fi

exec "${@}"
