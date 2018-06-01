FROM debian:buster-slim

ENV PANDOCKER_PATH=/code \
    LANG=C.UTF-8 \
    MIX_ENV=prod

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    texlive-full \
    && apt-get clean -y

RUN apt-get install -y --no-install-recommends haskell-platform unzip \
    && cabal update

RUN apt-get install -y tar xz-utils libnuma-dev make \
    && curl -L https://downloads.haskell.org/~ghc/8.4.2/ghc-8.4.2-x86_64-deb9-linux.tar.xz \
    --output ghc-8.4.2-x86_64-deb9-linux.tar.xz \
    && tar -xf ghc-8.4.2-x86_64-deb9-linux.tar.xz \
    && cd ghc-8.4.2 \
    && ./configure \
    && make install

# Update cabal version and
RUN export PATH=$PATH:/root/.cabal/bin \
    && cabal install cabal-install --global \
    && hash -r \
    && cabal update \
    && cabal install pandoc \
    && cabal install pandoc-crossref \
    && cabal install pandoc-citeproc

# Install elixir on Debian buster
RUN apt-get install -y gnupg2 && \
    echo "deb http://packages.erlang-solutions.com/debian stretch contrib" \
    >> /etc/apt/sources.list.d/erlang-solutions.list \
    && curl -L http://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - \
    && apt-get update \
    && mkdir -p /usr/share/man/man1/ \
    && apt-get install -y git elixir erlang-inets erlang --no-install-recommends \
    && apt-get clean -y

ADD mix.exs /tmp/mix.exs
RUN cd /tmp && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /pandocker
ADD . /pandocker 

RUN mv /tmp/* /pandocker/ && \
    mix compile
