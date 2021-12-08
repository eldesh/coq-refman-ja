# Coq リファレンスマニュアル 非公式日本語訳

## Requirements

- OCaml
- OmegaT
- Java
- Sphinx
- gettext


## Clone this repository

```sh
$ git clone git@github.com:eldesh/coq-refman-ja
$ cd coq-refman-ja
$ git submodule init
$ git submodule update
```


## Build on docker

### Build a builder image

```sh
$ docker-compose build
```


### Build on the builder image

```sh
$ docker-compose run --rm builder make html
```


## Build on local env

### Prepare prerequiresites

```sh
$ sudo apt-get install opam
$ pip3 install -r requirements.txt
$ curl https://jaist.dl.sourceforge.net/project/omegat/OmegaT%20-%20Standard/OmegaT%204.3.1/OmegaT_4.3.1_Linux_64.tar.bz2 | tar -jxf -
```


### Generate documents

```sh
$ make html [OMEGAT=/path/to/omegat.jar]
```


