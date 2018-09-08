-- Uninstall SQLFlow
SET search_path TO sqlflow, public;

DROP SCHEMA sqlflow CASCADE;

--DROP TYPE flow_type CASCADE;
--DROP TYPE flow_cond CASCADE;

DROP USER sqlflow;