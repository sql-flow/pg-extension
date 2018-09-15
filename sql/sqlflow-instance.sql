--
-- SQLFlow extension
-- Workflow engine in SQL
--

SET search_path TO sqlflow, public;

CREATE TABLE sqlflow.instance
(
    id bigserial,
	-- workflow_id integer REFERENCES sqlflow.workflow ON DELETE CASCADE,
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
	
CREATE TABLE sqlflow.instance_activity
(
	id bigserial,
	instance_id bigint REFERENCES sqlflow.instance ON DELETE CASCADE,
	flow_state flow_state NOT NULL DEFAULT 'init',
    CONSTRAINT instance_activity_pkey PRIMARY KEY (id)
	
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.instance_activity
    OWNER to sqlflow;
	
	
--
-- Add comments on tables and columns
--	
COMMENT ON TABLE sqlflow.instance IS 'Workflow instance declaration';
COMMENT ON COLUMN sqlflow.instance.title IS 'Workflow instance title';

COMMENT ON TABLE sqlflow.instance_activity IS 'Workflow instance activity';
COMMENT ON COLUMN sqlflow.instance_activity.instance_id IS 'Link to one instance';
COMMENT ON COLUMN sqlflow.instance_activity.flow_state IS 'State of this instance activity';

