/*
function: GET_WORKFLOW_ID()
argument: 1> a_ref: the unique reference of the workflow
return: Primary key of the workflow
*/
CREATE OR REPLACE FUNCTION get_workflow_id(
	a_ref CHARACTER VARYING(36)
) RETURNS integer AS
$BODY$

DECLARE 
	t_workflow_id INTEGER DEFAULT NULL;
BEGIN

	BEGIN
		SELECT id INTO STRICT t_workflow_id 
	  	  FROM sqlflow.workflow 
	     WHERE uref=a_ref;
	EXCEPTION
    	WHEN NO_DATA_FOUND THEN
            RAISE EXCEPTION 'Workflow "%" not found', a_ref;
    	WHEN TOO_MANY_ROWS THEN
            RAISE EXCEPTION 'Workflow "%" not unique', a_ref;
	END;

	RETURN t_workflow_id;

END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

