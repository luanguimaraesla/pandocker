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

# Install and setup Haskell Stack
RUN curl -sSL https://get.haskellstack.org/ | sh -s - -f && \
    stack setup

# Install pandoc
RUN stack install pandoc-2.0.6 && \
    stack install pandoc-citeproc && \
    stack install pandoc-crossref

COPY compile.sh /compile.sh

WORKDIR /code
CMD /compile.sh
