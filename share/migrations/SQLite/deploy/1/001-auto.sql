-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Wed Aug 24 21:59:40 2016
-- 

;
BEGIN TRANSACTION;
--
-- Table: todos
--
CREATE TABLE todos (
  todo_id INTEGER PRIMARY KEY NOT NULL,
  title varchar(40) NOT NULL,
  position integer NOT NULL,
  completed boolean NOT NULL
);
COMMIT;
