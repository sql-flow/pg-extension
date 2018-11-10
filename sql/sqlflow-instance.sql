--
-- SQLFlow extension
-- Workflow engine in SQL
--

SET search_path TO sqlflow, public;

CREATE TABLE sqlflow.instance
(
    id bigserial,
    version_id integer REFERENCES sqlflow.version ON DELETE CASCADE ON UPDATE CASCADE,
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
    instance_id bigint REFERENCES sqlflow.instance ON DELETE CASCADE ON UPDATE CASCADE,
    flow_state flow_state NOT NULL DEFAULT 'init',
    tasks json DEFAULT '{}',
    CONSTRAINT instance_activity_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.instance_activity
    OWNER to sqlflow;

CREATE TABLE sqlflow.instance_transition
(
    id bigserial,
    instance_id bigint REFERENCES sqlflow.instance ON DELETE CASCADE ON UPDATE CASCADE,
    flow_state flow_state NOT NULL DEFAULT 'init',
    conditions json DEFAULT '{}',
    CONSTRAINT instance_transition_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.instance_transition
    OWNER to sqlflow;
        
/*
--
-- Query to retrieve tasks (instance_activity) 
-- and conditions (instance_transition)
--
select json_object_keys(col1) as condition_id,
       (col1->json_object_keys(col1)->'id')::text::int as cond_id, 
       (col1->json_object_keys(col1)->'state')::text as cond_state,
           (col1->json_object_keys(col1)->'result')::text as cond_result
from
        (select '{"1": {"id": 1512, "state": "complete", "result": true}, 
                  "2": {"id": 1623, "state": "waiting", "result": false},
                  "3": {"id": 5467, "state": "progress", "result": false}
         }'::json as col1, 1 as col2 ) x
ORDER BY 1
*/

CREATE TABLE sqlflow.instance_eventlog
(
    id bigserial,
    instance_id bigint REFERENCES sqlflow.instance ON DELETE CASCADE ON UPDATE CASCADE,
    event_time timestamp with time zone NOT NULL DEFAULT now(),
    description text NOT NULL,
    CONSTRAINT instance_eventlog_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE sqlflow.instance_eventlog
    OWNER to sqlflow;
        
--
-- Add comments on tables and columns
--      
COMMENT ON TABLE sqlflow.instance IS 'Workflow instance declaration';
COMMENT ON COLUMN sqlflow.instance.version_id IS 'Workflow instance link version';

COMMENT ON TABLE sqlflow.instance_activity IS 'Workflow instance activity';
COMMENT ON COLUMN sqlflow.instance_activity.instance_id IS 'Link to one instance';
COMMENT ON COLUMN sqlflow.instance_activity.flow_state IS 'State of this instance activity';
COMMENT ON COLUMN sqlflow.instance_activity.tasks IS 'States of each task related on activity';

COMMENT ON TABLE sqlflow.instance_transition IS 'Workflow instance transition';
COMMENT ON COLUMN sqlflow.instance_transition.instance_id IS 'Link to one instance';
COMMENT ON COLUMN sqlflow.instance_transition.flow_state IS 'State of this instance transition';
COMMENT ON COLUMN sqlflow.instance_transition.conditions IS 'States of each conditions related on transition';

COMMENT ON TABLE sqlflow.instance_eventlog IS 'Trace events on each instance';
