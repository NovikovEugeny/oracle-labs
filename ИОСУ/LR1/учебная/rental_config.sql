--create user
create user rental_property IDENTIFIED BY rental;
GRANT CREATE SESSION TO rental_property;
alter user rental_property quota 300m on system;
grant create synonym to rental_property;

--change obj
GRANT ALTER ANY TABLE TO rental_property;
GRANT ALTER ANY PROCEDURE TO rental_property;
GRANT ALTER ANY TRIGGER TO rental_property;
GRANT ALTER PROFILE TO rental_property;

--create obj
GRANT CREATE TABLE TO rental_property;
GRANT CREATE PROCEDURE TO rental_property;
GRANT CREATE TRIGGER TO rental_property;
GRANT CREATE VIEW TO rental_property;
GRANT CREATE SEQUENCE TO rental_property;

--drop delete
GRANT DELETE ANY TABLE TO rental_property;  
GRANT DROP ANY TABLE TO rental_property;
GRANT DROP ANY PROCEDURE TO rental_property;
GRANT DROP ANY TRIGGER TO rental_property;
GRANT DROP ANY VIEW TO rental_property;
GRANT DROP PROFILE TO rental_property;