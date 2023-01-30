configfile: "config/config.yaml"


rule produce_kage_benchmark_report:
  input:
    gpu_kmer_mapper="data/benchmarks/{sample}.gpu_kmer_mapper.txt",
    cpu_kmer_mapper="data/benchmarks/{sample}.cpu_kmer_mapper.txt",
    kage="data/benchmarks/{sample}.kage.txt"
  output:
    report="{sample}.benchmark_report.html"
  shell:
    """
    python create_benchmark_report.py \
        {input.gpu_kmer_mapper} {input.cpu_kmer_mapper} {input.kage}
    """


rule run_kage:
  input:
    counts="data/{sample}.cpu_kmer_counts.npy",
    kmer_index="data/input_files/index_2548all_uncompressed_minimal.npz",
    variants="data/input_files/numpy_variants.npz"
  output:
    vcf="data/{sample}.genotypes.vcf"
  benchmark:
    "data/benchmarks/{sample}.kage.txt"
  shell:
    """
    kage genotype \
        -c {input.counts} \
        -i {input.kmer_index} \
        -k {config[kmer_size]} \
        -a 15 \
        -t {config[n_threads_few]} \
        -b True \
        -o {output.vcf} \
        --variants {input.variants} \
        --do-not-write-genotype-likelihoods True
    """


rule run_gpu_kmer_mapper:
  input:
    kmer_index="data/input_files/kmer_index_only_variants_without_revcomp.npz",
    reads="data/input_files/{sample}.fa"
  output:
    counts="data/{sample}.gpu_kmer_counts.npy",
  benchmark:
    "data/benchmarks/{sample}.gpu_kmer_mapper.txt"
  shell:
    """kmer_mapper map \
        -i {input.kmer_index} \
        -f {input.reads} \
        -t {config[n_threads_few]} \
        -k {config[kmer_size]} \
        -c {config[gpu_chunk_size]} \
        -o {output.counts} \
        --gpu True \
        --map-reverse-complements True
    """


rule run_cpu_kmer_mapper:
  input:
    kmer_index="data/input_files/kmer_index_only_variants_with_revcomp.npz",
    reads="data/input_files/{sample}.fa"
  output:
    counts="data/{sample}.cpu_kmer_counts.npy",
  benchmark:
    "data/benchmarks/{sample}.cpu_kmer_mapper.txt"
  shell:
    """kmer_mapper map \
        -i {input.kmer_index} \
        -f {input.reads} \
        -t {config[n_threads_few]} \
        -k {config[kmer_size]} \
        -c {config[cpu_chunk_size]} \
        -o {output.counts}
    """


ruleorder: unzip_fastas > download

rule unzip_fastas:
  input:
    "{file}.fa.gz"
    #"{config[test_reads_zipped]}"
  output:
    "{file}.fa"
    #"{config[test_reads]}"
  shell:
    """
    gunzip -c {input} > {output}
    """


rule download:
  output:
    "data/input_files/{file}"
  shell:
    "rsync -aP {config[data_url]}/{wildcards.file}{config[data_url_postfix]} {output}"

