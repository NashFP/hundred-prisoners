# OCaml Solution

One solution that we sort of hinted at at the meeting was to designate
one prisoner as a counter. Whenever a non-counter prisoner enters the
room, if the light is off, that prisoner turns on the light, and then
will never turn the light on again. When the counter enters the room,
if the light is on, they increment their count by 1. When the count
hits 99, then all the other prisoners have been in the room.

There is an optimization to this solution where instead of one counter
you have two levels of counters. In this solution, the prisoners who
don't do any counting are referred to as drones. The time is split into
two periods - one in which the drones turn on the lights and the counters
count them, and the other in which the counters turn on the light and
one master counter counts those.

The logic works like this:

## During the drone counting period:

*Drone*: If the light is off and I haven't turned the light on before, turn on the light.

*Subcounter*: If the light is on, and I haven't counted up to my maximum count, turn the light
off and increment my count.

*Master Counter*: Do nothing

## During the subcounter counting period:

*Drone*: Do nothing

*Subcounter*: If the light is off, and I have counted up to my maximum count, and I have
never turned the light on before, turn it on.

*Master*: If the light is on, increment my counter. If my counter reaches the number of
sub-counters, then everyone has visited the room.


If we get to the end of the subcounter counting period, we go back to drone counting,
but do not reset any states - drones still only turn on a light if they never have.
Counters don't zero out their counts.

The reason this works a little faster is that in the single-counter mode, a prisoner only
gets counted when the counter visits the room, and they have a 1/100 chance of being chosen.
With multiple sub-counters, the prisoners get counted a little faster since any counter
can count a prisoner, and then the master only has to count a few prisoners instead of 99.

## Building
To build, assuming you have OCaml installed:

`make prisoner`

To run:

`prisoner`


