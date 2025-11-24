#!/bin/bash

# import the layers order file
anvi-import-misc-data -p $1-PAN.db \
                      -t layer_orders Rothia_mucilaginosa-phylogenomic-layer-order.txt

anvi-import-misc-data mag_metadata_2.tsv \
                      -p $1-PAN.db \
                      --target-data-table layers

anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                           --include-gc-identity-as-function \
                                          --annotation-source COG20_FUNCTION \
                                          -o ${1}_enriched-functions.txt
anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                          --annotation-source COG20_CATEGORY \
                                          -o ${1}_enriched-categories.txt

anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                          --annotation-source COG20_PATHWAY \
                                          -o ${1}_enriched-pathways.txt


##'KEGG_BRITE, KEGG_Class, KOfam, KEGG_Module'
anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                          --annotation-source KEGG_BRITE \
                                          -o ${1}_enriched-brite.txt

anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                          --annotation-source KEGG_Module \
                                          -o ${1}_enriched-modules.txt
anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                          --annotation-source KOfam \
                                          -o ${1}_enriched-kofams.txt

anvi-compute-functional-enrichment-in-pan -p $1-PAN.db\
                                          -g $1-GENOMES.db \
                                          --category-variable $2 \
                                          --annotation-source KEGG_Module \
                                          -o ${1}_enriched-kegg-modules.txt

