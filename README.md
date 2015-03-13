# sumo_db-sql-extras

SQL-specific functionality for Sumo DB

##Expanded Store API

This libary application adds SQL specific functionality to stores.

### Find by SQL

Support for arbitrary queries to be sent to the sql store

```erlang
Pool = sumo_backend_mysql:get_pool(sumo_mysql_backend),
Sql  = "select * from people where name in (\"Jim\", \"Bob\")",
sumo_sql_extra:find_by_sql(Sql, people, {state, Pool}),
```

```erlang
Pool = sumo_backend_mysql:get_pool(sumo_mysql_backend),
Sql  = "select * from people where grade = ? or age = ?",
sumo_sql_extra:find_by_sql(Sql, ["B", 11], people, {state, Pool}),
```

##Database Support

Currently, MySQL is supported, but support for other SQL databases is planned.
