TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
PG_CONFIG   ?= pg_config
PG92         = $(shell $(PG_CONFIG) --version | grep -qE " 8\.| 9\.0| 9\.1" && echo no || echo yes)

ifeq ($(PG92),no)
$(error $(EXTENSION) requires PostgreSQL 9.2 or higher)
endif

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
