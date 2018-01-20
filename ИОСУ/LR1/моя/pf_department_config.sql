--create user
create user pf_department IDENTIFIED BY department;
GRANT CREATE SESSION TO pf_department;
alter user pf_department quota 300m on system;
grant create synonym to pf_department;

--change obj
GRANT ALTER ANY TABLE TO pf_department;
GRANT ALTER ANY PROCEDURE TO pf_department;
GRANT ALTER ANY TRIGGER TO pf_department;
GRANT ALTER PROFILE TO pf_department;

--create obj
GRANT CREATE TABLE TO pf_department;
GRANT CREATE PROCEDURE TO pf_department;
GRANT CREATE TRIGGER TO pf_department;
GRANT CREATE VIEW TO pf_department;
GRANT CREATE SEQUENCE TO pf_department;

--drop delete
GRANT DELETE ANY TABLE TO pf_department;  
GRANT DROP ANY TABLE TO pf_department;
GRANT DROP ANY PROCEDURE TO pf_department;
GRANT DROP ANY TRIGGER TO pf_department;
GRANT DROP ANY VIEW TO pf_department;
GRANT DROP PROFILE TO pf_department;