# quantum-ESPRESSO

## Docker image

### Pull
```sh
$ docker pull haya4kun/quantum_espresso
```

### Build
```sh
$ docker image build -f Dockerfile .
```

### Run & attach
```sh
$ docker run -itd <IMAGE ID> -v (pwd):/root/qe-docker
$ docker attach <CONTAINER ID>
```

## Pseudo-potential
- [pslibrary](https://dalcorso.github.io/pslibrary/)
- [sg15_oncv_upf](http://www.quantum-simulation.org/potentials/sg15_oncv/)

For `pslibrary`, pseudo potentials of `C N O Al Si P S Ti Cr Fe Co Ni Cu Zn Ga Ge As Se Ag In Sn Au` are made.
If you need another element's pseudo-potential, please add the element to `element` in `res/meka_ps` file.
All pseudo-potential will be made when `element=all` is specified.


## Python
Python 3.8.0 is installed.

Folowing packages
- `numpy`
- `scipy`
- `matplotlib`
- `sympy`
- `pandas`
- `tqdm`
- `Pillow`
- (`ase`)[https://wiki.fysik.dtu.dk/ase/]
- `jupyter`
are installed.

```sh
$ docker run --rm <IMAGE ID> python -V
Python 3.8.0
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
