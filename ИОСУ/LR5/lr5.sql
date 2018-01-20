/*
1.  Написать DML триггер, регистрирующий изменение данных 
(вставку, обновление, удаление) в одной из таблиц БД.
 Во вспомогательную таблицу LOG1 записывать кто, когда (дата и время) и 
 какое именно изменение произвел, для одного из столбцов сохранять старые и 
 новые значения.
*/

CREATE TABLE LOG1 (
 	username VARCHAR2(20),
 	oper_date TIMESTAMP,
 	oper_name CHAR(1),
 	p_k INTEGER,
 	mobile_old VARCHAR2(13),
    mobile_new VARCHAR2(13)
);


--процедура, сохраняющая данные
CREATE OR REPLACE PROCEDURE employees_setaudit (
                                                username IN VARCHAR2,
                                                oper_name IN CHAR,
                                                p_k IN INTEGER,
                                                mobile_old IN VARCHAR2,
                                                mobile_new IN VARCHAR2
                                               )
IS
BEGIN
    IF mobile_old <> mobile_new OR oper_name in ('I','D')
    THEN
        INSERT INTO LOG1 VALUES (username, sysdate, oper_name, p_k, mobile_old, mobile_new);
        commit;
    END IF;
END;
/

--trigger
CREATE OR REPLACE TRIGGER employees_audit
    AFTER INSERT OR UPDATE OR DELETE
    ON pf_department.employees
    FOR EACH ROW
DECLARE
    operation CHAR(1);
BEGIN
    CASE
        WHEN INSERTING
        THEN
            operation := 'I';
            employees_setaudit(USER, operation, :NEW.id, null, :NEW.mobile);
        WHEN UPDATING('mobile')
        THEN
            operation := 'U';
            employees_setaudit (USER, operation, :NEW.id, :OLD.mobile, :NEW.mobile);
        WHEN DELETING
        THEN
            operation := 'D';
            employees_setaudit (USER, operation, :OLD.id, :OLD.mobile, null);
        ELSE null;
    END CASE;
END employees_audit;
/


/*
2.  Написать DDL триггер, протоколирующий действия 
пользователей по созданию, изменению и удалению таблиц 
в схеме во вспомогательную таблицу LOG2 в определенное время и 
запрещающий эти действия в другое время.
*/

CREATE TABLE LOG2 (
    username VARCHAR2(20),
    operation_date DATE,
    operation_name CHAR(1),
    object_name VARCHAR2(30)
);

grant insert on pf_department.LOG2 to system;

  
CREATE OR REPLACE TRIGGER ddl_trigger
BEFORE DROP OR ALTER OR CREATE ON DATABASE
DECLARE
    operation CHAR (1);
    object_name VARCHAR(30); 
BEGIN
    IF (DICTIONARY_OBJ_OWNER = 'PF_DEPARTMENT') THEN
      IF to_char(sysdate,'HH24:MI:SS') between '08:00:00' and '18:00:00' THEN
         CASE
             WHEN SYSEVENT = 'CREATE' THEN
                 operation := 'C';
                 object_name := DICTIONARY_OBJ_NAME;
                 DBMS_OUTPUT.put_line('CREATE');
                 INSERT INTO pf_department.LOG2 VALUES (USER, SYSDATE, operation, object_name);
             WHEN SYSEVENT = 'ALTER'  THEN
                 operation := 'A';
                 object_name := DICTIONARY_OBJ_NAME;
                 DBMS_OUTPUT.put_line('ALTER');
                 INSERT INTO pf_department.LOG2 VALUES (USER, SYSDATE, operation, object_name);
             WHEN SYSEVENT = 'DROP'  THEN
                 operation := 'D';
                 object_name := DICTIONARY_OBJ_NAME;
                 DBMS_OUTPUT.put_line('DROP');
                 INSERT INTO pf_department.LOG2 VALUES (USER, SYSDATE, operation, object_name);
             ELSE
                 null;
         END CASE;
      ELSE
         RAISE_APPLICATION_ERROR (
             num => -20000,
             msg => 'Cannot DROP, ALTER, CREATE objects on these time');
      END if;
    END if;
END;
/



/*
3.  Написать системный триггер добавляющий запись во вспомогательную таблицу LOG3,
 когда пользователь подключается или отключается. В таблицу логов записывается имя 
 пользователя (USER), тип активности (LOGON или LOGOFF), дата (SYSDATE), количество
  записей в основной таблице БД.
 */

CREATE TABLE LOG3 (
    username VARCHAR2(20),
    action CHAR(6),
    action_date TIMESTAMP,
    record_quantity INTEGER
);

grant insert on pf_department.LOG3 to system;
grant delete on pf_department.LOG3 to system;


CREATE OR REPLACE TRIGGER user_log_on
    AFTER LOGON ON DATABASE 
DECLARE 
    quantity INTEGER;
BEGIN
    SELECT COUNT(*) INTO quantity FROM pf_department.orders;
    INSERT INTO pf_department.LOG3 VALUES (USER,'LOGON', SYSDATE, quantity);
    DELETE FROM pf_department.LOG3 WHERE username = 'SYS';
END user_log_on;
/

CREATE OR REPLACE TRIGGER user_log_off
    BEFORE LOGOFF ON DATABASE 
DECLARE 
    quantity INTEGER;
BEGIN
    SELECT COUNT(*) INTO quantity FROM pf_department.orders;
    INSERT INTO pf_department.LOG3 VALUES (USER,'LOGOFF', SYSDATE, quantity);
    DELETE FROM pf_department.LOG3 WHERE username = 'SYS';
END user_log_off;
/


/*
4.Написать триггеры, реализующие бизнес-логику (ограничения) в заданной предметной области. 
  Варианты заданий приведены в Приложении 8. Тип триггера: строковый или операторный, 
  выполнятся AFTER или BEFORE определить самостоятельно, исходя из сути задания, третий пункт 
  задания предполагает использование триггера с предложением WHEN.

  1) При формировании наряда проверять занятость работников и проведение других мероприятий по одному адресу в одно время.
  2) Контролировать количество работников по должностям и их общее количество: не более 4 работников на должность и не более 20 сотрудников в штате.
  3) Рассчитывать заработную плату работников по итогам месяца.
*/

-- 1) При формировании наряда проверять занятость работников и проведение других мероприятий по одному адресу в одно время.
CREATE OR REPLACE TRIGGER order_employee_audut
    BEFORE INSERT
    ON pf_department.order_employee
    FOR EACH ROW
DECLARE
    is_free VARCHAR2(3);
    pragma autonomous_transaction;
BEGIN
    SELECT is_free INTO is_free FROM employees WHERE id = :NEW.empl_id;
    IF is_free = 'no' THEN
        DELETE FROM orders WHERE id = :NEW.order_id;
        commit;
        RAISE_APPLICATION_ERROR (
            num => -20001,
            msg => 'Cannot insert employee №' || :NEW.empl_id || ', he is busy.'
        );
    END IF;
END order_employee_audit;
/


CREATE OR REPLACE TRIGGER orders_audut
BEFORE INSERT
    ON pf_department.orders
    FOR EACH ROW
DECLARE
    CURSOR c(new_address varchar2, new_date date) IS 
        SELECT id FROM orders WHERE address = new_address AND to_char(pref_execution_date, 'dd:mm:yyyy') >= to_char(new_date, 'dd:mm:yyyy');

    str c%ROWTYPE;    
BEGIN
    OPEN c(:NEW.address, :NEW.pref_execution_date);
    FETCH c INTO str;
    IF c%FOUND THEN
        RAISE_APPLICATION_ERROR (
            num => -20002,
            msg => 'Cannot insert order, such address was booked at that time.'
        );
    END IF;
END orders_audit;
/


--2) Контролировать количество работников по должностям и их общее количество: не более 4 работников на должность и не более 14 сотрудников в штате.
CREATE OR REPLACE TRIGGER add_empl_audit
BEFORE INSERT
    ON pf_department.employees
    FOR EACH ROW
DECLARE
    total_limit number := 14;
    position_limit number := 4;
    total_quantity number;
    quantity_by_position number;
BEGIN
    SELECT COUNT(*) INTO total_quantity FROM employees;
    IF total_quantity = total_limit THEN
        RAISE_APPLICATION_ERROR (
            num => -20003,
            msg => 'Cannot insert employee, limit of imployees is ' || total_limit
        );
    END IF;

    SELECT COUNT(*) INTO quantity_by_position FROM employees WHERE position = :NEW.position;
    IF quantity_by_position = position_limit THEN
        RAISE_APPLICATION_ERROR (
            num => -20004,
            msg => 'Cannot insert employee on position ' || :NEW.position || ', limit of imployees on that position is ' || position_limit
        );
    END IF;
END add_empl_audit;
/

--3) Рассчитывать заработную плату работников, в зависимости от кол-ва и объема заказов.

--вспомогательная таблица
CREATE TABLE salary (
    empll_id number,
    salary number(8,4)
);


CREATE OR REPLACE TRIGGER empl_salary_audit
BEFORE INSERT
    ON pf_department.order_employee
    FOR EACH ROW
DECLARE
    empl_count number;
    first_empl number;
BEGIN
    SELECT COUNT(*) INTO empl_count FROM order_employee WHERE order_id = :NEW.order_id;

    CASE
        WHEN empl_count = 2 THEN
            RAISE_APPLICATION_ERROR (
                num => -20005,
                msg => 'Cannot send more than 2 employees on the one event'
            );

        WHEN empl_count = 0 THEN
            UPDATE salary SET salary = salary + 0.7 * (SELECT cost FROM orders WHERE id = :NEW.order_id) WHERE empll_id = :NEW.empl_id;

        WHEN empl_count = 1 THEN
            UPDATE salary SET salary = salary + 0.35 * (SELECT cost FROM orders WHERE id = :NEW.order_id) WHERE empll_id = :NEW.empl_id;
            SELECT empl_id INTO first_empl FROM order_employee where order_id = :NEW.order_id and empl_id != :NEW.empl_id;
            UPDATE salary SET salary = salary - 0.35 * (SELECT cost FROM orders WHERE id = :NEW.order_id) WHERE empll_id = first_empl;

        ELSE null;
    END CASE;

END empl_salary_audit;
/


/*
5.*Самостоятельно или при консультации преподавателя составить задание на триггер,
который будет вызывать мутацию таблиц, и решить эту проблему двумя способами: 
1) при помощи переменных пакета и двух триггеров; 
2) при помощи COMPAUND триггера.
*/

--after insert and before/after update - mutating
--контроль повышения расценки на мероприятия,
--нельзя повышать более, чем на 20% от средней стоимости.

--1) при помощи переменных пакета и двух триггеров;
CREATE OR REPLACE PACKAGE price_storage IS

    avg_price NUMBER;

    FUNCTION get_price
        RETURN NUMBER;

    PROCEDURE set_price(price NUMBER);

END price_storage;
/

CREATE OR REPLACE PACKAGE BODY price_storage IS

    FUNCTION get_price
        RETURN NUMBER
    IS
    BEGIN
        RETURN avg_price;
    END get_price;


    PROCEDURE set_price(price NUMBER) 
    IS  
    BEGIN
        avg_price := price;
    END set_price;

END price_storage;
/


CREATE OR REPLACE TRIGGER save_avg_price
BEFORE UPDATE
    ON pf_department.events
DECLARE
    avg_price number;
BEGIN
    SELECT AVG(price) INTO avg_price FROM events;
    price_storage.set_price(avg_price);
END save_avg_price;
/


CREATE OR REPLACE TRIGGER check_price
BEFORE UPDATE
    ON pf_department.events
    FOR EACH ROW
DECLARE
    avg_price number;
BEGIN
    avg_price := price_storage.get_price;
    
    IF :NEW.price > :OLD.price + 0.2 * avg_price THEN
        RAISE_APPLICATION_ERROR (
            num => -20006,
            msg => 'Cannot increase an event price more than 20% from average price'
        );
    END IF;
END check_price;
/


--2) при помощи COMPAUND триггера.
CREATE OR REPLACE TRIGGER check_price_compound
FOR UPDATE ON pf_department.events
COMPOUND TRIGGER
    avg_price number;
BEFORE STATEMENT IS
BEGIN
    SELECT AVG(price) INTO avg_price FROM events;
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
    IF :NEW.price > :OLD.price + 0.2 * avg_price THEN
        RAISE_APPLICATION_ERROR (
            num => -20006,
            msg => 'Cannot increase an event price more than 20% from average price'
        );
    END IF;
END BEFORE EACH ROW;
END;
/

ALTER TRIGGER save_avg_price DISABLE;
ALTER TRIGGER check_price DISABLE;
ALTER TRIGGER check_price_compound DISABLE;

ALTER TRIGGER save_avg_price ENABLE;
ALTER TRIGGER check_price ENABLE;
ALTER TRIGGER check_price_compound ENABLE;


--6.*Написать триггер INSTEAD OF для работы с необновляемым представлением.

--необновляемое представление
CREATE OR REPLACE VIEW test_view AS 
( 
    SELECT DISTINCT o.id, e.name, o.address, o.client_mobile, o.work_amount, o.cost, o.status 
    FROM orders o INNER JOIN events e ON o.event_id = e.id
);

CREATE OR REPLACE TRIGGER update_test_view
INSTEAD OF UPDATE ON test_view
FOR EACH ROW
BEGIN
UPDATE orders SET
    address = :NEW.address,
    client_mobile = :NEW.client_mobile,
    work_amount = :NEW.work_amount,
    cost = :NEW.cost,
    status = :NEW.status
WHERE id = :OLD.id;
END;
/


--ALTER TRIGGER  DISABLE;