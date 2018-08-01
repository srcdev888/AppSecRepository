CREATE TABLE village (
id INTEGER IDENTITY PRIMARY KEY,
name varchar(40),
country varchar(40),
district varchar(40)
);

INSERT INTO village(id, name, district, country)
    VALUES('2', 'changi', 'east', 'sg');
INSERT INTO village(id, name, district, country)
    VALUES('4', 'jurong', 'west', 'sg');