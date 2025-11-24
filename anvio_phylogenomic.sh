##This script 1) run phylogenomic analysis on SCG 
#imports metadata for the pangenome analysis  anvi-import-misc-data
## and computes functional enrichment in pagenomes anvi-compute-functional-enrichment-in-pan

anvi-get-sequences-for-gene-clusters -p Rothia_mucilaginosa/Rothia_mucilaginosa-PAN.db\
                                     -g Rothia_mucilaginosa-GENOMES.db \
                                     --min-num-genomes-gene-cluster-occurs 31 \
                                     --max-num-genes-from-each-genome 1 \
                                     --concatenate-gene-clusters \
                                     --output-file Rothia_mucilaginosa-SCGs.fa

trimal -in Rothia_mucilaginosa-SCGs.fa \
       -out Rothia_mucilaginosa-SCGs-clean.fa \
       -gt 0.50

#-resoverlap  Minimum overlap of a positions with other positions in the column to be considered a "good position". Range: [0 - 1]. (see User Guide).
#-seqoverlap  Minimum percentage of "good positions" that a sequence must have in order to be conserved. Range: [0 - 100].

iqtree -s Rothia_mucilaginosa-SCGs-clean.fa \
       -nt 8 \
       -m WAG \
       -bb 1000

echo -e "item_name\tdata_type\tdata_value" \
         > Rothia_mucilaginosa-phylogenomic-layer-order.txt

# add the newick tree as an order
echo -e "SCGs_Bayesian_Tree\tnewick\t`cat Rothia_mucilaginosa-SCGs-clean.fa.contree`" \
        >> Rothia_mucilaginosa-phylogenomic-layer-order.txt


