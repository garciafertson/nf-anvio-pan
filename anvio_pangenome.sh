#create external genomes file
anvi-script-gen-genomes-file --input-dir $1 \
                             -o external-genomes.txt
#rename dots to underscores
sed 's/\./_/' external-genomes.txt > tmp && mv tmp external-genomes.txt
#anvi-estimate-genome-completeness -e external-genomes.txt
anvi-gen-genomes-storage -e external-genomes.txt \
                         -o ${1}-GENOMES.db
anvi-pan-genome -g ${1}-GENOMES.db \
                --project-name $1 \
                --num-threads 4

#Display pangenome
#anvi-display-pan -p $1/$1-PAN.db \
#                 -g $1-GENOMES.db

#calculating average nucleotide identities
qanvi-compute-genome-similarity --external-genomes external-genomes.txt \
                               --program fastANI \
                               --output-dir ANI \
                               --num-threads 4 \
                               --pan-db $1/$1-PAN.db
