# Anvi'o MAG Pipeline

A Nextflow pipeline for processing Metagenome-Assembled Genomes (MAGs) using Anvi'o 8.

## Overview

This pipeline processes individual genome files (.fna) through the Anvi'o workflow:
1. Reformats FASTA files (minimum length filtering)
2. Generates contigs databases
3. Runs functional annotations (COGs, tRNAs, taxonomy, KEGG)
4. Performs pangenome analysis
5. Calculates Average Nucleotide Identity (ANI)

## Prerequisites

- Nextflow (≥21.04.0)
- Anvi'o 8 (installed via Docker, Singularity, Conda, or locally)

## Installation

```bash
# Clone or navigate to the repository
cd /Users/jfgarcia/repositories/anvio_mag

# Install Nextflow if not already installed
curl -s https://get.nextflow.io | bash
```

## Usage

### Basic usage

```bash
nextflow run main.nf --genomes /path/to/genomes/directory
```

### With functional annotation databases

```bash
nextflow run main.nf \
  --genomes /path/to/genomes/directory \
  --cog_db /path/to/cog/database \
  --kegg_db /path/to/kegg/database \
  --outdir results \
  --threads 8
```

### Using Docker

```bash
nextflow run main.nf \
  --genomes /path/to/genomes/directory \
  -profile docker
```

### Using Singularity

```bash
nextflow run main.nf \
  --genomes /path/to/genomes/directory \
  -profile singularity
```

### Using Conda

```bash
nextflow run main.nf \
  --genomes /path/to/genomes/directory \
  -profile conda
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--genomes` | Path to directory containing .fna genome files | Required |
| `--cog_db` | Path to COG database directory | null |
| `--kegg_db` | Path to KEGG database directory | null |
| `--outdir` | Output directory for results | ./results |
| `--min_length` | Minimum contig length for filtering | 1000 |
| `--threads` | Number of threads for parallel processes | 4 |

## Output Structure

```
results/
├── 01_reformatted/          # Reformatted FASTA files
├── 02_contigs_db/           # Initial contigs databases
├── 03_annotated_db/         # Databases with COG annotations
├── 04_final_db/             # Fully annotated databases
├── 05_pangenome/            # Pangenome analysis results
│   ├── external-genomes.txt
│   ├── GENOMES.db
│   └── pangenome/
└── 06_ANI/                  # Average Nucleotide Identity results
```

## Execution Profiles

- `standard`: Local execution (default)
- `docker`: Run with Docker containers
- `singularity`: Run with Singularity containers
- `conda`: Run with Conda environment
- `slurm`: Submit jobs to SLURM cluster

## Examples

### Process genomes in current directory

```bash
nextflow run main.nf --genomes ./genomes
```

### Full pipeline with custom settings

```bash
nextflow run main.nf \
  --genomes ./my_genomes \
  --cog_db /data/COG_DB \
  --kegg_db /data/KEGG_DB \
  --outdir my_results \
  --min_length 2000 \
  --threads 16 \
  -profile docker
```

### Resume a failed run

```bash
nextflow run main.nf --genomes ./genomes -resume
```

## Notes

- Input genome files must have `.fna` extension
- Functional annotation databases (COG, KEGG) are optional but recommended
- The pipeline automatically creates an external genomes file for pangenome analysis
- ANI calculation requires at least 2 genomes

## Troubleshooting

### Database paths
If you're using local Anvi'o installation with custom database locations, specify them:
```bash
export ANVIO_COG_DATA_DIR=/path/to/cog
export ANVIO_KEGG_DATA_DIR=/path/to/kegg
```

### Memory issues
Adjust memory settings in `nextflow.config` if you encounter out-of-memory errors.

## References

- [Anvi'o Documentation](https://anvio.org)
- [Nextflow Documentation](https://www.nextflow.io/docs/latest/)
