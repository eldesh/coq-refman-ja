FROM ubuntu:18.04

ARG IMAGE_VERSION

ARG OMEGAT_VERSION
ARG OMEGAT_URL
ARG OCAML_VERSION
ARG OCAMLFIND_VERSION
ARG CAMLP5_VERSION

ARG OPAM_VERSION=2.0.2
ARG DEBIAN_FRONTEND=noninteractive

# inherits version numbers to runtime
ENV IMAGE_VERSION=${IMAGE_VERSION}
ENV OMEGAT_VERSION=${OMEGAT_VERSION}
ENV OMEGAT_URL=${OMEGAT_URL}
ENV OPAM_VERSION=${OPAM_VERSION}
ENV OCAML_VERSION=${OCAML_VERSION}
ENV OCAMLFIND_VERSION=${OCAMLFIND_VERSION}
ENV CAMLP5_VERSION=${CAMLP5_VERSION}

# OCI labels
LABEL org.opencontainers.image.authors="eldesh <nephits@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/eldesh/coq-refman-ja/context/Dockerfile"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.licenses="MIT License"
LABEL org.opencontainers.image.base.digest="256:5a214d77f5d747e6ed81632310baa6190301feeb875cf6bf9da560108fa09972"
LABEL org.opencontainers.image.base.name="ubuntu:18.04"

RUN apt-get update -y \
 && apt-get install --no-install-recommends -y sudo \
 # add a new user 'refman'
 && groupadd -g 1000 refman \
 && useradd --create-home --shell /bin/bash \
      --groups sudo --uid 1000 --gid 1000 refman \
 && echo refman:refman | chpasswd \
 && echo "refman ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/refman \
 && sudo apt-get autoremove \
 && sudo apt-get autoclean

# For detecting OmegaT with Make
ENV OMEGAT OmegaT_${OMEGAT_VERSION}_Linux_64/OmegaT.jar

USER refman
WORKDIR /home/refman

COPY ./requirements.txt /home/refman/

RUN sudo apt-get update -y \
 && sudo apt-get install --no-install-recommends -y m4 gettext make patch unzip curl ca-certificates bubblewrap ocaml mccs python3-pip python3-setuptools default-jre-headless \
 # setup opam
 && curl -SL https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/opam-full-${OPAM_VERSION}.tar.gz | tar -zxf - \
 && cd opam-full-${OPAM_VERSION} \
   && ./configure \
   && make lib-ext \
   && make \
   && sudo make install \
   && sudo make distclean \
   && echo '# OPAM configuration' >> ~refman/.profile \
   && echo 'test -r ~/.opam/opam-init/init.sh && . ~/.opam/opam-init/init.sh >/dev/null 2>&1 || true' >> ~refman/.profile \
   && cd .. \
 # install OCaml compiler
 && opam init --yes --solver=mccs --comp=${OCAML_VERSION} --disable-sandboxing \
 && eval $(opam env) \
 && sudo apt-get purge ocaml -y \
 # install OCaml package
 && opam pin add ocamlfind ${OCAMLFIND_VERSION} --yes \
 && opam pin add camlp5 ${CAMLP5_VERSION} --yes \
 # install Python package
 && pip3 install wheel \
 && pip3 install -r requirements.txt \
 # install OmegaT
 && curl -SL ${OMEGAT_URL} | tar -jxf - \
 && sudo apt-get autoremove -y \
 && sudo apt-get autoclean -y

CMD ["make"]

