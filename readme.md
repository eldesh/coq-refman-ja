# Coq リファレンスマニュアル 非公式日本語訳


## Initialize

```sh
$ git clone git@github.com:eldesh/coq-refman-ja
$ cd coq-refman-ja
$ git submodule init
$ git submodule update
```

## Build

### Prepare prerequiresites

```sh
$ pip3 install -r requirements.txt
```


### Generate documents

```sh
$ make html [OMEGAT=/path/to/omegat.jar]
```

## Requirements

- OCaml
- OmegaT
- Java
- Sphinx
- gettext

