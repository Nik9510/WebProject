CREATE DATABASE WebProjectDB;

CREATE TABLE states(
id SERIAL PRIMARY KEY,
name VARCHAR(50),
abbr VARCHAR(3)
);

CREATE TABLE users(
id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
surname VARCHAR(255) NOT NULL,
nickname VARCHAR(25) NOT NULL,
email VARCHAR(255) NOT NULL,
password VARCHAR(260) NOT NULL,
type INTEGER NOT NULL,
last_log TIMESTAMP
);
ALTER TABLE users ADD CONSTRAINT email_user UNIQUE (email);

CREATE TABLE price_range(
id SERIAL PRIMARY KEY,
min_value DOUBLE PRECISION NOT NULL,
max_value DOUBLE PRECISION NOT NULL
);

CREATE TABLE restaurants(
id SERIAL PRIMARY KEY,
name VARCHAR(25) NOT NULL,
description VARCHAR(32000),
web_site_url VARCHAR(255),
global_value INTEGER,
id_owner INTEGER NOT NULL,
id_creator INTEGER NOT NULL,
id_price_range INTEGER, 
latitude DOUBLE PRECISION, 
longitude DOUBLE PRECISION,
address VARCHAR(255),
FOREIGN KEY (id_creator) REFERENCES users (id),
FOREIGN KEY (id_owner) REFERENCES users (id),
FOREIGN KEY (id_price_range) REFERENCES price_range (id)
);
ALTER TABLE restaurants ADD COLUMN cap VARCHAR(5);
ALTER TABLE restaurants ADD COLUMN city VARCHAR(25);
ALTER TABLE restaurants ADD COLUMN country INTEGER;
ALTER TABLE restaurants ALTER COLUMN name TYPE VARCHAR(50);
ALTER TABLE restaurants ADD COLUMN telephone VARCHAR(10);
ALTER TABLE restaurants ADD COLUMN email VARCHAR(50);
ALTER TABLE restaurants ADD CONSTRAINT states FOREIGN KEY (country) REFERENCES states (id) MATCH FULL;
ALTER TABLE restaurants ADD CONSTRAINT email UNIQUE (email);
ALTER TABLE restaurants ADD COLUMN n_visits INTEGER;

CREATE TABLE opening_hours_range(
id SERIAL PRIMARY KEY,
day_of_the_week INTEGER NOT NULL,
start_hour TIME NOT NULL,
end_hour TIME NOT NULL
);

CREATE TABLE cuisine(
id SERIAL PRIMARY KEY,
name VARCHAR(25) NOT NULL
);

CREATE TABLE opening_hours_range_restaurant(
id_range INTEGER,
id_restaurant INTEGER,
PRIMARY KEY(id_range,id_restaurant),
FOREIGN KEY (id_range) REFERENCES opening_hours_range (id),
FOREIGN KEY (id_restaurant) REFERENCES restaurants (id)
);

CREATE TABLE restaurants_cuisine(
id_cuisine INTEGER,
id_restaurant INTEGER,
PRIMARY KEY(id_cuisine,id_restaurant),
FOREIGN KEY (id_cuisine) REFERENCES cuisine (id),
FOREIGN KEY (id_restaurant) REFERENCES restaurants (id)
);

CREATE TABLE photos(
id SERIAL PRIMARY KEY,
name VARCHAR(25) NOT NULL,
description VARCHAR(32000),
id_restaurant INTEGER NOT NULL,
id_user INTEGER NOT NULL,
data_creation TIMESTAMP NOT NULL,
FOREIGN KEY (id_restaurant) REFERENCES restaurants (id),
FOREIGN KEY (id_user) REFERENCES users (id)
);
ALTER TABLE photos ALTER COLUMN name TYPE VARCHAR(100);
ALTER TABLE photos ADD COLUMN visible boolean DEFAULT true;

CREATE TABLE reviews(
id SERIAL PRIMARY KEY,
global_value INTEGER NOT NULL,
food INTEGER,
service INTEGER,
value_for_money INTEGER,
atmosphere INTEGER,
name VARCHAR(255) NOT NULL,
description VARCHAR(32000),
data_creation TIMESTAMP NOT NULL,
id_restaurant INTEGER NOT NULL,
id_creator INTEGER NOT NULL,
id_photo INTEGER,
FOREIGN KEY (id_restaurant) REFERENCES restaurants (id),
FOREIGN KEY (id_creator) REFERENCES users (id),
FOREIGN KEY (id_photo) REFERENCES photos (id)
);
ALTER TABLE reviews ADD COLUMN view boolean DEFAULT false;
ALTER TABLE reviews ALTER COLUMN name TYPE VARCHAR(100);

CREATE TABLE user_review_likes(
id_user INTEGER,
id_review INTEGER,
like_type INTEGER NOT NULL,
data_creation TIMESTAMP NOT NULL,
FOREIGN KEY (id_user) REFERENCES users (id),
FOREIGN KEY (id_review) REFERENCES reviews (id),
PRIMARY KEY(id_user,id_review)
);

CREATE TABLE replies(
id SERIAL PRIMARY KEY,
description VARCHAR(32000) NOT NULL,
data_creation TIMESTAMP NOT NULL,
id_review INTEGER NOT NULL,
id_owner INTEGER NOT NULL,
date_validation TIMESTAMP,
id_validator INTEGER,
FOREIGN KEY (id_validator) REFERENCES users (id),
FOREIGN KEY (id_owner) REFERENCES users (id),
FOREIGN KEY (id_review) REFERENCES reviews (id)
);
ALTER TABLE replies ADD COLUMN accepted boolean;

CREATE TABLE request_delete_photos (
id_user INTEGER,
id_photo INTEGER,
PRIMARY KEY(id_user,id_photo),
FOREIGN KEY (id_user) REFERENCES users (id),
FOREIGN KEY (id_photo) REFERENCES photos (id)
);
ALTER TABLE request_delete_photos ADD COLUMN accepted boolean;

CREATE TABLE request_changes_owner (
id_user INTEGER,
id_restaurant INTEGER,
PRIMARY KEY(id_user,id_restaurant),
FOREIGN KEY (id_user) REFERENCES users (id),
FOREIGN KEY (id_restaurant) REFERENCES restaurants (id)
);
ALTER TABLE request_changes_owner ADD COLUMN accepted boolean;