CREATE TABLE  blog (
  blog_id INTEGER IDENTITY PRIMARY KEY,
  blog_name varchar(45) NOT NULL,
  created_on date NOT NULL
);

INSERT INTO blog(blog_name, created_on)
    VALUES('test0@blog.com', CURRENT_DATE);
INSERT INTO blog(blog_name, created_on)
    VALUES('test1@blog.com', CURRENT_DATE);
INSERT INTO blog(blog_name, created_on)
    VALUES('test2@blog.com', CURRENT_DATE);
INSERT INTO blog(blog_id, blog_name, created_on)
    VALUES('4', 'test4@blog.com', CURRENT_DATE);