# quantum-ESPRESSO

## Docker image

### Pull
```sh
$ docker pull haya4kun/quantum_espresso
```

### Build
```sh
$ docker build -f Dockerfile .
```

### Run & attach
```sh
$ docker run -itd -v $(pwd):/root/qe-docker <IMAGE ID>
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

```sh
$ docker run --rm <IMAGE ID> python -V
Python 3.8.0
$ docker run -it --rm qe python
Python 3.8.0 (default, Apr 23 2020, 04:34:11) 
[GCC 7.5.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

Folowing packages are installed.
- `numpy`
- `scipy`
- `matplotlib`
- `sympy`
- `pandas`
- `tqdm`
- `Pillow`
- [`ase`](https://wiki.fysik.dtu.dk/ase/)
- `jupyter`
- `jupyterlab`
- `joblib`
- `Cython`

You can run jupyter nootebook or lab.
```sh
# jupyter notebook
$ docker run --rm -it -v $(pwd):/root/qe-docker -p 8889:8889 <IMAGE ID> jupyter notebook
# jupyter lab
$ docker run --rm -it -v $(pwd):/root/qe-docker -p 8889:8889 <IMAGE ID> jupyter lab
```

By entering `http://127.0.0.1:8889/?token=TOKEN`, which is also shown in terminal, into browser, you can use jupyter notebook/lab.

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
