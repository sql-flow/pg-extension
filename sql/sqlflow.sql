--
-- SQLFlow extension
-- Workflow engine in SQL
--

--
-- Add user to manage sqlflow object s in database
--
CREATE ROLE sqlflow WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

COMMENT ON ROLE sqlflow IS 'User for sqlflow extension';

--
-- Add specific schema for SQLFlow
--
CREATE SCHEMA sqlflow
    AUTHORIZATION sqlflow;

COMMENT ON SCHEMA sqlflow
    IS 'SQLFlow Engine';

--
-- Workflow table
--
CREATE TABLE sqlflow.workflow
(
    id serial,
    uref uuid NOT NULL,
    name character varying(64) NOT NULL,
    rel_table character varying(127) NOT NULL,
    CONSTRAINT workflow_pkey PRIMARY KEY (id),
    CONSTRAINT ref_uniq UNIQUE (uref)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.workflow
    OWNER to sqlflow;
