SET SERVEROUTPUT ON;

/*
Создать функцию, возвращающую количество работников, которые получили наименьшее количество нарядов
до указанной в параметре даты. Вывести более подробную информацию об этих работниках.
*/

--function
CREATE OR REPLACE Function empl_quantity(date_arg IN date)
  RETURN number
  IS
  quantity number := 0;

  --cursor
  CURSOR c IS
             SELECT e.id, e.full_name, e.position, e.mobile, COUNT(*) AS quantity 
             FROM orders o, employees e, order_employee oe 
             WHERE o.id = oe.order_id and oe.empl_id = e.id and o.execution_date < date_arg 
             GROUP BY e.id, e.full_name, e.position, e.mobile 
             HAVING COUNT(*) IN ( SELECT MIN(quantity) 
                                  FROM (
                                        SELECT e.id, COUNT(*) AS quantity 
                                        FROM orders o, employees e, order_employee oe 
                                        WHERE o.id = oe.order_id and oe.empl_id = e.id and o.execution_date < date_arg 
                                        GROUP BY e.id
                                       )
                                );
  --cursor var
  str c%ROWTYPE;

BEGIN
    OPEN c;
    FETCH c INTO str;
    WHILE c%FOUND
      LOOP
        DBMS_OUTPUT.put_line (
          str.full_name || ' - ' ||
          str.position || ' - ' ||
          str.mobile || ' - ' ||
          str.quantity
        );
        FETCH c INTO str;
      END LOOP;
      quantity := c%rowcount;
    CLOSE c;
  RETURN quantity;
END;
/

DECLARE
i number;
BEGIN
i := empl_quantity(sysdate);
DBMS_OUTPUT.put_line('quantity: '|| i);
END;
/



/*
Создать процедуру, копирующую строки с информацией о мероприятиях, нарядов на которые 
в указанном месяце не было во вспомогательную таблицу. Вывести количество таких мероприятий.
*/

--вспомогательная таблица
CREATE TABLE additional_table (
  id INTEGER,
  name VARCHAR2(100) NOT NULL,
  danger_class VARCHAR2(6) NOT NULL,
  work_unit VARCHAR2(25) NOT NULL,
  price DECIMAL(6,2) NOT NULL,
  required_position VARCHAR2(25) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT ck_events_danger_class2 CHECK (danger_class IN ('low', 'medium', 'high'))
);


--procedure
CREATE OR REPLACE Procedure copy(month IN varchar2)
  IS
  quantity number := 0;

  EMPTY_EXCEPTION EXCEPTION;

  CURSOR c IS
             SELECT * FROM events WHERE id NOT IN 
              ( SELECT event_id FROM orders 
                WHERE EXTRACT(year FROM app_date) = EXTRACT(year FROM sysdate) AND EXTRACT(month FROM app_date) = month
              );

  str c%ROWTYPE;

BEGIN
  OPEN c;
  FETCH c INTO str;

  IF c%NOTFOUND THEN
    RAISE EMPTY_EXCEPTION;
  END IF;

  DELETE FROM additional_table;
    WHILE c%FOUND
      LOOP
        INSERT INTO additional_table VALUES (str.id, str.name, str.danger_class, str.work_unit, str.price, str.required_position);
        DBMS_OUTPUT.put_line (
          str.id || ' - ' ||
          str.name || ' - ' ||
          str.danger_class || ' - ' ||
          str.work_unit || ' - ' ||
          str.price || ' - ' ||
          str.required_position
        );
        FETCH c INTO str;
      END LOOP;
      commit;
      quantity := c%rowcount;
      DBMS_OUTPUT.put_line ('events quantity: ' || quantity);
  CLOSE c;
  
  EXCEPTION
    WHEN INVALID_NUMBER THEN
      DBMS_OUTPUT.put_line('Invalid argument format');
    WHEN EMPTY_EXCEPTION THEN
      DBMS_OUTPUT.put_line('There are not records');
END;
/



--Объединить все процедуры и функции в пакет.
CREATE OR REPLACE PACKAGE order_package IS

  PROCEDURE copy(month IN varchar2);
     
  FUNCTION empl_quantity(date_arg IN date)
    RETURN NUMBER;

END order_package;
/

CREATE OR REPLACE PACKAGE BODY order_package IS

  Procedure copy(month IN varchar2)
  IS
  quantity number := 0;

  EMPTY_EXCEPTION EXCEPTION;

  CURSOR c IS
             SELECT * FROM events WHERE id NOT IN 
              ( SELECT event_id FROM orders 
                WHERE EXTRACT(year FROM app_date) = EXTRACT(year FROM sysdate) AND EXTRACT(month FROM app_date) = month
              );

  str c%ROWTYPE;

BEGIN
  OPEN c;
  FETCH c INTO str;

  IF c%NOTFOUND THEN
    RAISE EMPTY_EXCEPTION;
  END IF;

  DELETE FROM additional_table;
    WHILE c%FOUND
      LOOP
        INSERT INTO additional_table VALUES (str.id, str.name, str.danger_class, str.work_unit, str.price, str.required_position);
        DBMS_OUTPUT.put_line (
          str.id || ' - ' ||
          str.name || ' - ' ||
          str.danger_class || ' - ' ||
          str.work_unit || ' - ' ||
          str.price || ' - ' ||
          str.required_position
        );
        FETCH c INTO str;
      END LOOP;
      commit;
      quantity := c%rowcount;
      DBMS_OUTPUT.put_line ('events quantity: ' || quantity);
  CLOSE c;
  
  EXCEPTION
    WHEN INVALID_NUMBER THEN
      DBMS_OUTPUT.put_line('Invalid argument format');
    WHEN EMPTY_EXCEPTION THEN
      DBMS_OUTPUT.put_line('There are not records');
END copy;

--/////////////////////////////////////////////////////////////

Function empl_quantity(date_arg IN date)
  RETURN number
  IS
  quantity number := 0;

  --cursor
  CURSOR c IS
             SELECT e.id, e.full_name, e.position, e.mobile, COUNT(*) AS quantity 
             FROM orders o, employees e, order_employee oe 
             WHERE o.id = oe.order_id and oe.empl_id = e.id and o.execution_date < date_arg 
             GROUP BY e.id, e.full_name, e.position, e.mobile 
             HAVING COUNT(*) IN ( SELECT MIN(quantity) 
                                  FROM (
                                        SELECT e.id, COUNT(*) AS quantity 
                                        FROM orders o, employees e, order_employee oe 
                                        WHERE o.id = oe.order_id and oe.empl_id = e.id and o.execution_date < date_arg 
                                        GROUP BY e.id
                                       )
                                );
  --cursor var
  str c%ROWTYPE;

BEGIN
    OPEN c;
    FETCH c INTO str;
    WHILE c%FOUND
      LOOP
        DBMS_OUTPUT.put_line (
          str.full_name || ' - ' ||
          str.position || ' - ' ||
          str.mobile || ' - ' ||
          str.quantity
        );
        FETCH c INTO str;
      END LOOP;
      quantity := c%rowcount;
    CLOSE c;
  RETURN quantity;
END empl_quantity;

END order_package;
/



/*
Написать анонимный PL/SQL блок, в котором будут вызовы реализованных функций и процедур пакета с различными 
характерными значениями параметров для проверки правильности работы основных задач и обработки исключительных ситуаций
*/
DECLARE 
n number;

BEGIN
  n := order_package.empl_quantity(sysdate);
  DBMS_OUTPUT.put_line('quantity: '|| n);

  order_package.copy(11);
  order_package.copy('a2');
  order_package.copy(12);
  
END;
/



/*
 Написать локальную программу, которая добавляет новый заказ и вносит рабочего/рабочих в список занятости:
 1)локальная процедура, заполняющая таблицу занятости
 2)локальная функция, вычисляющая стоимость заказа, равную произведению объёма работы на расценку
*/

CREATE OR REPLACE Procedure create_order(
                                         event_id IN events.id%Type,
                                         address IN orders.address%Type,
                                         mobile IN orders.client_mobile%Type,
                                         work_amount IN orders.work_amount%Type,
                                         app_date IN orders.app_date%Type,
                                         pref_date IN orders.PREF_EXECUTION_DATE%Type,
                                         execution_date IN orders.EXECUTION_DATE%Type,
                                         empl_list IN varchar2
                                        )
IS

order_id number;
cost number;

--1)
PROCEDURE order_empl_loop(order_id IN number, empl_list in varchar2)
IS
  CURSOR c IS SELECT to_number(column_value) AS id FROM xmltable(empl_list);
  str c%ROWTYPE;
BEGIN
  OPEN c;
  FETCH c INTO str;
  WHILE c%FOUND
    LOOP
      INSERT INTO order_employee VALUES (order_id, str.id);
      FETCH c INTO str;
    END LOOP;
    commit;
  CLOSE c;
END;

--2)
FUNCTION get_cost (event_id IN number, amount IN number)
RETURN number
IS
  event_price number;
BEGIN
  SELECT price INTO event_price FROM events WHERE id = event_id;
RETURN event_price * amount;
END get_cost;

BEGIN
  order_id := orders_seq.nextval;
  cost := get_cost(event_id,work_amount);
  INSERT INTO orders VALUES (order_id, event_id, address, mobile, work_amount, app_date, pref_date, execution_date, cost, 'in line');
  commit;
  order_empl_loop(order_id, empl_list);
  commit;
END;
/
--call create_order(1, 'address', '+768698680989', 10, sysdate, sysdate, sysdate, '1,2');


--Написать перегруженную программу, для поиска сотрудников по id/fio
DECLARE
  TYPE EMPL_TYPE is RECORD (
    empl_id employees.id%Type ,
    empl_fio employees.full_name%Type ,
    empl_position employees.position%Type ,
    empl_mobile employees.mobile%Type,
    empl_status employees.is_free%Type 
  );

--1)by id
  PROCEDURE find (empl_id IN number)
  IS
    info EMPL_TYPE;
  BEGIN
    SELECT * INTO info FROM employees WHERE id = empl_id;
    DBMS_OUTPUT.put_line(
      info.empl_id || ' - ' || 
      info.empl_fio || ' - ' ||
      info.empl_position || ' - ' ||
      info.empl_mobile || ' - ' ||
      info.empl_status
    );
  END;

--2)by fio
  PROCEDURE find (fio IN varchar2)
  IS
    CURSOR c IS SELECT * FROM employees WHERE full_name = fio;
    str c%ROWTYPE;
  BEGIN
    OPEN c;
    FETCH c INTO str;
    WHILE c%FOUND
      LOOP
        DBMS_OUTPUT.put_line(
          str.id || ' - ' || 
          str.full_name || ' - ' ||
          str.position || ' - ' ||
          str.mobile || ' - ' ||
          str.is_free
        );
        FETCH c INTO str;
      END LOOP;
      commit;
    CLOSE c;
  END;

BEGIN
find(1);
find('Petrov Ivan Ivanovich');
END;
/
