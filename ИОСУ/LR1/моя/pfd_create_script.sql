CREATE TABLE positions (
	name VARCHAR2(25),
	PRIMARY KEY (name)
);

CREATE TABLE employees (
	id INTEGER,
	full_name VARCHAR2(50) NOT NULL,
	position VARCHAR2(25) NOT NULL,
	mobile VARCHAR2(13) NOT NULL,
	is_free VARCHAR2(3) NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_empl_position FOREIGN KEY (position) REFERENCES positions (name) ON DELETE CASCADE,
	CONSTRAINT uq_empl_mobile UNIQUE (mobile),
	CONSTRAINT ck_empl_is_perform CHECK (is_free IN ('yes', 'no'))
);

CREATE TABLE events (
	id INTEGER,
	name VARCHAR2(100) NOT NULL,
	danger_class VARCHAR2(6) NOT NULL,
	work_unit VARCHAR2(25) NOT NULL,
	price DECIMAL(6,2) NOT NULL,
	required_position VARCHAR2(25) NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT ck_events_danger_class CHECK (danger_class IN ('low', 'medium', 'high')),
	CONSTRAINT fk_events_required_position FOREIGN KEY (required_position) REFERENCES positions (name) ON DELETE CASCADE
);

CREATE TABLE orders (
	id INTEGER,
	event_id INTEGER NOT NULL,
	address VARCHAR2(50) NOT NULL,
	client_mobile VARCHAR2(13) NOT NULL,
	work_amount DECIMAL(5,2) NOT NULL,
	app_date DATE NOT NULL,
	pref_execution_date DATE NOT NULL,
	execution_date DATE NULL,events
	cost DECIMAL(7,2) NOT NULL,
	status VARCHAR2(12) NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_orders_event_id FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE,
	CONSTRAINT ck_orders_status CHECK (status IN ('in line', 'is performed', 'done'))
);

CREATE TABLE order_employee (
	order_id INTEGER,
	empl_id INTEGER,
	PRIMARY KEY (order_id, empl_id)
);

CREATE INDEX idx_is_free ON employees (is_free);
CREATE INDEX idx_danger_class ON events (danger_class);
CREATE INDEX idx_orders_status ON orders (status);

CREATE SYNONYM o_e FOR order_employee;

CREATE SEQUENCE employees_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE events_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE orders_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;