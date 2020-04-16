# quantum-ESPRESSO

## Docker
```sh
# build
$ docker image build -f Dockerfile .
# run
$ docker run -itd <IMAGE ID> -v (pwd):/root/qe-docker
# attach
$ docker attach <CONTAINER ID>
```

## Example
### Graphene band

http://www.cmpt.phys.tohoku.ac.jp/~koretsune/SATL_qe_tutorial/graphene_banddos.html

```sh
$ cd graphene
$ pw.x < graphene.scf.in > graphene.scf.out
$ pw.x < graphene.nscf.in > graphene.nscf.out
$ bands.x < graphene.band.in > graphene.band.out
```

See `plot.ipynb`
