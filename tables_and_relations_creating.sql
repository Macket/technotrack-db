-- entities and one-to-many relations
CREATE TABLE IF NOT EXISTS courses(
  name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS stages(
  id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(255),
  course_name VARCHAR(255) NOT NULL,
  CONSTRAINT stage_course_fk FOREIGN KEY (course_name) REFERENCES courses (name)
);

CREATE TABLE IF NOT EXISTS days(
  id SERIAL PRIMARY KEY,
  number SMALLINT,
  stage_id SMALLINT NOT NULL,
  CONSTRAINT day_stage_fk FOREIGN KEY (stage_id) REFERENCES stages (id)
);

CREATE TABLE IF NOT EXISTS users(
  id BIGSERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(64) NOT NULL,
  phone_number CHAR(16) NOT NULL,
  password VARCHAR(64) NOT NULL,
  birthday DATE NOT NULL,
  reg_time TIMESTAMP NOT NULL,
  current_course_name VARCHAR(255),
  current_stage_id SMALLINT,
  current_day_id INT,
  CONSTRAINT cur_course_fk FOREIGN KEY (current_course_name) REFERENCES courses (name),
  CONSTRAINT cur_stage_fk FOREIGN KEY (current_stage_id) REFERENCES stages (id),
  CONSTRAINT cur_day_fk FOREIGN KEY (current_day_id) REFERENCES days (id)
);

CREATE TABLE IF NOT EXISTS exercises(
  name VARCHAR(255) PRIMARY KEY,
  description TEXT
);

-- many-to-many relations

CREATE TYPE course_status AS ENUM('finished', 'in progress');

CREATE TABLE IF NOT EXISTS user_course_history(
  user_id BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
  course_name VARCHAR(255) REFERENCES courses (name) ON UPDATE CASCADE ON DELETE CASCADE,
  start_date DATE NOT NULL,
  finish_date DATE,
  status course_status NOT NULL,
  CONSTRAINT user_course_history_pk PRIMARY KEY (user_id, course_name)
);

CREATE TYPE stage_status AS ENUM('finished', 'in progress', 'coming');

CREATE TABLE IF NOT EXISTS user_stage_history(
  user_id BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
  stage_id SMALLINT REFERENCES stages (id) ON UPDATE CASCADE ON DELETE CASCADE,
  start_date DATE,
  finish_date DATE,
  status stage_status NOT NULL,
  CONSTRAINT user_stage_history_pk PRIMARY KEY (user_id, stage_id)
);

CREATE TABLE IF NOT EXISTS user_day_history(
  user_id BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
  day_id INT REFERENCES days (id) ON UPDATE CASCADE ON DELETE CASCADE,
  finish_date DATE NOT NULL,
  CONSTRAINT user_day_history_pk PRIMARY KEY (user_id, day_id)
);

CREATE TABLE IF NOT EXISTS exercises_for_day(
  day_id INT REFERENCES days (id) ON UPDATE CASCADE ON DELETE CASCADE,
  exercise_name VARCHAR(255) REFERENCES exercises (name) ON UPDATE CASCADE ON DELETE CASCADE,
  status BOOLEAN DEFAULT FALSE ,
  CONSTRAINT exercises_for_day_pk PRIMARY KEY (day_id, exercise_name)
);

CREATE TABLE IF NOT EXISTS user_exercise_access(
  user_id BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
  exercise_name VARCHAR(255) REFERENCES exercises (name) ON UPDATE CASCADE ON DELETE CASCADE,
  access BOOLEAN NOT NULL,
  exec_number INT DEFAULT 0,
  CONSTRAINT user_exercise_access_pk PRIMARY KEY (user_id, exercise_name)
);
