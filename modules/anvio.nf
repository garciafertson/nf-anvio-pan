#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// This file has the Anvi'o processing steps used during the workflow

// Process for generating contigs database and annotations from individual genomes
process GENOMEDB {

    publishDir "${params.outdir}/genome_db", mode: 'copy'
	container "docker://sysbiojfgg-anvio_cogpfam:v0.1"
	cpus = { 2 * task.attempt }
	memory = '12.GB'
	time = { 5.h * task.attempt }
	errorStrategy {  task.exitStatus in [143,137,104,134,139,255] ? 'retry' : 'finish' }
	maxRetries = 2
	maxForks 40
    
    input:
    tuple val(genome_name), path(fasta)
	path(cog20)
	path(kegg)
    path(scg_taxonomy)

    output:
    tuple val(genome_name), path("${genome_name}.db"), emit: genome_db
    
	script:
    """
    anvi-script-reformat-fasta ${fasta} \\
        --min-len ${params.min_length} \\
        --simplify-names \\
        -o ${genome_name}_scaffolds_1K.fasta

	anvi-gen-contigs-database -f ${genome_name}_scaffolds_1K.fasta \
                          -o ${genome_name}.db \
                          --num-threads ${task.cpus} \
                          -n ${genome_name}

	anvi-run-hmms -c ${genome_name}.db --num-threads ${task.cpus}
	anvi-run-ncbi-cogs -c ${genome_name}.db --num-threads ${task.cpus} --cog-data-dir ${cog20}
	anvi-scan-trnas -c ${genome_name}.db --num-threads ${task.cpus}
	anvi-run-scg-taxonomy -c ${genome_name}.db --num-threads ${task.cpus} --scgs-taxonomy-data-dir ${scg_taxonomy}
	anvi-run-kegg-kofams -c ${genome_name}.db --num-threads ${task.cpus} --kegg-data-dir ${kegg}
    """
}

// Process for generating external genomes file for pangenome
process PANGENOME {
    publishDir "${params.outdir}/pangenome", mode: 'copy'
	container "docker://sysbiojfgg-anvio_cogpfam:v0.1"
	cpus = { 12 * task.attempt }
	memory = '48.GB'
	time = { 12.h * task.attempt }
	errorStrategy {  task.exitStatus in [143,137,104,134,139,255] ? 'retry' : 'finish' }
	maxRetries = 2
	maxForks 4
    
    input:
    path(dbs)
    
    output:
    tuple path("external-genomes.txt"), path("GENOMES.db"), emit: pangenome_db
    
    script:
    """
    # Create directory for databases
    
    # Generate external genomes file
    anvi-script-gen-genomes-file --input-dir . \\
        -o external-genomes_tmp.txt
    
    # Rename dots to underscores
    sed 's/\\./_/g' external-genomes_tmp.txt > external-genomes.txt

	anvi-gen-genomes-storage -e external-genomes.txt \\
        -o GENOMES.db

    anvi-pan-genome -g ${genomes_db} \\
        --project-name ${params.project_name} \\
        --num-threads ${task.cpus} \\

    anvi-compute-genome-similarity --external-genomes external-genomes.txt \\
        --program fastANI \\
        --output-dir ANI \\
        --num-threads ${task.cpus} \\
        --pan-db ${params.project_name}/${params.project_name}-PAN.db
    """
}