#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Import Anvi'o modules
include { PANGENOME } from '../modules/anvio.nf'
include { GENOMEDB } from '../modules/anvio.nf'

workflow ANVIO_WORKFLOW {
    //control structure 2 parameters    
    // Read input parameters   
    // Channel for genome directory in fasta format
    if (params.run_genomedb) {
        genome_files = Channel
            .fromPath("${params.genomes}/*.fna")
            .map { file -> tuple(file.baseName, file) }
        // Channel for COG20 database directory
        cog_db_ch = params.cog_db ? Channel.fromPath(params.cog_db, checkIfExists: true) : Channel.empty()
                // Channel for KEGG database directory
        kegg_db_ch = params.kegg_db ? Channel.fromPath(params.kegg_db, checkIfExists: true) : Channel.empty()

        GENOMEDB ( genome_files, cog_db_ch, kegg_db_ch )
    }
    if (params.run_pangenmoe) {
    	genome_dbs = GENOMEDB.out.genome_db.collect()
    	PANGENOME ( genome_dbs  )
    }

}

