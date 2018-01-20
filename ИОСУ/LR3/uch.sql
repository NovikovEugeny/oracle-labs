--с информацией об офисах в Бресте
CREATE OR REPLACE VIEW brest_offices AS (SELECT bno, street, tel_no FROM branch WHERE city = 'Brest');

--с информацией об объектах недвижимости минимальной стоимости
CREATE OR REPLACE VIEW min_cost AS (SELECT * FROM objects WHERE rent IN (SELECT MIN(rent) FROM objects));

--с информацией о количестве сделанных осмотров с комментариями
CREATE OR REPLACE VIEW with_comments AS (SELECT COUNT(*) as "count" FROM viewing WHERE comment_o IS NOT NULL);

--со сведениями об арендаторах, желающих арендовать 3-х комнатные квартиры в тех же городах, где они проживают
CREATE OR REPLACE VIEW renters AS (SELECT * FROM renter WHERE substr(address, 1, instr(address, ',') - 1) 
	IN ( SELECT city FROM objects WHERE rooms = 3 and type = 'f' GROUP BY city) AND pref_type = 'f'
);

--со сведениями об отделении с максимальным количеством работающих сотрудников
CREATE OR REPLACE VIEW max_staff_branch AS (
	select * from branch where bno = (
		select bno from staff group by bno having count(*) >= all(
			select count(*) from staff group by bno))
);

--с информацией о сотрудниках и объектах, которые они предлагают в аренду в текущем квартале
CREATE OR REPLACE VIEW o_s_q AS (
	SELECT DISTINCT s.fname, s.lname, s.tel_no, o.street, o.city, o.type, o.rooms, o.rent 
    FROM objects o, staff s, viewing v 
    WHERE o.sno = s.sno AND o.pno = v.pno AND to_char(v.date_o, 'q') = to_char(sysdate, 'q')
);

--с информацией о владельцах, чьи дома или квартиры осматривались потенциальными арендаторами более двух раз
CREATE OR REPLACE VIEW owner_more_2_viewing AS (
	SELECT o.fname, o.lname, o.tel_no 
	FROM owner o INNER JOIN objects ON o.ono = objects.ono INNER JOIN viewing v ON objects.pno = v.pno 
	GROUP BY o.fname, o.lname, o.tel_no HAVING COUNT(v.pno) > 2
);