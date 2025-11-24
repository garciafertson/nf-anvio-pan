#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Import workflow
include { ANVIO_WORKFLOW } from './workflow.nf'

// Parameters
params.genomes = null
params.cog_db = null
params.kegg_db = null
params.outdir = "./results"
params.min_length = 1000
params.threads = 4

// Main workflow
workflow {
   // Validate required parameters
    if (!params.genomes) {
        error "Please provide --genomes parameter (path to directory with .fna files or glob pattern)"
    }   
    // Run the Anvi'o workflow
    ANVIO_WORKFLOW()
}