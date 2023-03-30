configfile: "config/config.yaml"


rule make_report:
  input:
    gpu_kmer_mapper="data/benchmarks/{sample}.gpu_kmer_mapper.txt",
    cpu_kmer_mapper="data/benchmarks/{sample}.cpu_kmer_mapper.txt",
    gerbil="data/benchmarks/{sample}.gerbil.txt",
    kage="data/benchmarks/{sample}.kage.txt",
    asserted_counts_equal="data/{sample}.asserted_counts_equal.txt"
  output:
    report="{sample}.benchmark_report.txt"
  shell:
    """
    python create_benchmark_report.py \
        {input.gpu_kmer_mapper} {input.cpu_kmer_mapper} {input.gerbil} {input.kage} {output}
    """


rule run_kage:
  input:
    counts="data/{sample}.gpu_kmer_counts.npy",
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
        -t {config[n_threads]} \
        -b True \
        -o {output.vcf} \
        --variants {input.variants} \
        --do-not-write-genotype-likelihoods True
    """


rule assert_counts_equal:
  input:
    gpu_counts="data/{sample}.gpu_kmer_counts.npy",
    cpu_counts="data/{sample}.cpu_kmer_counts.npy"
  output:
    "data/{sample}.asserted_counts_equal.txt"
  run:
    import numpy as np
    gpu_counts = np.load(input.gpu_counts)
    cpu_counts = np.load(input.cpu_counts)
    assert np.all(gpu_counts == cpu_counts)
    with open(output[0], "w") as f:
        f.write("")


rule run_gerbil:
  input:
    reads="data/input_files/{sample}.fa"
  output:
    counts="data/{sample}.gerbil_kmer_counts.bin",
  benchmark:
    "data/benchmarks/{sample}.gerbil.txt"
  shell:
    """
    ./gerbil/build/gerbil \
        -k {config[kmer_size]} \
        -t {config[n_threads]} \
        -l {config[gerbil_min_frequency]} \
        -g \
        -o gerbil \
        {input.reads} \
        gerbil/build/gerbil_temp_files/ \
        {output.counts}
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
        -t {config[n_threads]} \
        -k {config[kmer_size]} \
        -c {config[gpu_chunk_size]} \
        -o {output.counts} \
        --gpu True \
        --gpu-hash-map-size {config[gpu_hash_map_size]} \
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
        -t {config[n_threads]} \
        -k {config[kmer_size]} \
        -c {config[cpu_chunk_size]} \
        -o {output.counts} \
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
    "wget -O {output} {config[data_url]}/{wildcards.file}{config[data_url_postfix]}"

