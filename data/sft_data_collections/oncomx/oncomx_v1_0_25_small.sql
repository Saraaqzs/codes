CREATE TABLE anatomical_entity (
	id VARCHAR NOT NULL, 
	name VARCHAR, 
	description TEXT, 
	CONSTRAINT idx_18385_primary PRIMARY KEY (id)
);CREATE TABLE biomarker (
	id VARCHAR DEFAULT '0', 
	gene_symbol VARCHAR, 
	biomarker_description TEXT, 
	biomarker_id VARCHAR, 
	test_is_a_panel INTEGER NOT NULL, 
	CONSTRAINT idx_18391_primary PRIMARY KEY (id)
);CREATE TABLE disease (
	id INTEGER NOT NULL, 
	name VARCHAR NOT NULL, 
	CONSTRAINT idx_18463_primary PRIMARY KEY (id)
);CREATE TABLE map_uniprot_canonical_id (
	uniprotkb_ac VARCHAR NOT NULL, 
	uniprotkb_canonical_ac VARCHAR NOT NULL, 
	CONSTRAINT idx_18520_primary PRIMARY KEY (uniprotkb_ac)
);CREATE TABLE species (
	speciesid INTEGER NOT NULL, 
	genus VARCHAR NOT NULL, 
	species VARCHAR NOT NULL, 
	speciescommonname VARCHAR NOT NULL, 
	CONSTRAINT idx_18526_primary PRIMARY KEY (speciesid)
);CREATE TABLE stage (
	id VARCHAR NOT NULL, 
	name VARCHAR NOT NULL, 
	CONSTRAINT idx_18529_primary PRIMARY KEY (id)
);CREATE TABLE biomarker_alias (
	biomarker_internal_id VARCHAR NOT NULL, 
	alias VARCHAR, 
	CONSTRAINT idx_18398_primary PRIMARY KEY (biomarker_internal_id, alias), 
	CONSTRAINT fk_biomarker_alias FOREIGN KEY(biomarker_internal_id) REFERENCES biomarker (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_article (
	biomarker_internal_id VARCHAR DEFAULT '0', 
	pmid VARCHAR, 
	CONSTRAINT idx_18401_primary PRIMARY KEY (biomarker_internal_id, pmid), 
	CONSTRAINT fk_biomarker_article FOREIGN KEY(biomarker_internal_id) REFERENCES biomarker (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_edrn (
	id VARCHAR DEFAULT '0', 
	qa_state VARCHAR NOT NULL, 
	biomarker_title VARCHAR NOT NULL, 
	biomarker_type VARCHAR NOT NULL, 
	uberon_anatomical_id VARCHAR NOT NULL, 
	phase VARCHAR, 
	CONSTRAINT idx_18405_primary PRIMARY KEY (id), 
	CONSTRAINT fk_biomarker_edrn_anat FOREIGN KEY(uberon_anatomical_id) REFERENCES anatomical_entity (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT fk_biomarker_edrn_id FOREIGN KEY(id) REFERENCES biomarker (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_fda_test (
	test_trade_name VARCHAR NOT NULL, 
	test_manufacturer VARCHAR NOT NULL, 
	test_submission VARCHAR NOT NULL, 
	biomarker_origin VARCHAR NOT NULL, 
	doid INTEGER NOT NULL, 
	histological_type VARCHAR NOT NULL, 
	specimen_type VARCHAR NOT NULL, 
	platform_method VARCHAR NOT NULL, 
	test_number_genes INTEGER NOT NULL, 
	test_adoption_evidence VARCHAR NOT NULL, 
	test_approval_status VARCHAR NOT NULL, 
	test_study_design VARCHAR, 
	clinical_significance TEXT NOT NULL, 
	CONSTRAINT idx_18433_primary PRIMARY KEY (test_submission, test_trade_name), 
	CONSTRAINT fk_biomarker_fda_test_doid FOREIGN KEY(doid) REFERENCES disease (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE cancer_tissue (
	doid INTEGER NOT NULL, 
	uberon_anatomical_id VARCHAR NOT NULL, 
	CONSTRAINT idx_26577_primary PRIMARY KEY (doid, uberon_anatomical_id), 
	CONSTRAINT fk_doid_cancer_tissue FOREIGN KEY(doid) REFERENCES disease (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT fk_uberon_cancer_tissue FOREIGN KEY(uberon_anatomical_id) REFERENCES anatomical_entity (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE differential_expression (
	gene_symbol VARCHAR NOT NULL, 
	doid INTEGER NOT NULL, 
	log2fc FLOAT NOT NULL, 
	pvalue FLOAT NOT NULL, 
	adjpvalue FLOAT NOT NULL, 
	statistical_significance VARCHAR NOT NULL, 
	expression_change_direction VARCHAR NOT NULL, 
	subjects_up INTEGER NOT NULL, 
	subjects_down INTEGER NOT NULL, 
	subjects_nochange INTEGER NOT NULL, 
	subjects_nocoverage INTEGER NOT NULL, 
	subjects_total INTEGER NOT NULL, 
	CONSTRAINT idx_26580_primary PRIMARY KEY (gene_symbol, doid), 
	CONSTRAINT fk_df_doid FOREIGN KEY(doid) REFERENCES disease (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE map_protein_disease_mutation (
	peptide_id VARCHAR NOT NULL, 
	ensembl_transcript_id VARCHAR NOT NULL, 
	uniprotkb_ac VARCHAR NOT NULL, 
	CONSTRAINT idx_18517_primary PRIMARY KEY (ensembl_transcript_id), 
	CONSTRAINT fk_uniprotkb_ac FOREIGN KEY(uniprotkb_ac) REFERENCES map_uniprot_canonical_id (uniprotkb_ac) ON UPDATE CASCADE
);CREATE TABLE xref_gene_ensembl (
	gene_symbol VARCHAR NOT NULL, 
	ensembl_gene_id VARCHAR NOT NULL, 
	speciesid INTEGER NOT NULL, 
	CONSTRAINT idx_18532_primary PRIMARY KEY (ensembl_gene_id), 
	CONSTRAINT fk_gene_speciesid FOREIGN KEY(speciesid) REFERENCES species (speciesid) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_fda (
	id VARCHAR DEFAULT '0', 
	test_trade_name VARCHAR NOT NULL, 
	test_submission VARCHAR NOT NULL, 
	CONSTRAINT idx_18415_primary PRIMARY KEY (id), 
	CONSTRAINT fk_biomarker_fda_id FOREIGN KEY(id) REFERENCES biomarker (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT fk_biomarker_fda_test FOREIGN KEY(test_submission, test_trade_name) REFERENCES biomarker_fda_test (test_submission, test_trade_name) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_fda_test_trial (
	test_trade_name VARCHAR NOT NULL, 
	test_submission VARCHAR NOT NULL, 
	test_trial_id VARCHAR NOT NULL, 
	CONSTRAINT idx_18439_primary PRIMARY KEY (test_trade_name, test_submission, test_trial_id), 
	CONSTRAINT fk_biomarker_fda_test_trial FOREIGN KEY(test_submission, test_trade_name) REFERENCES biomarker_fda_test (test_submission, test_trade_name) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_fda_test_use (
	id INTEGER NOT NULL, 
	test_trade_name VARCHAR NOT NULL, 
	test_submission VARCHAR NOT NULL, 
	approved_indication VARCHAR NOT NULL, 
	actual_use VARCHAR NOT NULL, 
	CONSTRAINT idx_18447_primary PRIMARY KEY (id), 
	CONSTRAINT fk_biomarker_fda_test_use FOREIGN KEY(test_submission, test_trade_name) REFERENCES biomarker_fda_test (test_submission, test_trade_name) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE disease_mutation (
	id INTEGER NOT NULL, 
	chromosome_id VARCHAR NOT NULL, 
	chromosome_pos INTEGER NOT NULL, 
	ref_nt VARCHAR NOT NULL, 
	alt_nt VARCHAR NOT NULL, 
	ensembl_transcript_id VARCHAR NOT NULL, 
	cds_pos INTEGER NOT NULL, 
	peptide_pos INTEGER NOT NULL, 
	aa_pos_uniprotkb INTEGER NOT NULL, 
	ref_aa VARCHAR NOT NULL, 
	alt_aa VARCHAR NOT NULL, 
	mutation_freq INTEGER NOT NULL, 
	data_source VARCHAR NOT NULL, 
	doid INTEGER NOT NULL, 
	CONSTRAINT idx_18468_primary PRIMARY KEY (id), 
	CONSTRAINT fk_disease_mutation_doid FOREIGN KEY(doid) REFERENCES disease (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT fk_ensembl_transcript FOREIGN KEY(ensembl_transcript_id) REFERENCES map_protein_disease_mutation (ensembl_transcript_id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE healthy_expression (
	ensembl_gene_id VARCHAR NOT NULL, 
	uberon_anatomical_id VARCHAR NOT NULL, 
	uberon_developmental_id VARCHAR NOT NULL, 
	expression_level_gene_relative VARCHAR NOT NULL, 
	expression_level_anatomical_relative VARCHAR NOT NULL, 
	call_quality VARCHAR NOT NULL, 
	expression_rank_score FLOAT NOT NULL, 
	expression_score FLOAT NOT NULL, 
	CONSTRAINT idx_18502_primary PRIMARY KEY (ensembl_gene_id, uberon_anatomical_id, uberon_developmental_id), 
	CONSTRAINT fk_ensg_he FOREIGN KEY(ensembl_gene_id) REFERENCES xref_gene_ensembl (ensembl_gene_id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT fk_stage FOREIGN KEY(uberon_developmental_id) REFERENCES stage (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT fk_uberon_he FOREIGN KEY(uberon_anatomical_id) REFERENCES anatomical_entity (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_fda_drug (
	biomarker_fda_id VARCHAR DEFAULT '0', 
	biomarker_drug VARCHAR, 
	CONSTRAINT idx_18419_primary PRIMARY KEY (biomarker_fda_id, biomarker_drug), 
	CONSTRAINT fk_biomarker_fda_drug FOREIGN KEY(biomarker_fda_id) REFERENCES biomarker_fda (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE biomarker_fda_ncit_term (
	biomarker_fda_id VARCHAR DEFAULT '0', 
	ncit_biomarker VARCHAR NOT NULL, 
	CONSTRAINT idx_18423_primary PRIMARY KEY (biomarker_fda_id, ncit_biomarker), 
	CONSTRAINT fk_biomarker_fda_ncit FOREIGN KEY(biomarker_fda_id) REFERENCES biomarker_fda (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE disease_mutation_article (
	pmid INTEGER NOT NULL, 
	disease_mutation_id INTEGER NOT NULL, 
	CONSTRAINT idx_18472_primary PRIMARY KEY (disease_mutation_id, pmid), 
	CONSTRAINT fk_dm_article_id FOREIGN KEY(disease_mutation_id) REFERENCES disease_mutation (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE disease_mutation_impact_prediction (
	id INTEGER NOT NULL, 
	disease_mutation_id INTEGER NOT NULL, 
	site_prediction VARCHAR NOT NULL, 
	probability FLOAT, 
	tool VARCHAR NOT NULL, 
	CONSTRAINT idx_18477_primary PRIMARY KEY (id), 
	CONSTRAINT fk_dm_impact_prediction_id FOREIGN KEY(disease_mutation_id) REFERENCES disease_mutation (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE disease_mutation_site_annotation (
	id INTEGER NOT NULL, 
	disease_mutation_id INTEGER NOT NULL, 
	description VARCHAR, 
	feature_key VARCHAR NOT NULL, 
	CONSTRAINT idx_18492_primary PRIMARY KEY (id), 
	CONSTRAINT fk_dm_site_annotation_id FOREIGN KEY(disease_mutation_id) REFERENCES disease_mutation (id) ON DELETE CASCADE ON UPDATE CASCADE
);CREATE TABLE disease_mutation_tissue (
	uberon_anatomical_id VARCHAR NOT NULL, 
	disease_mutation_id INTEGER NOT NULL, 
	CONSTRAINT idx_18499_primary PRIMARY KEY (uberon_anatomical_id, disease_mutation_id), 
	CONSTRAINT idx_fk_disease_mutation_id FOREIGN KEY(disease_mutation_id) REFERENCES disease_mutation (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT idx_fk_disease_mutation_uberon FOREIGN KEY(uberon_anatomical_id) REFERENCES anatomical_entity (id) ON DELETE CASCADE ON UPDATE CASCADE
);
