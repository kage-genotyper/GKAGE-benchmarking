## GKAGE benchmarking pipeline using Snakemake

## How to run
In order to reproduce the benchmarking of GKAGE:
1) Install Snakemake by following the instructions [here](https://snakemake.readthedocs.io/en/stable/)
2) Install CuCounter by following the instructions [here](https://github.com/jorgenwh/cucounter)
3) Install KAGE from [this](https://github.com/ivargr/kage.git) GitHub repository
4) Run the Snakemake pipeline:
```bash
snakemake --cores 1 hg002_simulated_reads_15x.benchmark_report.txt
```

After Snakemake completes, the benchmark results will be in hg002\_simulated\_reads\_15x.benchmark\_report.txt
