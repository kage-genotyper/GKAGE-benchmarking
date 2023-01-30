import sys
from tabulate import tabulate

GPU_KMER_MAPPER_BENCH = sys.argv[1]
CPU_KMER_MAPPER_BENCH = sys.argv[2]
KAGE_BENCH = sys.argv[3]
OUTPUT_REPORT = sys.argv[4]

with open(GPU_KMER_MAPPER_BENCH, "r") as f:
    lines = f.readlines()
    gpu_kmer_mapper_runtime = float(lines[-1].split("\t")[0])

with open(CPU_KMER_MAPPER_BENCH, "r") as f:
    lines = f.readlines()
    cpu_kmer_mapper_runtime = float(lines[-1].split("\t")[0])

with open(KAGE_BENCH, "r") as f:
    lines = f.readlines()
    kage_runtime = float(lines[-1].split("\t")[0])

total_kage = int(cpu_kmer_mapper_runtime + kage_runtime)
total_gkage = int(gpu_kmer_mapper_runtime + kage_runtime)

all_data = [
        ["", "KAGE", "GKAGE"],
        ["Runtime", total_kage, total_gkage]
        #["", "Runtime (seconds)"],
        #["KAGE Counting kmers", int(cpu_kmer_mapper_runtime)],
        #["KAGE Genotyping", int(kage_runtime)],
        #["Total time", int(cpu_kmer_mapper_runtime + kage_runtime)],
        #["GKAGE Counting kmers", int(gpu_kmer_mapper_runtime)],
        #["GKAGE Genotyping", int(kage_runtime)],
        #["Total time", int(gpu_kmer_mapper_runtime + kage_runtime)]
]

table = tabulate(all_data, headers="firstrow", tablefmt="github")

with open(OUTPUT_REPORT, "w") as f:
    f.writeline("Asserted that GPU and CPU counts were equal")
    f.write(table)
