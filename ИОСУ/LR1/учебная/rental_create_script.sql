
CREATE TABLE Branch (
	bno INTEGER,
	street VARCHAR2(25) NOT NULL,
	city VARCHAR2(7) NOT NULL,
	tel_no VARCHAR2(13) NOT NULL,
	PRIMARY KEY (bno),
	CONSTRAINT ck_branch_city CHECK (city IN ('Minsk', 'Mogilev', 'Brest', 'Vitebsk', 'Grodno', 'Gomel')),
	CONSTRAINT uq_branch_tel_no UNIQUE (tel_no)
);

CREATE TABLE Staff (
	sno INTEGER,
	fname VARCHAR2(25) NOT NULL,
	lname VARCHAR2(25) NOT NULL,
	address VARCHAR2(45) NOT NULL,
	tel_no VARCHAR2(13) NOT NULL,
	position VARCHAR2(25) NOT NULL,
	sex VARCHAR2(6) NOT NULL,
	dob DATE NOT NULL,
	salary DECIMAL(7,2) NOT NULL,
	bno INTEGER NOT NULL,
	PRIMARY KEY (sno),
	CONSTRAINT uq_staff_tel_no UNIQUE (tel_no),
	CONSTRAINT ch_sex CHECK (sex IN ('male', 'female')),
	CONSTRAINT fk_staff_bno FOREIGN KEY (bno) REFERENCES Branch (bno) ON DELETE CASCADE
);

CREATE TABLE Owner (
	ono INTEGER,
	fname VARCHAR2(25) NOT NULL,
	lname VARCHAR2(25) NOT NULL,
	address VARCHAR2(45) NOT NULL,
	tel_no VARCHAR2(13) NOT NULL,
	PRIMARY KEY (ono),
	CONSTRAINT uq_owner_tel_no UNIQUE (tel_no)
);

CREATE TABLE Property_for_rent (
	pno INTEGER,
	street VARCHAR2(25) NOT NULL,
	city VARCHAR2(7) NOT NULL,
	type CHAR(1) NOT NULL,
	rooms SMALLINT NOT NULL,
	rent DECIMAL(7,2) NOT NULL,
	ono INTEGER NOT NULL,
	sno INTEGER NOT NULL,
	bno INTEGER NOT NULL,
	PRIMARY KEY (pno),
	CONSTRAINT ck_pfr_city CHECK (city IN ('Minsk', 'Mogilev', 'Brest', 'Vitebsk', 'Grodno', 'Gomel')),
	CONSTRAINT ck_pfr_type CHECK (type IN ('h', 'f')),
	CONSTRAINT fk_pfr_bno FOREIGN KEY (bno) REFERENCES Branch (bno) ON DELETE CASCADE,
	CONSTRAINT fk_pfr_sno FOREIGN KEY (sno) REFERENCES Staff (sno) ON DELETE CASCADE,
	CONSTRAINT fk_owner_ono FOREIGN KEY (ono) REFERENCES Owner (ono) ON DELETE CASCADE
); 

CREATE TABLE Renter (
	rno INTEGER,
	fname VARCHAR2(25) NOT NULL,
	lname VARCHAR2(25) NOT NULL,
	address VARCHAR2(45) NOT NULL,
	tel_no VARCHAR2(13) NOT NULL,
	pref_type CHAR(1) NOT NULL,
	max_rent DECIMAL(7,2) NOT NULL,
	bno INTEGER NOT NULL,
	PRIMARY KEY (rno),
	CONSTRAINT uq_renter_tel_no UNIQUE (tel_no),
	CONSTRAINT ck_renter_type CHECK (pref_type IN ('h', 'f')),
	CONSTRAINT fk_renter_bno FOREIGN KEY (bno) REFERENCES Branch (bno) ON DELETE CASCADE
);

CREATE TABLE Viewing (
	rno INTEGER,
	pno INTEGER,
	date_o DATE NOT NULL,
	comment_o LONG NULL,
	PRIMARY KEY (rno, pno),
	CONSTRAINT fk_v_rno FOREIGN KEY (rno) REFERENCES Renter (rno) ON DELETE CASCADE,
	CONSTRAINT fk_v_pno FOREIGN KEY (pno) REFERENCES Property_for_rent (pno) ON DELETE CASCADE
);

CREATE SYNONYM objects FOR Property_for_rent;

CREATE SEQUENCE Staff_seq
 START WITH     10
 INCREMENT BY   5
 NOCACHE
 NOCYCLE;