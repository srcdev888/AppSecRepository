CREATE TABLE users (
  user_id INTEGER IDENTITY PRIMARY KEY,
  email_id varchar(45) NOT NULL,
  password varchar(45) NOT NULL,
  first_name varchar(45) NOT NULL,
  last_name varchar(45) NOT NULL
);
INSERT INTO users(user_id, email_id, password, first_name, last_name)
    VALUES('2', 'test@test.com', 'password', 'first', 'last');
    INSERT INTO users(user_id, email_id, password, first_name, last_name)
    VALUES('4', 'test@test.com', 'password', 'first', 'last');
INSERT INTO users(user_id, email_id, password, first_name, last_name)
    VALUES('1000', 'test@test.com', 'password', 'first', 'last');