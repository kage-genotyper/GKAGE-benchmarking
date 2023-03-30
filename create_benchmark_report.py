import sys
from tabulate import tabulate

GPU_KMER_MAPPER_BENCH = sys.argv[1]
CPU_KMER_MAPPER_BENCH = sys.argv[2]
GERBIL_BENCH = sys.argv[3]
KAGE_BENCH = sys.argv[4]
OUTPUT_REPORT = sys.argv[5]

for x in sys.argv:
    print(x)

with open(GPU_KMER_MAPPER_BENCH, "r") as f:
    print("GPU KMER MAPPER BENCHMARK")
    lines = f.readlines()
    print(lines)
    gpu_kmer_mapper_runtime = float(lines[-1].split("\t")[0])
    print(gpu_kmer_mapper_runtime)

with open(CPU_KMER_MAPPER_BENCH, "r") as f:
    print("CPU KMER MAPPER BENCHMARK")
    lines = f.readlines()
    print(lines)
    cpu_kmer_mapper_runtime = float(lines[-1].split("\t")[0])
    print(cpu_kmer_mapper_runtime)

with open(GERBIL_BENCH, "r") as f:
    print("GERBIL BENCHMARK")
    lines = f.readlines()
    print(lines)
    gerbil_runtime = float(lines[-1].split("\t")[0])
    print(gerbil_runtime)

with open(KAGE_BENCH, "r") as f:
    print("KAGE BENCHMARK")
    lines = f.readlines()
    print(lines)
    kage_runtime = float(lines[-1].split("\t")[0])
    print(kage_runtime)

total_kage = int(cpu_kmer_mapper_runtime + kage_runtime)
total_gkage = int(gpu_kmer_mapper_runtime + kage_runtime)
print("TOTAL KAGE & GKAGE")
print(total_kage)
print(total_gkage)

all_data = [
        ["", "KAGE", "GKAGE", "GERBIL (only kc)"],
        ["Runtime", total_kage, total_gkage, int(gerbil_runtime)]
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
    f.write("Asserted that GPU and CPU counts were equal\n")
    f.write(table)
