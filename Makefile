.PHONY: snakemake clean run_kage run_gpu_kmer_mapper run_cpu_kmer_mapper produce_kage_benchmark_report

snakemake:
	snakemake --cores 1

produce_kage_benchmark_report:
	snakemake --cores 1 -R produce_kage_benchmark_report

run_kage:
	snakemake --cores 1 -R run_kage

run_gpu_kmer_mapper:
	snakemake --cores 1 -R run_gpu_kmer_mapper

run_cpu_kmer_mapper:
	snakemake --cores 1 -R run_cpu_kmer_mapper

clean:
	$(RM) -rf \
		files/produced/gpu_kmer_counts.npy \
		files/produced/cpu_kmer_counts.npy \
		files/produced/genotypes.vcf \
		files/benchmarks/gpu_kmer_mapper.txt \
		files/benchmarks/cpu_kmer_mapper.txt \
		files/benchmarks/kage.txt \
		benchmark_report.html

