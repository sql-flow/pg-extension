-- Start transaction and plan the tests.
BEGIN;
SELECT plan(1);

SELECT has_type('sqlflow', 'flow_type');
SELECT has_type('sqlflow', 'flow_cond');
SELECT has_type('sqlflow', 'flow_state');

SELECT has_schema('sqlflow');

-- Table

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
