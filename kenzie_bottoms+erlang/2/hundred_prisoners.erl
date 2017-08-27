-module(hundred_prisoners).
-export([carry_on/1]).

% State = {PrisonerID, Day, LightsOn, LightSwitchers, LeaderCount}

% on day #
carry_on({_, Day, _, _, 99}) ->
    io:fwrite("\033[01;32mAll the prisoners have seen the light! They're free! "),
    io:fwrite(integer_to_list(Day)),
    io:fwrite(" days have passed.\033[00;37m\n");
% if it's the leader and the lights are on
carry_on({1, Day, true, LightSwitchers, LeaderCount}) ->
    io:fwrite("\033[00;35mThe leader found the lights on and turned them off.\n"),
    carry_on({rand:uniform(100), Day+1, false, LightSwitchers, LeaderCount+1});
% if the lights aren't on
carry_on({PrisonerID, Day, false, LightSwitchers, LeaderCount}) ->
    RepeatOffender = lists:member(PrisonerID, LightSwitchers),
    if
        not RepeatOffender ->
            io:fwrite("\033[00;33mA new prisoner got to change the lights!\033[00;37m\n"),
            carry_on({rand:uniform(100), Day+1, true, [PrisonerID|LightSwitchers], LeaderCount});
        true ->
            carry_on({rand:uniform(100), Day+1, false, LightSwitchers, LeaderCount})
    end;
% else
carry_on({_, Day, LightsOn, LightSwitchers, LeaderCount}) ->
    carry_on({rand:uniform(100), Day+1, LightsOn, LightSwitchers, LeaderCount}).