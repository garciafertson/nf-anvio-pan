#bash script to un anvio pipeline for one mag
#anvio is installed in a singularity container
#!/bin/bash

#step 1
anvi-script-reformat-fasta ${g}.fna \
							--min-len 1000 \
							--simplify-names \
							-o ${g}_scaffolds_1K.fasta

#step2
anvi-gen-contigs-database -f ${g}_scaffolds_1K.fasta \
                          -o ${g}.db \
                          --num-threads 2 \
                          -n ${g}

anvi-run-ncbi-cogs -c ${g}.db --num-threads 4
anvi-scan-trnas -c ${g}.db --num-threads 4
anvi-run-scg-taxonomy -c ${g}.db --num-threads 4
anvi-run-kegg-kofams -c ${g}.db --num-threads 4

