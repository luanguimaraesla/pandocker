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

WORKDIR /pandocker
ADD . /pandocker 

RUN mix local.hex --force && \
    mix deps.get

CMD mix run -e Pandocker.run
