%%% @author Aaron Spiegel
%%% @copyright 2015 Aaron Spiegel spiegela ++ [$@|gmail.com]
%%% 
%%% == License ==
%%% The MIT License
%%%
%%% Copyright (c) 2015 Aaron Spiegel
%%% 
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to
%%% deal in the Software without restriction, including without limitation the
%%% rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
%%% sell copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%% 
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%% 
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
%%% IN THE SOFTWARE.

-module(sumo_sql_extra).

-behaviour(sumo_store).

-include_lib("mixer/include/mixer.hrl").
-mixin([ { sumo_store_mysql,
           [ init/1, create_schema/2, persist/2, delete/3, delete_by/3,
             delete_all/2, find_all/2, find_all/5, find_by/3, find_by/5,
             find_by/6 ]
         }
       ]).

-export([find_by_sql/3, find_by_sql/4]).


-type sql_query() :: iolist().
-type sql_values() :: [string() | integer()].
-type doc_name() :: atom().
-type state() :: sumo_store_mysql:state().

-spec find_by_sql(sql_query(), doc_name(), state()) ->
  sumo_store:result([sumo_internal:doc()], state()).
find_by_sql(SqlQuery, DocName, State) ->
  sumo_store_mysql:get_docs( DocName, statement_name(DocName, SqlQuery), State).

-spec find_by_sql(sql_query(), sql_values(), doc_name(), state()) ->
  sumo_store:result([sumo_internal:doc()], state()).
find_by_sql(SqlQuery, Values, DocName, State) ->
  sumo_store_mysql:get_docs( DocName, statement_name(DocName, SqlQuery),
                             Values, State).

%%% Private Functions

statement_name(DocName, SqlQuery) ->
  sumo_store_mysql:prepare(
    DocName, list_to_atom(hexstring(crypto:hash(md5, SqlQuery))),
    fun() -> SqlQuery end).

hexstring(<<X:128/big-unsigned-integer>>) ->
    lists:flatten(io_lib:format("~32.16.0b", [X]));
hexstring(<<X:160/big-unsigned-integer>>) ->
    lists:flatten(io_lib:format("~40.16.0b", [X]));
hexstring(<<X:256/big-unsigned-integer>>) ->
    lists:flatten(io_lib:format("~64.16.0b", [X]));
hexstring(<<X:512/big-unsigned-integer>>) ->
    lists:flatten(io_lib:format("~128.16.0b", [X])).
