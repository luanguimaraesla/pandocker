FROM debian:buster-slim

ENV PANDOCKER_PATH /code

RUN apt-get update && \
    apt-get install -y \
    curl \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-font-utils \
    texlive-publishers \
    texlive-lang-portuguese && \
    apt-get clean -y

RUN apt-get install -y --no-install-recommends haskell-platform unzip && \
    cabal update && \
    cabal install pandoc-types-1.17.3 && \
    cabal install pandoc && \
    cabal install pandoc-crossref && \
    cabal install pandoc-citeproc && \
    apt-get clean -y

# Install elixir on Debian buster
RUN apt-get install -y gnupg2 && \
    echo "deb http://packages.erlang-solutions.com/debian jessie contrib" \
    >> /etc/apt/sources.list.d/erlang-solutions.list && \
    curl -L http://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
    apt-get update && apt-get install -y elixir && apt-get clean -y

ENV LANG=C.UTF-8 \
    MIX_ENV=prod
ADD mix.exs /tmp/mix.exs
RUN cd /tmp && \
    mix local.hex --force && \
    mix deps.get

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /pandocker
ADD . /pandocker 

RUN mv /tmp/_build /tmp/deps /tmp/mix.lock /pandocker/ && \
    mix local.rebar --force && \
    mix compile
