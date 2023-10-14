
CREATE TABLE Users( -- опис користувача
	userno INT, -- номер користувача
	full_name VARCHAR(100), -- ПІБ користувача
	date_of_birth DATE, -- Дата народження користувача
	gender VARCHAR(50) -- Стать користувача
);

CREATE TABLE OfficeEmployee( -- опис офісного співробітника
	officeemployeeno INT, -- номер офісного співробітника
	full_name VARCHAR(100), -- ПІБ офісного співробітника
	date_of_birth DATE, -- Дата народження офісного співробітника
	gender VARCHAR(50), -- Стать офісного співробітника
	salary DECIMAL, -- Заробітна плата офісного співробітника
	position VARCHAR(100) -- Посада офісного співробітника
);

CREATE TABLE TechnicalEmployee( -- опис технічного співробітника
	technicalemployeeno INT, -- номер технічного співробітника
	full_name VARCHAR(100), -- ПІБ технічного співробітника
	date_of_birth DATE, -- Дата народження технічного співробітника
	gender VARCHAR(50), -- Стать технічного співробітника
	salary DECIMAL, -- Заробітна плата технічного співробітника
	position VARCHAR(100) -- Посада технічного співробітника
);

CREATE TABLE InformationRequest( -- опис запиту на інформацію
	informationrequestno INT, -- номер запиту
	request_title VARCHAR(500), -- заголовок запиту
	description VARCHAR(2000), -- детальний опис запиту
	format VARCHAR(50), -- формат отримання результату
	date DATE, -- дата відправки запиту
	userno INT -- номер користувач, який надіслав запит
);

CREATE TABLE InformationAnswer( -- опис відповіді на запит інформації
	informationanswerno INT, -- номер відповіді
	answer_title VARCHAR(500), -- заголовок відповіді
	answer(information) VARCHAR(10000), -- відповідь у вигляді інформації
	file VARCHAR(200), -- посилання на місце зберігання файлу з відповіддю 
	date DATE, -- дата надсилання відповіді
	informationrequestno INT, -- номер запиту, на який надсилається відповідь
	officeemployeeno INT -- номер офісного співробітника, який сформував відповідь
);

CREATE TABLE Humidity( -- опис поточного відсотка вологості середовища
	humidityno INT, -- номер показника вологості
	date DATE, -- дата проведення вимірювань
	time TIME, -- час проведення вимірювань
	humidity_percent DECIMAL, -- відсоток вологості середовища
	location VARCHAR(100) -- місце проведення вимірювань
);

CREATE TABLE HumidityChange( -- опис зміни вологості середовища
	humiditychangeno INT,  -- номер зміни вологості середовища
	new_humidity_percent DECIMAL,  -- значення вологості, яке встановлюється
	location VARCHAR(100),  -- місце, де змінюється значення вологості
	technicalemployeeno INT,  -- номер технічного співробітника, який внес зміни
	humidityno INT  -- номер попереднього значення вологості в цьому приміщенні
);


/* Команди обмеження цілісності даних */

/* Первинні ключі */
-- Встановлення обмеження первинного ключа користувача
ALTER TABLE Users ADD CONSTRAINT user_pk
    PRIMARY KEY (userno);
	
-- Встановлення обмеження первинного ключа офісного співробітника
ALTER TABLE OfficeEmployee ADD CONSTRAINT officeemployee_pk
    PRIMARY KEY (officeemployeeno);
	
-- Встановлення обмеження первинного ключа технічного співробітника
ALTER TABLE TechnicalEmployee ADD CONSTRAINT technicalemployee_pk
    PRIMARY KEY (technicalemployeeno);
	
-- Встановлення обмеження первинного ключа запиту на інформацію
ALTER TABLE InformationRequest ADD CONSTRAINT informationrequest_pk
    PRIMARY KEY (informationrequestno);
	
-- Встановлення обмеження первинного ключа відповіді на запит
ALTER TABLE InformationAnswer ADD CONSTRAINT informationanswer_pk
    PRIMARY KEY (informationanswerno);
	
-- Встановлення обмеження первинного ключа показника поточної вологості
ALTER TABLE Humidity ADD CONSTRAINT humidity_pk
    PRIMARY KEY (humidityno);
	
-- Встановлення обмеження первинного ключа зміни вологості
ALTER TABLE HumidityChange ADD CONSTRAINT humiditychange_pk
    PRIMARY KEY (humiditychangeno);
	
	
/* Зовнішні ключі */

-- Встановлення обмеження зовнішнього ключа на користувача для таблиці Запит на інформацію
ALTER TABLE InformationRequest ADD CONSTRAINT request_user_fk
    FOREIGN KEY (userno) REFERENCES Users(userno);

-- Встановлення обмеження зовнішнього ключа на запит для таблиці Відповідь на запит
ALTER TABLE InformationAnswer ADD CONSTRAINT answer_request_fk
    FOREIGN KEY (informationrequestno) REFERENCES InformationRequest(informationrequestno);
	
-- Встановлення обмеження зовнішнього ключа на офісного співробітника для таблці Відповідь на запит
ALTER TABLE InformationAnswer ADD CONSTRAINT answer_employee_fk
    FOREIGN KEY (officeemployeeno) REFERENCES OfficeEmployee(officeemployeeno);

-- Встановлення обмеження зовнішнього ключа на технічного співробітника для таблиці Зміна вологості
ALTER TABLE HumidityChange ADD CONSTRAINT humidity_employee_fk
    FOREIGN KEY (technicalemployeeno) REFERENCES TechnicalEmployee(technicalemployeeno);
	
-- Встановлення обмеження зовнішнього ключа на попереднє значення вологості для таблиці Зміна вологості
ALTER TABLE HumidityChange ADD CONSTRAINT previous_humidity_fk
    FOREIGN KEY (humidityno) REFERENCES Humidity(humidityno);


/* Команди обмеження змісту атрибутів таблиць */

-- Встановлення обмеження вмісту стовпчика зарплатня таблиці Офісні співробітники, більше нуля
ALTER TABLE OfficeEmployee ADD CONSTRAINT office_salary_positive
    CHECK ( salary > 0 );
	
-- Встановлення обмеження вмісту стовпчика зарплатня таблиці Технічні співробітники, більше нуля
ALTER TABLE TechnicalEmployee ADD CONSTRAINT technical_salary_positive
    CHECK ( salary > 0 );
	
-- Встановлення обмеження вмісту стовпчика Формат файлу таблиці Запит на інформацію.
-- Формат має починатися з крапки та мати після неї від 3 до 10 символів, 
-- після цього через пробіл можна вказати ще додатково декілька слів, проте загальна довжина конструкції має бути не більше 50 символів
ALTER TABLE InformationRequest ADD CONSTRAINT request_format_positive
    CHECK ( format SIMILAR TO '^(?=.{1,50}$)\.[a-zA-Z0-9]{3,10}(?: [a-zA-Z ]+)?$');

-- Встановлення обмеження вмісту стовпчика Файл таблиці Відповідь на запит, який містить посилання на файл з інформацією.
-- Посилання має сталу частину https://drive.google.com/drive, після якого через / вказується подальший шлях до файлу.
-- Загальна довжина посилання не має перевищувати 200 символів
ALTER TABLE InformationAnswer ADD CONSTRAINT file_link_format
    CHECK ( file SIMILAR TO '^(?=.{1,200}$)https:\/\/drive\.google\.com\/drive\/(?:[^\/]+\/)[^\/]+(?:\/[^\/]+)*$');

-- Встановлення обмеження вмісту стовпчика Показник вологості таблиці Вологість
ALTER TABLE Humidity ADD CONSTRAINT humidity_range
    CHECK ( humidity_percent BETWEEN 0 AND 100);
	
-- Встановлення обмеження вмісту стовпчика Нове значення вологості таблиці Зміна вологості
ALTER TABLE HumidityChange ADD CONSTRAINT new_humidity_range
    CHECK ( new_humidity_percent BETWEEN 0 AND 100);

