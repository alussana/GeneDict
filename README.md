# GeneDict 

Use this workflow to download human gene ID mapping information between different databases from the [UniProt FTP server](https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/) and to generate [gene id dictionaries](#gene-id-dictionaries).

To implement the generation of a given gene id dictionary see [Generating a gene id dictionary](#generating-a-gene-id-dictionary).

## Build the container image

Requires [Docker](https://www.docker.com) and [Apptainer](https://apptainer.org).

```bash
docker build -t genedict - < env/genedict.dockerfile
docker save -o env/genedict.tar.gz genedict
apptainer build env/genedict.sif docker-archive://env/genedict.tar.gz
```

## Customise `nextflow.config`

Modify `process.executor`, `process.queue`, `workDir`, and `env.out_dir` according to the infrastructure where the workflow will be executed. Find the Nextflow [configuration file](https://www.nextflow.io/docs/latest/config.html) documentation.


Alternatively, as a quick start to run the workflow locally, just replace `nextflow.config` with `nextflow-local.config` (a backup `nextflow.config~` will be created):

```bash
mv nextflow-local.config nextflow.config -b
```


## Run the workflow

```bash
nextflow run -resume main.nf
```

Relevant output files are saved in `env.out_dir`.


## Gene ID dictionaries

A gene ID dictionary is a lookup tables that translates any gene nomenclature into any other gene nomenclature.
It takes the form of a 3-field tab-delimited file. For example, a dictionary to translate "Ensembl_PRO" ids into "Gene_Name" ids will have the fields:

1. Ensembl_PRO
2. UniProt AC referred to Ensembl_PRO
3. Gene_Name referred to UniProt AC

This file provides ID mapping in this order:

**Ensembl_PRO  --->  UniProt AC ---> Gene_Name**

_i.e._, all Ensembl_PRO ids are mapped to the corresponding UniProt ACs, and the UniProt ACs are then mapped to the corresponding Gene_Name ids.

Since ID mapping is not a biunivocal function, such order makes the lookup table only usable for A to B translation, not for B to A, and in many cases more than one translation for a given ID exist.

### Generating a gene id dictionary

To generate an arbitrary gene id dictionary a small appropriate workflow must be added to `main.nf` by pasting and modifying the following template:

```
workflow <WORKFLOW_NAME> {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                '<SOURCE_NOMENCLATURE>',
                                '<TARGET_NOMENCLATURE>' )

    emit:
        dict

}
```

to restrict available translations to only the ones provided through a UniProtAC belonging to the "reviewed" reference set, use instead the `IDa2uniprot_ref2IDb()` process:

```
workflow <WORKFLOW_NAME>__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    '<SOURCE_NOMENCLATURE>',
                                    '<TARGET_NOMENCLATURE>',
                                    uniprot_ref_ac_list )

    emit:
        dict

}
```

where `<SOURCE_NOMENCLATURE>` and `<TARGET_NOMENCLATURE>` are to be chosed from those listed in [Available ID nomenclatures](#available-id-nomenclatures), and `<WORKFLOW_NAME>` can be chosen arbitrarily.

Then, you just need to call your newly defined workflow in the main one in `main.nf`, by adding `<WORKFLOW_NAME>( uniprot_id_dict )`:

```
workflow HUMAN {

    uniprot_id_map = dl_selected_human()
    uniprot_id_dict = dl_human()

    <WORKFLOW_NAME>( uniprot_id_dict )

}
```

For example, to generate the translation from "Ensembl_PRO" to "Gene_Name", the following could be used:

```
workflow Ensembl_PRO__2__Gene_Name {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Ensembl_PRO',
                                'Gene_Name' )

    emit:
        dict

}

workflow HUMAN {

    uniprot_id_map = dl_selected_human()
    uniprot_id_dict = dl_human()
    
    Ensembl_PRO__2__Gene_Name( uniprot_id_dict )

}
```


## Available ID nomenclatures

ID mapping can be performed between any two of the following nomenclatures:

```
zcat ${out_dir}/uniprot/HUMAN_9606_idmapping.dat.gz | cut -f2 | sort | uniq
```

```
Allergome
BioCyc
BioGRID
BioMuta
CCDS
CPTAC
CRC64
ChEMBL
ChiTaRS
ComplexPortal
DIP
DMDM
DNASU
DisProt
DrugBank
EMBL
EMBL-CDS
ESTHER
Ensembl
Ensembl_PRO
Ensembl_TRS
GI
GeneCards
GeneID
GeneReviews
GeneTree
GeneWiki
Gene_Name
Gene_ORFName
Gene_Synonym
GenomeRNAi
GlyConnect
GuidetoPHARMACOLOGY
HGNC
HOGENOM
IDEAL
KEGG
MEROPS
MIM
MINT
NCBI_TaxID
OMA
Orphanet
OrthoDB
PATRIC
PDB
PeroxiBase
PharmGKB
ProteomicsDB
REBASE
Reactome
RefSeq
RefSeq_NT
STRING
SwissLipids
TCDB
TreeFam
UCSC
UniParc
UniPathway
UniProtKB-ID
UniRef100
UniRef50
UniRef90
VEuPathDB
eggNOG
neXtProt
```


## UniProt data issues

-[x] Some `Gene_Names` IDs also appear as `Gene_Synonym` IDs, and will likely lead to mistranslation when mapping these two nomenclatures to each other. Solution, implemented in `bin/IDa2uniprot2IDb.py`: when creating the gene dictionary, exclude translations where the word for the target nomenclature appears in the vocabulary of the source nomenclature.