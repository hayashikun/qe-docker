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

## Pseudo-potential
- [pslibrary](!https://dalcorso.github.io/pslibrary/)
- [sg15_oncv_upf](!http://www.quantum-simulation.org/potentials/sg15_oncv/)

For `pslibrary`, pseudo potentials of `C N O Al Si P S Ti Cr Fe Co Ni Ci Zn Ga Ge As Se Ag In Sn Au` are made.
If you need another element's pseudo-potential, please add the element to `element` in `res/meka_ps` file.
All pseudo-potential will be made when `element=all` is specified.


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
