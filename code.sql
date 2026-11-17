
-- 1. Вывести информацию обо всех отправителях корреспонденции весом больше 300 граммов.
SELECT DISTINCT s.*
FROM senders s
JOIN correspondence c ON s.sender_id = c.sender_id
WHERE c.weight > 0.3;


-- 2. Вывести трек-номера корреспонденции от отправителей с неизвестным контактным телефоном.
SELECT c.track_number
FROM correspondence c
JOIN senders s ON c.sender_id = s.sender_id
WHERE s.phone_number IS NULL OR s.phone_number = '';


-- 3. Создать таблицу, содержащую данные второго запроса с указанием информации об отправителях и параметров корреспонденции.
SELECT 
    s.sender_id,
    s.last_name,
    s.first_name,
    s.middle_name,
    s.address,
    s.passport_data,
    s.phone_number,
    c.track_number,
    c.mail_type_id,
    c.weight,
    c.length,
    c.width,
    c.height,
    c.stamp_amount
INTO temp_correspondence
FROM correspondence c
JOIN senders s ON c.sender_id = s.sender_id
WHERE s.phone_number IS NULL OR s.phone_number = '';


-- 4. Добавить в созданную таблицу всю корреспонденцию от отправителей, адреса которых содержат две улицы.
INSERT INTO temp_correspondence
SELECT 
    s.sender_id,
    s.last_name,
    s.first_name,
    s.middle_name,
    s.address,
    s.passport_data,
    s.phone_number,
    c.track_number,
    c.mail_type_id,
    c.weight,
    c.length,
    c.width,
    c.height,
    c.stamp_amount
FROM correspondence c
JOIN senders s ON c.sender_id = s.sender_id
WHERE (s.address ~* '(ул\.|улица|пер\.|переулок|пр\.|проспект).*(ул\.|улица|пер\.|переулок|пр\.|проспект)' OR s.address LIKE '%/%')
  AND c.track_number NOT IN (SELECT track_number FROM temp_correspondence);


-- 5. В созданной таблице убрать все пробелы и спецсимволы из трек-номеров отправлений.
UPDATE temp_correspondence
SET track_number = REGEXP_REPLACE(track_number, '[^a-zA-Zа-яА-Я0-9]', '', 'g');


-- 6. Удалить всю корреспонденцию от отправителей с номером телефона, начинающимся и заканчивающимся на одинаковые цифры в части после кода.
DELETE FROM temp_correspondence
WHERE RIGHT(REGEXP_REPLACE(phone_number, '\D', '', 'g'), 7) ~ '^(\d).*\1$';


-- 7. Посчитать средний вес и максимальные по объему параметры корреспонденции для каждого отправителя.
SELECT 
    sender_id AS "Код отправителя",
    ROUND(AVG(weight)::numeric, 3) AS "Средний вес (кг)",
    MAX(length) AS "Макс. длина",
    MAX(width) AS "Макс. ширина",
    MAX(height) AS "Макс. высота",
    MAX(length * width * height) AS "Макс. объем"
FROM correspondence
GROUP BY sender_id
ORDER BY sender_id;
