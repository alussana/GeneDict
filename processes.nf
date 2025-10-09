#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
.META:
1. UniProtKB-AC
2. UniProtKB-ID
3. GeneID (EntrezGene)
4. RefSeq
5. GI
6. PDB
7. GO
8. UniRef100
9. UniRef90
10. UniRef50
11. UniParc
12. PIR
13. NCBI-taxon
14. MIM
15. UniGene
16. PubMed
17. EMBL
18. EMBL-CDS
19. Ensembl
20. Ensembl_TRS
21. Ensembl_PRO
22. Additional PubMed
*/
process dl_selected_human {

    publishDir "${out_dir}",
                pattern: 'uniprot/HUMAN_9606_idmapping_selected.tab.gz',
                mode: 'copy'

    output:
        path 'uniprot/HUMAN_9606_idmapping_selected.tab.gz'

    shell:
    """
    mkdir -p uniprot

    wget -P uniprot ${params.human_selected_url}
    """

}

/*
.META:
1. UniProtKB-AC 
2. ID_type 
3. ID
*/
process dl_human {

    publishDir "${out_dir}",
                pattern: 'uniprot/HUMAN_9606_idmapping.dat.gz',
                mode: 'copy'

    output:
        path 'uniprot/HUMAN_9606_idmapping.dat.gz'

    shell:
    """
    mkdir -p uniprot

    wget -P uniprot ${params.human_url}
    """

}

/*
Use the UniProt API to retrieve a list of protein AC for reviewed entries
belonging to the human proteome
*/
process dl_ref_proteome_ac_list {

    publishDir "${out_dir}",
            pattern: 'databases/uniprot/hs_proteome_ac_list.txt',
            mode: 'copy'

    output:
        path 'databases/uniprot/hs_proteome_ac_list.txt'

    shell:
    """
    mkdir -p databases/uniprot

    wget -O databases/uniprot/hs_proteome_ac_list.txt '${params.human_reviewed_proteome_query}'
    """

}

/*
3-fields tab-delimited file

provides mapping in this order:

IDa --->  UniProt AC ---> IDb

all ids of nomenclature IDa are mapped to the corresponding UniProt ACs,
and the UniProt ACs are then mapped to the corresponding ids of nomenclature
IDb. For example, all ENSP ids are mapped to their UniProt AC. Then, each of
the UniProt AC identifiers is mapped to HGNC ids.

.META:
1. IDa
2. UniProt AC referred to IDa
3. IDb referred to UniProt AC
*/
process IDa2uniprot2IDb {

    publishDir "${out_dir}",
                pattern: "uniprot/${IDa}2uniprot2${IDb}.tsv",
                mode: 'copy'

    input:
        path 'input/mapping.tsv.gz'
        val IDa
        val IDb

    output:
        path "uniprot/${IDa}2uniprot2${IDb}.tsv"

    script:
    """
    mkdir -p uniprot

    zcat input/mapping.tsv.gz \
        | grep -w -f <(echo -e "${IDa}\\n${IDb}") \
        | gzip > mapping.tsv.gz

    IDa2uniprot2IDb.py \
        mapping.tsv.gz \
        ${IDa} \
        ${IDb} \
        > uniprot/${IDa}2uniprot2${IDb}.tsv
    """

}


/*
3-fields tab-delimited file

provides mapping in this order:

IDa --->  UniProt AC ---> IDb

all ids of nomenclature IDa are mapped to the corresponding UniProt ACs,
and the UniProt ACs are then mapped to the corresponding ids of nomenclature
IDb. For example, all ENSP ids are mapped to their UniProt AC. Then, each of
the UniProt AC identifiers is mapped to HGNC ids.

.META:
1. IDa
2. UniProt AC referred to IDa
3. IDb referred to UniProt AC
*/
process IDa2uniprot_ref2IDb {

    publishDir "${out_dir}",
                pattern: "uniprot/${IDa}2uniprot_ref2${IDb}.tsv",
                mode: 'copy'

    input:
        path 'input/mapping.tsv.gz'
        val IDa
        val IDb
        path 'input/hs_proteome_ac_list.txt'

    output:
        path "uniprot/${IDa}2uniprot_ref2${IDb}.tsv"

    script:
    """
    mkdir -p uniprot

    zcat input/mapping.tsv.gz \
        | grep -w -f <(echo -e "${IDa}\n${IDb}") \
        | gzip > mapping.tsv.gz

    IDa2uniprot2IDb.py \
        mapping.tsv.gz \
        ${IDa} \
        ${IDb} \
        | grep -w -f input/hs_proteome_ac_list.txt \
        > uniprot/${IDa}2uniprot_ref2${IDb}.tsv
    """

}