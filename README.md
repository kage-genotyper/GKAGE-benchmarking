## GKAGE benchmarking pipeline using Snakemake

## How to run
In order to reproduce the benchmarking of GKAGE:
1) Install Snakemake by following the instructions [here](https://snakemake.readthedocs.io/en/stable/)
2) Install CuCounter by following the instructions [here](https://github.com/jorgenwh/cucounter)
3) Install KAGE from [this](https://github.com/ivargr/kage.git) GitHub repository
4) Make sure the Gerbil submodule repository is downloaded to your system and perform the following steps to build Gerbil from the root directory of the Gerbil repository:
```bash
mkdir build
cd build
cmake ..
make
mkdir gerbil_temp_files
```
4) Run the Snakemake pipeline from the GKAGE-benchmarking root directory:
```bash
snakemake --cores 1 hg002_simulated_reads_15x.benchmark_report.txt
```

After Snakemake completes, the benchmark results will be in hg002\_simulated\_reads\_15x.benchmark\_report.txt
