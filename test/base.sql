-- Start transaction and plan the tests.
BEGIN;
SELECT plan(10);

-- Run test on sqlflow structure
SELECT has_schema('sqlflow');

SELECT has_type('sqlflow', 'flow_type');
SELECT has_type('sqlflow', 'flow_cond');
SELECT has_type('sqlflow', 'flow_state');

SELECT has_table('sqlflow', 'workflow');
SELECT has_column('sqlflow', 'workflow', 'id', 'id column exists');
SELECT has_column('sqlflow', 'workflow', 'uref', 'uref column exists');
SELECT has_column('sqlflow', 'workflow', 'title', 'title column exists');
SELECT has_column('sqlflow', 'workflow', 'rel_table', 'rel_table column exists');
SELECT has_column('sqlflow', 'workflow', 'flow_type', 'flow_type column exists');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
