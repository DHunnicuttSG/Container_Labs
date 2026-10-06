CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50)
);

INSERT INTO users(username)
VALUES ('student1');