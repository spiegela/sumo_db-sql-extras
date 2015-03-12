-module(sumo_test_people_mysql).

-behavior(sumo_doc).

-include_lib("mixer/include/mixer.hrl").
-mixin([{sumo_test_people,
         [sumo_wakeup/1,
          sumo_sleep/1,
          new/2,
          new/3,
          new/4,
          name/1,
          id/1
         ]
        }
       ]).

-export([sumo_schema/0]).

-spec sumo_schema() -> sumo:schema().
sumo_schema() ->
    Fields =
    [sumo:new_field(id,        integer, [id, not_null, auto_increment]),
     sumo:new_field(name,      string,  [{length, 255}, not_null]),
     sumo:new_field(last_name, string,  [{length, 255}, not_null]),
     sumo:new_field(age,       integer),
     sumo:new_field(address,   string, [{length, 255}])
    ],
    sumo:new_schema(?MODULE, Fields).
