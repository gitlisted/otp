%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2011. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%
%%
-module(beam_expect_SUITE).

-export([all/0, suite/0,groups/0,init_per_suite/1, end_per_suite/1,
	 init_per_group/2,end_per_group/2,
	 coverage/1]).

suite() -> [{ct_hooks,[ts_install_cth]}].

all() ->
    [coverage].

groups() ->
    [].

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_GroupName, Config) ->
    Config.

end_per_group(_GroupName, Config) ->
    Config.

coverage(_) ->
    File = {file,"fake.erl"},
    ok = fc(a),
    {'EXIT',{function_clause,
	     [{?MODULE,fc,[[x]],[File,{line,2}]}|_]}} =
	(catch fc([x])),
    {'EXIT',{function_clause,
	     [{?MODULE,fc,[y],[File,{line,2}]}|_]}} =
	(catch fc(y)),
    {'EXIT',{function_clause,
	     [{?MODULE,fc,[[a,b,c]],[File,{line,6}]}|_]}} =
	(catch fc([a,b,c])),

    {'EXIT',{undef,[{erlang,error,[a,b,c],_}|_]}} =
	(catch erlang:error(a, b, c)),
    ok.

-file("fake.erl", 1).
fc(a) ->	                                %Line 2
    ok;						%Line 3
fc(L) when length(L) > 2 ->			%Line 4
    %% Not the same as a "real" function_clause error.
    error(function_clause, [L]).		%Line 6
