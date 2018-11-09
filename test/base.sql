-- Start transaction and plan the tests.
BEGIN;
SELECT plan(6);

-- Run test on sqlflow structure
SELECT has_schema('sqlflow');

SELECT has_type('sqlflow', 'flow_type');
SELECT has_type('sqlflow', 'flow_cond');
SELECT has_type('sqlflow', 'flow_state');

SELECT has_table('sqlflow', 'workflow');
SELECT has_column('sqlflow', 'workflow', 'id', 'id columns exists')

-- Table

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
