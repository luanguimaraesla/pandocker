FROM debian:buster-slim

ENV PANDOCKER_PATH /code

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    cabal install pandoc-crossref && \
    cabal install pandoc-citeproc

COPY compile.sh /compile.sh

WORKDIR /code
CMD /compile.sh
