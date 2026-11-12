-- 1. Запросы на выборку и проверка корректности их работы
SELECT track_number, weight, stamp_amount, sender_id
FROM correspondence
WHERE weight > 1.0
ORDER BY stamp_amount DESC;

SELECT 
    CONCAT(s.last_name, ' ', s.first_name, ' ', s.middle_name) AS "ФИО отправителя",
    UPPER(s.address) AS "Адрес",
    c.track_number AS "Трек-номер",
    c.stamp_amount AS "Сумма марок"
FROM senders s
JOIN correspondence c ON s.sender_id = c.sender_id
WHERE s.address LIKE '%Москва%';


-- 2. Запрос на создание таблицы и проверка корректности его работы
CREATE TABLE heavy_parcels AS
SELECT track_number, mail_type_id, weight, stamp_amount
FROM correspondence
WHERE weight > 3.0;


-- 3. Запрос на добавление и проверка корректности его работы
INSERT INTO senders (last_name, first_name, middle_name, address, passport_data, phone_number)
VALUES ('Смирнов', 'Олег', 'Викторович', 'г. Воронеж, ул. Кирова, д. 10', '2015 889900', '+79995551122');

INSERT INTO correspondence (track_number, mail_type_id, weight, length, width, height, sender_id, stamp_amount)
VALUES ('RA999888777RU', 2, 1.350, 25, 20, 12, (SELECT MAX(sender_id) FROM senders), 310.0);


-- 4. Запрос на изменение и проверка корректности его работы
UPDATE correspondence
SET stamp_amount = ROUND((stamp_amount * 1.1)::numeric, 2)
WHERE mail_type_id = 1;


-- 5. Запрос на удаление и проверка корректности его работы
DELETE FROM correspondence
WHERE track_number = 'RA999888777RU';


-- 6. Групповой запрос и проверка корректности возвращаемых им данных
SELECT 
    mail_type_id AS "Код вида",
    COUNT(track_number) AS "Количество отправлений",
    ROUND(SUM(weight)::numeric, 3) AS "Общий вес (кг)",
    ROUND(AVG(stamp_amount)::numeric, 2) AS "Средняя сумма марок",
    MAX(weight) AS "Максимальный вес"
FROM correspondence
GROUP BY mail_type_id
ORDER BY mail_type_id;
