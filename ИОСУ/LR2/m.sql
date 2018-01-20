-- 1) Условный запрос: вывести список сотрудников с должностью painter

SELECT full_name, position FROM employees WHERE position = 'painter';

--===================================================================

--2) Итоговый запрос: суммарный доход по всем нарядам за каждое мероприятие

SELECT o.event_id, SUM(e.price * o.work_amount) sum FROM events e INNER JOIN orders o ON e.id = o.event_id GROUP BY o.event_id;

--==========================================

--3) Параметрический запрос: вывести все заказы, параметр - дата

SELECT * FROM orders WHERE app_date = '&date';

--==========================================

--4) Запрос на объединение: fio - id наряда union мероприятие - кол-во заказов по кажд меропр

SELECT e.full_name, o.id FROM employees e INNER JOIN order_employee oe ON e.id = oe.empl_id INNER JOIN orders o ON o.id = oe.order_id
UNION ALL
SELECT e.name, COUNT(o.id) FROM events e INNER JOIN orders o ON e.id = o.event_id GROUP BY e.name;

--========================================

--5)  Запрос с использованием условия по полю с типом дата: вывести список заказов, у которых дата заказа после 15.08.2017
--    и которые уже выполнены, т.е. (дата выполнения is not null)

select count(id), app_date from orders group by app_date;
--=================================================================================

--6) Запрос с внутренним соединением таблиц: вывести список из id заказа и названия мероприятия

SELECT o.id, e.name FROM orders o INNER JOIN events e ON o.event_id = e.id;

--==========================================================================

--7) Запрос с внешним соединением таблиц: посмотреть сколько сотрудников имеется по каждой профессии

SELECT p.name, COUNT(e.id) FROM positions p LEFT OUTER JOIN employees e ON e.position = p.name GROUP BY p.name;

--==============================================================================================================

--8) Запрос с использованием предиката IN с подзапросом: вывести список сотрудников которые выполняли заказ с id = 1

SELECT full_name FROM employees WHERE id IN (SELECT empl_id FROM order_employee WHERE order_id = 1);

--===================================================================================================

--9) Запрос использованием предиката ANY/ALL с подзапросом: вывести заказ с максимальной стоимостью

-- MAX cost of order
SELECT e.price * o.work_amount FROM events e INNER JOIN orders o ON e.id = o.event_id WHERE e.price * o.work_amount > ALL 
(SELECT e1.price * o1.work_amount FROM events e1 INNER JOIN orders o1 ON e1.id = o1.event_id WHERE e1.price * o1.work_amount > e.price * o.work_amount);

--==================================================================================

--10) Запрос с использованием предиката EXISTS/NOT EXISTS с подзапросом: вывести список сотрудников у которых не было заказов

SELECT e.id, e.full_name FROM employees e WHERE not exists (SELECT * FROM order_employee o WHERE o.empl_id = e.id);