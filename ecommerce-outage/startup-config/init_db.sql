CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100)
);

INSERT INTO users(username)
VALUES ('student1');