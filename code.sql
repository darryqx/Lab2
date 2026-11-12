-- 1. Выбираем все посылки тяжелее 1 кг и сортируем по убыванию суммы марок
SELECT track_number, weight, stamp_amount, sender_id
FROM correspondence
WHERE weight > 1.0
ORDER BY stamp_amount DESC;

-- 2. Выводим ФИО отправителей из Москвы и трек-номера их посылок
SELECT 
    CONCAT(s.last_name, ' ', s.first_name, ' ', s.middle_name) AS "ФИО отправителя",
    s.address AS "Адрес",
    c.track_number AS "Трек-номер",
    c.stamp_amount AS "Сумма марок"
FROM senders s
JOIN correspondence c ON s.sender_id = c.sender_id
WHERE s.address LIKE '%Москва%';

-- Создаем новую таблицу для хранения крупных отправлений (весом более 3 кг)
CREATE TABLE heavy_parcels AS
SELECT track_number, mail_type_id, weight, stamp_amount
FROM correspondence
WHERE weight > 3.0;

-- Проверяем, что новая таблица создалась и в ней есть данные
SELECT * FROM heavy_parcels;

-- 3.1. Добавляем нового отправителя
INSERT INTO senders (last_name, first_name, middle_name, address, passport_data, phone_number)
VALUES ('Смирнов', 'Олег', 'Викторович', 'г. Воронеж, ул. Кирова, д. 10', '2015 889900', '+79995551122');

-- 3.2. Добавляем для него новую посылку (код отправителя подставится автоматически)
INSERT INTO correspondence (track_number, mail_type_id, weight, length, width, height, sender_id, stamp_amount)
VALUES ('RA999888777RU', 2, 1.350, 25, 20, 12, (SELECT MAX(sender_id) FROM senders), 310.0);

-- 3.3. Проверяем, что запись добавилась
SELECT * FROM correspondence WHERE track_number = 'RA999888777RU';

-- 4.1. Увеличиваем сумму марок на 10% для 1-го вида корреспонденции
UPDATE correspondence
SET stamp_amount = ROUND((stamp_amount * 1.1)::numeric, 2)
WHERE mail_type_id = 1;

-- 4.2. Проверяем обновленные суммы марок
SELECT track_number, mail_type_id, stamp_amount 
FROM correspondence 
WHERE mail_type_id = 1;
