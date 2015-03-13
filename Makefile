PROJECT = sumo_sql_extra
include erlang.mk

DEPS = mixer sumo_db

dep_mixer = git https://github.com/spiegela/mixer.git master
dep_sumo_db = git https://github.com/inaka/sumo_db.git 0.3.0

DIALYZER_DIRS := ebin/
DIALYZER_OPTS := --verbose --statistics -Werror_handling \
                 -Wrace_conditions #-Wunmatched_returns

TEST_ERLC_OPTS += +'{parse_transform, lager_transform}'
CT_SUITES = sumo_sql_extra
CT_OPTS = -s emysql -s sumo_db -erl_args -config test/test.config

test-shell: test-build app
	erl -pa ebin -pa deps/*/ebin -pa test -s lager -s sync -config test/test.config
