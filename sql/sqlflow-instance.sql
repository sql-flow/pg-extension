--
-- SQLFlow extension
-- Workflow engine in SQL
--

SET search_path TO sqlflow, public;

CREATE TABLE sqlflow.instance
(
    id bigserial,
	workflow_id integer REFERENCES sqlflow.workflow ON DELETE CASCADE,
	version_id integer REFERENCES sqlflow.version ON DELETE CASCADE,
    rel_table character varying(127) NOT NULL,
	flow_type flow_type NOT NULL DEFAULT 'row',
	flow_state flow_state NOT NULL DEFAULT 'init',
    CONSTRAINT instance_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.instance
    OWNER to sqlflow;