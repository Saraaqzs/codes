CREATE TABLE activity_types (
	code TEXT, 
	description TEXT, 
	CONSTRAINT activity_types_pkey PRIMARY KEY (code)
);CREATE TABLE countries (
	unics_id INTEGER NOT NULL, 
	country_name TEXT NOT NULL, 
	country_code2 VARCHAR NOT NULL, 
	country_code3 VARCHAR NOT NULL, 
	geocode_country_code VARCHAR, 
	CONSTRAINT countries_pkey PRIMARY KEY (unics_id), 
	CONSTRAINT countries_country_code2_key UNIQUE (country_code2)
);CREATE TABLE ec_framework_programs (
	ec_framework_program_name TEXT NOT NULL, 
	CONSTRAINT ec_framework_programs_pkey PRIMARY KEY (ec_framework_program_name)
);CREATE TABLE erc_research_domains (
	code TEXT NOT NULL, 
	description TEXT, 
	CONSTRAINT erc_research_domains_pkey PRIMARY KEY (code)
);CREATE TABLE eu_territorial_units (
	geocode_regions TEXT NOT NULL, 
	description TEXT, 
	geocode_level INTEGER, 
	nuts_version TEXT, 
	CONSTRAINT eu_territorial_units_pkey PRIMARY KEY (geocode_regions)
);CREATE TABLE funding_schemes (
	code TEXT, 
	title TEXT, 
	CONSTRAINT funding_schemes_pkey PRIMARY KEY (code)
);CREATE TABLE people (
	unics_id INTEGER  NOT NULL, 
	full_name TEXT, 
	CONSTRAINT people_pkey PRIMARY KEY (unics_id)
);CREATE TABLE programmes (
	code TEXT NOT NULL, 
	rcn TEXT, 
	title TEXT, 
	short_name TEXT, 
	parent TEXT, 
	CONSTRAINT programmes_pkey PRIMARY KEY (code), 
	CONSTRAINT programmes_parent_fkey FOREIGN KEY(parent) REFERENCES programmes (code) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE project_member_roles (
	code TEXT NOT NULL, 
	description TEXT, 
	CONSTRAINT project_member_roles_pkey PRIMARY KEY (code)
);CREATE TABLE subject_areas (
	code TEXT NOT NULL, 
	title TEXT, 
	description TEXT, 
	CONSTRAINT subject_areas_pkey PRIMARY KEY (code)
);CREATE TABLE topics (
	code TEXT NOT NULL, 
	rcn TEXT, 
	title TEXT, 
	CONSTRAINT topics_pkey PRIMARY KEY (code)
);CREATE TABLE erc_panels (
	code TEXT NOT NULL, 
	description TEXT, 
	part_of TEXT, 
	CONSTRAINT erc_panels_pkey PRIMARY KEY (code), 
	CONSTRAINT erc_panels_part_of_fkey FOREIGN KEY(part_of) REFERENCES erc_research_domains (code) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE institutions (
	unics_id INTEGER NOT NULL, 
	country_id INTEGER, 
	institutions_name TEXT NOT NULL, 
	geocode_regions_3 TEXT, 
	db_pedia_url TEXT, 
	wikidata_url TEXT, 
	grid_id TEXT, 
	acronym TEXT, 
	short_name TEXT, 
	website TEXT, 
	document_vectors TEXT, 
	CONSTRAINT institutions_pkey PRIMARY KEY (unics_id), 
	CONSTRAINT institutions_countries_unics_id_fk FOREIGN KEY(country_id) REFERENCES countries (unics_id), 
	CONSTRAINT institutions_geocode_regions_3_fkey FOREIGN KEY(geocode_regions_3) REFERENCES eu_territorial_units (geocode_regions) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE projects (
	unics_id INTEGER  NOT NULL, 
	acronym TEXT, 
	title TEXT, 
	ec_call TEXT, 
	ec_fund_scheme TEXT, 
	cordis_ref TEXT, 
	ec_ref TEXT, 
	start_date DATE, 
	end_date DATE, 
	start_year INTEGER, 
	end_year INTEGER, 
	homepage TEXT, 
	total_cost FLOAT, 
	ec_max_contribution FLOAT, 
	framework_program TEXT, 
	objective TEXT, 
	principal_investigator INTEGER, 
	CONSTRAINT projects_pkey PRIMARY KEY (unics_id), 
	CONSTRAINT projects_ec_fund_scheme_fkey FOREIGN KEY(ec_fund_scheme) REFERENCES funding_schemes (code) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT projects_framework_program_fkey FOREIGN KEY(framework_program) REFERENCES ec_framework_programs (ec_framework_program_name) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT projects_principal_investigator_fkey FOREIGN KEY(principal_investigator) REFERENCES people (unics_id) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT projects_cordis_ref_key UNIQUE (cordis_ref), 
	CONSTRAINT projects_ec_ref_key UNIQUE (ec_ref)
);CREATE TABLE project_erc_panels (
	project INTEGER NOT NULL, 
	panel TEXT NOT NULL, 
	CONSTRAINT project_erc_panels_pkey PRIMARY KEY (project), 
	CONSTRAINT project_erc_panels_panel_fkey FOREIGN KEY(panel) REFERENCES erc_panels (code) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT project_erc_panels_project_fkey FOREIGN KEY(project) REFERENCES projects (unics_id) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE project_members (
	unics_id INTEGER  NOT NULL, 
	project INTEGER NOT NULL, 
	pic_number TEXT, 
	rcn TEXT, 
	member_name TEXT, 
	activity_type TEXT, 
	country TEXT, 
	street TEXT, 
	city TEXT, 
	postal_code TEXT, 
	ec_contribution FLOAT, 
	institution_id INTEGER, 
	member_role TEXT NOT NULL, 
	geocode_regions_3 TEXT, 
	member_short_name TEXT, 
	department_name TEXT, 
	vat_number VARCHAR, 
	latitude FLOAT, 
	longitude FLOAT, 
	region_code TEXT, 
	region_name TEXT, 
	CONSTRAINT project_members_pkey PRIMARY KEY (unics_id), 
	CONSTRAINT project_members_activity_type_fkey FOREIGN KEY(activity_type) REFERENCES activity_types (code) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT project_members_institutions_unics_id_fk FOREIGN KEY(institution_id) REFERENCES institutions (unics_id), 
	CONSTRAINT project_members_member_role_fkey FOREIGN KEY(member_role) REFERENCES project_member_roles (code), 
	CONSTRAINT project_members_nuts3_code_fkey FOREIGN KEY(geocode_regions_3) REFERENCES eu_territorial_units (geocode_regions) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT project_members_project_fkey FOREIGN KEY(project) REFERENCES projects (unics_id) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE project_programmes (
	project INTEGER NOT NULL, 
	programme TEXT NOT NULL, 
	CONSTRAINT project_programmes_pkey PRIMARY KEY (project, programme), 
	CONSTRAINT project_programmes_programme_fkey FOREIGN KEY(programme) REFERENCES programmes (code) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT project_programmes_project_fkey FOREIGN KEY(project) REFERENCES projects (unics_id) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE project_subject_areas (
	project INTEGER NOT NULL, 
	subject_area TEXT NOT NULL, 
	CONSTRAINT project_subject_areas_pkey PRIMARY KEY (project, subject_area), 
	CONSTRAINT project_subject_areas_project_fkey FOREIGN KEY(project) REFERENCES projects (unics_id) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT project_subject_areas_subject_area_fkey FOREIGN KEY(subject_area) REFERENCES subject_areas (code) DEFERRABLE INITIALLY DEFERRED
);CREATE TABLE project_topics (
	project INTEGER NOT NULL, 
	topic TEXT NOT NULL, 
	CONSTRAINT project_topics_pkey PRIMARY KEY (project, topic), 
	CONSTRAINT project_topics_project_fkey FOREIGN KEY(project) REFERENCES projects (unics_id) DEFERRABLE INITIALLY DEFERRED, 
	CONSTRAINT project_topics_topic_fkey FOREIGN KEY(topic) REFERENCES topics (code) DEFERRABLE INITIALLY DEFERRED
);
