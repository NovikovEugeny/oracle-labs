
--positions
INSERT INTO positions VALUES ('painter');
INSERT INTO positions VALUES ('plasterer');
INSERT INTO positions VALUES ('roofer');
INSERT INTO positions VALUES ('stonemason');
INSERT INTO positions VALUES ('carpenter');

--employees
INSERT INTO employees VALUES (employees_seq.nextval, 'Ivanov Ivan Ivanovich', 'painter', '+375291111111', 'yes');
INSERT INTO employees VALUES (employees_seq.nextval, 'Petrov Ivan Ivanovich', 'painter', '+375292222222', 'no');
INSERT INTO employees VALUES (employees_seq.nextval, 'Sokolov Stepan Petrovich', 'plasterer', '+375293333333', 'yes');
INSERT INTO employees VALUES (employees_seq.nextval, 'Ivanov Oleg Timofeevich', 'plasterer', '+375294444444', 'no');
INSERT INTO employees VALUES (employees_seq.nextval, 'Galkin Petr Vasilievich', 'roofer', '+375295555555', 'yes');
INSERT INTO employees VALUES (employees_seq.nextval, 'Smirnov Dmitrii Petrovich', 'roofer', '+375296666666', 'no');
INSERT INTO employees VALUES (employees_seq.nextval, 'Sobakin Efim Semenovich', 'stonemason', '+375297777777', 'yes');
INSERT INTO employees VALUES (employees_seq.nextval, 'Kulicov Ivan Andreevich', 'stonemason', '+375298888888', 'no');
INSERT INTO employees VALUES (employees_seq.nextval, 'Iliin Oleg Ivanovich', 'carpenter', '+375299999999', 'yes');
INSERT INTO employees VALUES (employees_seq.nextval, 'Antonov Semen Ivanovich', 'carpenter', '+375291000000', 'no');

--events
INSERT INTO events VALUES (events_seq.nextval, 'Wall painting', 'medium', 'm2', '3', 'painter');
INSERT INTO events VALUES (events_seq.nextval, 'BrickLaying', 'medium', 'm3', '100', 'stonemason');
INSERT INTO events VALUES (events_seq.nextval, 'Walls plastering', 'low', 'm2', '10', 'plasterer');
INSERT INTO events VALUES (events_seq.nextval, 'Roofing', 'high', 'm2', '150', 'roofer');
INSERT INTO events VALUES (events_seq.nextval, 'Blockhouse assembly', 'medium', 'm3', '80', 'stonemason');
INSERT INTO events VALUES (events_seq.nextval, 'Concrete plastering', 'low', 'm2', '50', 'plasterer');
INSERT INTO events VALUES (events_seq.nextval, 'Wood blockhouse working', 'medium', 'm3', '100', 'painter');

--orders
INSERT INTO orders VALUES (orders_seq.nextval, 1, 'Smolensaya 15, f43', '+375291234567', 10, '12.08.2017', '14.08.2017', '14.08.2017', 30, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 1, 'Solomennaya 115, f3', '+375291234577', 50, '13.08.2017', '17.08.2017', '16.08.2017', 150, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 2, 'Cerkovnaya 35, f44', '+375291236567', 10, '14.08.2017', '18.08.2017', '17.08.2017', 1000, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 2, 'Komsomolskaya 15, f43', '+375291334567', 25, '15.08.2017', '20.08.2017', '20.08.2017', 2500, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 3, 'Smolenskaya 15, f43', '+375335234567', 10, '16.08.2017', '22.08.2017', '21.08.2017', 100, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 3, 'Smolena 15, f23', '+375292234567', 15, '12.08.2017', '23.08.2017', '17.08.2017', 150, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 4, 'Polensaya 15, h43', '+375291234999', 150, '12.08.2017', '22.08.2017', '22.08.2017', 2250, 'done');
INSERT INTO orders VALUES (orders_seq.nextval, 4, 'Krilova 15, h41', '+375292224567', 100, '27.09.2017', '16.09.2017', null, 1500, 'is performed');

--order_employee
INSERT INTO o_e VALUES (1, 1);
INSERT INTO o_e VALUES (1, 2);
INSERT INTO o_e VALUES (2, 5);
INSERT INTO o_e VALUES (4, 7);