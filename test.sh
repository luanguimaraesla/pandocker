docker run -e MIX_ENV=test --rm --entrypoint="/usr/bin/sh" $1 -c \
  "mix local.hex --force && mix deps.get && mix test"
