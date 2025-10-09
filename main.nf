#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { dl_selected_human } from './processes'
include { dl_human } from './processes'
include { dl_ref_proteome_ac_list } from './processes'
include { IDa2uniprot2IDb } from './processes'
include { IDa2uniprot_ref2IDb } from './processes'

workflow Ensembl_PRO__2__HGNC {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Ensembl_PRO',
                                'HGNC' )

    emit:
        dict

}

workflow Gene_Name__2__GeneID {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Name',
                                'GeneID' )

    emit:
        dict

}

workflow Gene_Synonym__2__Gene_Name {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Synonym',
                                'Gene_Name' )

    emit:
        dict

}

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

workflow Ensembl__2__Gene_Name {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Ensembl',
                                'Gene_Name' )

    emit:
        dict

}

workflow Gene_Name__2__STRING {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Name',
                                'STRING' )

    emit:
        dict

}

workflow Gene_Name__2__HGNC {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Name',
                                'HGNC' )

    emit:
        dict

}

workflow Gene_Name__2__Ensembl {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Name',
                                'Ensembl' )

    emit:
        dict

}

workflow Gene_Name__2__Ensembl_PRO {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Name',
                                'Ensembl_PRO' )

    emit:
        dict

}

workflow Gene_Name__2__Reactome {

    take:
        uniprot_id_dict

    main:
        dict = IDa2uniprot2IDb( uniprot_id_dict,
                                'Gene_Name',
                                'Reactome' )

    emit:
        dict

}

workflow Ensembl_PRO__2__HGNC__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Ensembl_PRO',
                                    'HGNC',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Name__2__GeneID__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Name',
                                    'GeneID',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Synonym__2__Gene_Name__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Synonym',
                                    'Gene_Name',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Ensembl_PRO__2__Gene_Name__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Ensembl_PRO',
                                    'Gene_Name',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Name__2__STRING__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Name',
                                    'STRING',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Name__2__HGNC__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Name',
                                    'HGNC',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Name__2__Ensembl__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Name',
                                    'Ensembl',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Name__2__Ensembl_PRO__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Name',
                                    'Ensembl_PRO',
                                    uniprot_ref_ac_list )

    emit:
        dict

}

workflow Gene_Name__2__Reactome__ref {

    take:
        uniprot_id_dict
        uniprot_ref_ac_list

    main:
        dict = IDa2uniprot_ref2IDb( uniprot_id_dict,
                                    'Gene_Name',
                                    'Reactome',
                                    uniprot_ref_ac_list )

    emit:
        dict

}


workflow HUMAN {

    uniprot_id_map = dl_selected_human()
    uniprot_id_dict = dl_human()
    uniprot_ref_ac_list = dl_ref_proteome_ac_list()
 
    /*
    Gene_Name__2__GeneID( uniprot_id_dict )
    Ensembl_PRO__2__Gene_Name( uniprot_id_dict )
    Gene_Synonym__2__Gene_Name( uniprot_id_dict )
    */
    Ensembl__2__Gene_Name( uniprot_id_dict )
    /*
    Gene_Name__2__STRING( uniprot_id_dict )
    Gene_Name__2__HGNC( uniprot_id_dict )
    Gene_Name__2__Ensembl( uniprot_id_dict )
    Gene_Name__2__Ensembl_PRO( uniprot_id_dict )
    Gene_Name__2__Reactome( uniprot_id_dict )
    */

    /*
    Gene_Name__2__GeneID__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Ensembl_PRO__2__Gene_Name__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Gene_Synonym__2__Gene_Name__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Gene_Name__2__STRING__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Gene_Name__2__HGNC__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Gene_Name__2__Ensembl__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Gene_Name__2__Ensembl_PRO__ref( uniprot_id_dict, uniprot_ref_ac_list )
    Gene_Name__2__Reactome__ref( uniprot_id_dict, uniprot_ref_ac_list )
    */

}

workflow {

    HUMAN()

}