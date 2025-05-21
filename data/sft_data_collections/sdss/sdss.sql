CREATE TABLE specobj (
	specobjid NUMERIC(20, 0) NOT NULL, 
	bestobjid BIGINT, 
	plateid NUMERIC(20, 0), 
	scienceprimary SMALLINT, 
	segue2primary SMALLINT, 
	survey VARCHAR(32), 
	programname VARCHAR(32), 
	mjd INTEGER, 
	plate SMALLINT, 
	fiberid SMALLINT, 
	special_target1 BIGINT, 
	segue2_target1 BIGINT, 
	segue2_target2 BIGINT, 
	ancillary_target1 BIGINT, 
	ra DOUBLE PRECISION, 
	dec DOUBLE PRECISION, 
	z REAL, 
	zerr REAL, 
	zwarning INTEGER, 
	class VARCHAR(32), 
	subclass VARCHAR(32), 
	veldisp REAL, 
	veldisperr REAL, 
	loadversion INTEGER, 
	CONSTRAINT specobj_pk PRIMARY KEY (specobjid), 
	CONSTRAINT fk_specobj FOREIGN KEY(bestobjid) REFERENCES photoobj (objid)
);
CREATE TABLE photoobj (
	objid BIGINT NOT NULL, 
	run SMALLINT, 
	rerun SMALLINT, 
	field SMALLINT, 
	mode SMALLINT, 
	type SMALLINT, 
	clean INTEGER, 
	flags BIGINT, 
	rowc REAL, 
	colc REAL, 
	cmodelmag_u REAL, 
	cmodelmag_g REAL, 
	cmodelmag_r REAL, 
	ra DOUBLE PRECISION, 
	dec DOUBLE PRECISION, 
	b DOUBLE PRECISION, 
	l DOUBLE PRECISION, 
	extinction_r REAL, 
	mjd INTEGER, 
	loadversion INTEGER, 
	u REAL, 
	g REAL, 
	r REAL, 
	i REAL, 
	z REAL, 
	CONSTRAINT photoobj_pk PRIMARY KEY (objid), 
	CONSTRAINT photoobj__photo_type_value_fk FOREIGN KEY(type) REFERENCES photo_type (value)
);
CREATE TABLE photo_type (
	value INTEGER NOT NULL, 
	name VARCHAR, 
	description TEXT, 
	CONSTRAINT photo_type_pk PRIMARY KEY (value)
);
CREATE TABLE galspecline (
	specobjid NUMERIC(20, 0) NOT NULL, 
	CONSTRAINT galspecline_pk PRIMARY KEY (specobjid), 
	CONSTRAINT fk_galspecline FOREIGN KEY(specobjid) REFERENCES specobj (specobjid)
);
CREATE TABLE neighbors (
	objid BIGINT, 
	neighborobjid BIGINT, 
	distance DOUBLE PRECISION, 
	type SMALLINT, 
	neighbortype SMALLINT, 
	mode SMALLINT, 
	neighbormode SMALLINT, 
	CONSTRAINT fk_neighbors FOREIGN KEY(objid) REFERENCES photoobj (objid)
);
CREATE TABLE spplines (
	specobjid NUMERIC(20, 0) NOT NULL, 
	CONSTRAINT spplines_pk PRIMARY KEY (specobjid), 
	CONSTRAINT fk_spplines FOREIGN KEY(specobjid) REFERENCES specobj (specobjid)
);
