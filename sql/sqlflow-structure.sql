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

SET search_path TO sqlflow, public;
--
-- Add types
--
CREATE TYPE flow_type AS ENUM ('row', 'statement');
CREATE TYPE flow_cond AS ENUM ('and', 'or', 'xor');
CREATE TYPE flow_state AS ENUM ('init', 'progress', 'complete', 'cancelled', 'waiting');

--
-- Workflow structure tables
--
CREATE TABLE sqlflow.workflow
(
    id serial,
    uref character varying(36) NOT NULL,
    title character varying(64) NOT NULL,
    rel_table character varying(127) NOT NULL,
    flow_type flow_type NOT NULL DEFAULT 'row',
    CONSTRAINT workflow_pkey PRIMARY KEY (id),
    CONSTRAINT workflow_ref_uniq UNIQUE (uref)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.workflow
    OWNER to sqlflow;

CREATE TABLE sqlflow.version
(
    id serial,
    uref character varying(36) NOT NULL,
    title character varying(64) NOT NULL,
    workflow_id integer REFERENCES sqlflow.workflow ON DELETE CASCADE,
    revision integer NOT NULL default 1,
    CONSTRAINT version_pkey PRIMARY KEY (id),
    CONSTRAINT version_ref_uniq UNIQUE (uref),
    CONSTRAINT version_revision_uniq UNIQUE (workflow_id, revision)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.version
    OWNER to sqlflow;

CREATE TABLE sqlflow.activity
(
    id serial,
    uref character varying(36) NOT NULL,
    title character varying(64) NOT NULL,
    version_id integer REFERENCES sqlflow.version ON DELETE CASCADE,
    logic_in flow_cond NOT NULL DEFAULT 'xor',
    logic_out flow_cond NOT NULL DEFAULT 'xor',
    flow_start boolean NOT NULL DEFAULT false,
    flow_stop boolean NOT NULL DEFAULT false,
    CONSTRAINT activity_pkey PRIMARY KEY (id),
    CONSTRAINT activity_ref_uniq UNIQUE (uref)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.activity
    OWNER to sqlflow;


CREATE TABLE sqlflow.transition
(
    id serial,
    uref character varying(36) NOT NULL,
    title character varying(64) NOT NULL,
    act_from_id integer REFERENCES sqlflow.activity ON DELETE CASCADE,
    act_to_id integer REFERENCES sqlflow.activity ON DELETE CASCADE,
    trans_cond text NOT NULL DEFAULT 'true',
    CONSTRAINT transition_pkey PRIMARY KEY (id),
    CONSTRAINT transition_ref_uniq UNIQUE (uref)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.transition
    OWNER to sqlflow;


CREATE TABLE sqlflow.task
(
    id serial,
    uref character varying(36) NOT NULL,
    title character varying(64) NOT NULL,
    activity_id integer REFERENCES sqlflow.activity ON DELETE CASCADE,
    task_seq integer NOT NULL DEFAULT 1,
    task_code text NOT NULL,
    CONSTRAINT task_pkey PRIMARY KEY (id),
    CONSTRAINT task_ref_uniq UNIQUE (uref)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.task
    OWNER to sqlflow;

CREATE TABLE sqlflow.condition
(
    id serial,
    uref character varying(36) NOT NULL,
    title character varying(64) NOT NULL,
    transition_id integer REFERENCES sqlflow.transition ON DELETE CASCADE,
    cond_seq integer NOT NULL DEFAULT 1,
    cond_func character varying(128) NOT NULL,
    CONSTRAINT condition_pkey PRIMARY KEY (id),
    CONSTRAINT condition_ref_uniq UNIQUE (uref)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.condition
    OWNER to sqlflow;
--
-- Add comments on tables and columns
--
COMMENT ON TABLE sqlflow.workflow IS 'Workflow process declaration';
COMMENT ON COLUMN sqlflow.workflow.title IS 'Workflow title';

COMMENT ON TABLE sqlflow.version IS 'Versionning workflow process';
COMMENT ON COLUMN sqlflow.version.title IS 'Version title';
COMMENT ON COLUMN sqlflow.version.uref IS 'Unique reference, use on import/export';
COMMENT ON COLUMN sqlflow.version.revision IS 'Incremental workflow revision';

COMMENT ON TABLE sqlflow.activity IS 'Activity on workflow';
COMMENT ON COLUMN sqlflow.activity.title IS 'Activity title';
COMMENT ON COLUMN sqlflow.activity.uref IS 'Unique reference, use on import/export';
COMMENT ON COLUMN sqlflow.activity.version_id IS 'Activity link to version';
COMMENT ON COLUMN sqlflow.activity.logic_in IS 'Operator logic use when enter to this activity';
COMMENT ON COLUMN sqlflow.activity.logic_out IS 'Operator logic use when exit to this activity';
COMMENT ON COLUMN sqlflow.activity.flow_start IS 'Is a start activity (unique per version)';
COMMENT ON COLUMN sqlflow.activity.flow_stop IS 'Is a end activity (multiple per version)';

COMMENT ON TABLE sqlflow.transition IS 'Transition is link between 2 activities';
COMMENT ON COLUMN sqlflow.transition.title IS 'Activity title';
COMMENT ON COLUMN sqlflow.transition.title IS 'Transition title';

COMMENT ON TABLE sqlflow.task IS 'Activity task on workflow';
COMMENT ON COLUMN sqlflow.task.title IS 'Activity task title';
COMMENT ON COLUMN sqlflow.task.uref IS 'Unique reference, use on import/export';
COMMENT ON COLUMN sqlflow.task.task_seq IS 'Task sequence on activity';
COMMENT ON COLUMN sqlflow.task.task_code IS 'PLpgSQL code execute on this task';

COMMENT ON TABLE sqlflow.condition IS 'Transition condition on workflow';
COMMENT ON COLUMN sqlflow.condition.title IS 'Condition title';
COMMENT ON COLUMN sqlflow.condition.uref IS 'Unique reference, use on import/export';
COMMENT ON COLUMN sqlflow.condition.cond_seq IS 'Order to execute condition on transition';
COMMENT ON COLUMN sqlflow.condition.cond_func IS 'Function to execute on this condition';
