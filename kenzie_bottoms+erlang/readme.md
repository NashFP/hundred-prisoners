# One

Brute force solution copied from Bryan Hunter's solution. One prisoner is the leader; each non-leader prisoner turns the light on once in their lifetime. If the light is already on, they leave it on and wait until the light is off to do their light switching.

## 1a. basic

Slightly better than below because the leader is the first person in the room.

```erlang
hundred_prisoners:carry_on({1, 1, false, [], 0}).
```

## 1b. basic af

First person in the room is chosen independently of the also randomly selected leader.

```erlang
hundred_prisoners:carry_on({rand:uniform(100), 1, false, [], 0}).
```