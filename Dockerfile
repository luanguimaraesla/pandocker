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

WORKDIR /pandocker
ADD . /pandocker 

RUN apt-get install -y elixir && \
    mix local.hex --force && \
    mix deps.get

CMD mix run 
