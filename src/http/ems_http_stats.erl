%%%---------------------------------------------------------------------------------------
%%% @author     Max Lapshin <max@maxidoors.ru> [http://erlyvideo.org]
%%% @copyright  2010 Max Lapshin
%%% @doc        Push channel for HTTP
%%% @reference  See <a href="http://erlyvideo.org" target="_top">http://erlyvideo.org</a> for more information
%%% @end
%%%
%%% This file is part of erlyvideo.
%%% 
%%% erlyvideo is free software: you can redistribute it and/or modify
%%% it under the terms of the GNU General Public License as published by
%%% the Free Software Foundation, either version 3 of the License, or
%%% (at your option) any later version.
%%%
%%% erlyvideo is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%% GNU General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with erlyvideo.  If not, see <http://www.gnu.org/licenses/>.
%%%
%%%---------------------------------------------------------------------------------------
-module(ems_http_stats).
-author('Max Lapshin <max@maxidoors.ru>').
-include("../../include/ems.hrl").

-export([http/4]).



http(Host, 'GET', ["stats.json"], Req) ->
  EntryClients = [{Name, proplists:get_value(client_count, Options)} || {Name, _Pid, Options} <- media_provider:entries(Host)],
  CPULoad = {struct, [{avg1, cpu_sup:avg1() / 256}, {avg5, cpu_sup:avg5() / 256}, {avg15, cpu_sup:avg15() / 256}]},
  RTMPTraf = rtmp_stat_collector:stats(),
  Stats = [{clients,EntryClients},{cpu,CPULoad},{rtmp,RTMPTraf}],
  Req:respond(200, [{"Content-Type", "application/json"}], [mochijson2:encode({struct, Stats}), "\n"]);

http(_Host, _Method, _Path, _Req) ->
  unhandled.
