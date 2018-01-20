
--Branch
INSERT INTO Branch VALUES (1, 'Komsomolskaya 1', 'Minsk', '+375291111111');
INSERT INTO Branch VALUES (2, 'Kosmonavtov 2', 'Minsk', '+375292222222');
INSERT INTO Branch VALUES (3, 'Lenina 3', 'Mogilev', '+375293333333');
INSERT INTO Branch VALUES (4, 'Stroitelei 4', 'Mogilev', '+375294444444');
INSERT INTO Branch VALUES (5, 'Ivanova 5', 'Grodno', '+375295555555');
INSERT INTO Branch VALUES (6, 'Lesnaya 6', 'Grodno', '+375296666666');
INSERT INTO Branch VALUES (7, 'Sovetskaya 7', 'Vitebsk', '+375297777777');
INSERT INTO Branch VALUES (8, 'Mashinostroitelei 8', 'Vitebsk', '+375298888888');
INSERT INTO Branch VALUES (9, 'Petrovskaya 9', 'Brest', '+375299999999');
INSERT INTO Branch VALUES (10, 'Mogilevskay 10', 'Brest', '+375291000000');
INSERT INTO Branch VALUES (11, 'Stalina 11', 'Gomel', '+375292000000');
INSERT INTO Branch VALUES (12, 'Shcolnaya 12', 'Gomel', '+375293000000');

--staff
INSERT INTO Staff VALUES (staff_seq.nextval, 'Petr', 'Ivanov', 'Baker Street 100, f15', '+375449584556', 'Director', 'male', '28.09.1985', '5000', 1);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Ivan', 'Petrov', 'Fire Street 134, f16', '+375445876544', 'Manager', 'male', '28.09.1986', '2500', 1);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Semen', 'Semenov', 'Sovetskaya 100, f15', '+375449484456', 'Realtor', 'male', '28.09.1975', '1000', 1);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Andrei', 'Sergeev', 'Sovetov 101, f4', '+375449484333', 'Accountant', 'male', '28.09.1995', '1500', 1);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Serofim', 'Periev', 'Solnchnaya 1, f1', '+375447774456', 'Realtor', 'male', '28.09.1975', '1000', 1);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Anatolii', 'Ovechkin', 'Slovyanskay 10, f15', '+375339480456', 'Realtor', 'male', '28.09.1975', '1000', 2);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Stepan', 'Semenov', 'Sovetskaya 100, f15', '+375449480000', 'Realtor', 'male', '28.09.1975', '1000', 2);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Semen', 'Semenov', 'Sovetskaya 100, f15', '+375443334496', 'Realtor', 'male', '28.09.1975', '1000', 1);
INSERT INTO Staff VALUES (staff_seq.nextval, 'Svetlana', 'Savelieva', 'Sibirskay 100, f15', '+375443334396', 'Manager', 'female', '28.09.1989', '1500', 2);

--owner
insert into Owner select sno,fname,lname,address,tel_no from staff;

--Property_for_rent
INSERT INTO objects VALUES (1, 'Sovietskaya 9', 'Mogilev', 'f', 2, 15, 10, 15, 1);
INSERT INTO objects VALUES (2, 'Volnaya 1', 'Mogilev', 'h', 3, 25, 15, 20, 1);
INSERT INTO objects VALUES (3, 'Sovietskaya 11', 'Mogilev', 'h', 5, 55, 20, 25, 1);
INSERT INTO objects VALUES (4, 'Sovietskaya 12', 'Mogilev', 'h', 4, 35, 25, 30, 1);
INSERT INTO objects VALUES (5, 'Sovietskaya 35', 'Minsk', 'f', 2, 15, 10, 40, 2);
INSERT INTO objects VALUES (6, 'Slonovaya 9', 'Vitebsk', 'f', 2, 15, 10, 15, 2);
INSERT INTO objects VALUES (7, 'Frolova 9', 'Brest', 'f', 2, 15, 10, 15, 2);

--Renter
INSERT INTO Renter VALUES (1, 'Vasilii', 'Terkin', 'Minsk, Smolensaya 15, f43', '+375299111123', 'f', '30', 11);
INSERT INTO Renter VALUES (2, 'Petr', 'Terkin', 'Minsk, Smolensaya 15, f43', '+375299111122', 'f', '35', 10);
INSERT INTO Renter VALUES (3, 'Vasilisa', 'Terkina', 'Mogilev, Smolina 10, f11', '+375299441003', 'h', '55', 1);
INSERT INTO Renter VALUES (4, 'Iliya', 'Barinov', 'Brest, Elovaya 153, f10', '+375449211777', 'f', '10', 3);
INSERT INTO Renter VALUES (5, 'Stepan', 'Volnyii', 'Gomel, Smolensaya 15, f43', '+375299555523', 'f', '30', 6);
INSERT INTO Renter VALUES (6, 'Svetlana', 'Olgina', 'Vitebsk, Podpolnaya 15, f143', '+375299110000', 'f', '14', 7);
INSERT INTO Renter VALUES (7, 'Uliana', 'Baranova', 'Minsk, Velikaya 15, f43', '+375339161123', 'h', '15', 9);

--Viewing
INSERT INTO Viewing VALUES (1, 1, '12.09.2017', 'Ok');
INSERT INTO Viewing VALUES (2, 2, '11.08.2017', 'Bad!!!');
INSERT INTO Viewing VALUES (3, 3, '12.09.2017', 'Normal');
INSERT INTO Viewing VALUES (4, 4, '12.09.2016', 'Not so good');
INSERT INTO Viewing VALUES (5, 5, '12.09.2015', 'I disagree with cost');
INSERT INTO Viewing VALUES (6, 6, '17.09.2017', 'Ok');
INSERT INTO Viewing VALUES (7, 7, '01.09.2017', 'Ok');

commit;