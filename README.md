# 100 Prisoners
Modeling the "one hundred prisoners and a light bulb" puzzle in your FP language of choice.

## The puzzle rules:

> There are 100 prisoners in solitary cells. There's a central living room with one light bulb; this bulb is initially off. No prisoner can see the light bulb from his or her own cell. Everyday, the warden picks a prisoner equally at random, and that prisoner visits the living room. While there, the prisoner can toggle the bulb if he or she wishes. Also, the prisoner has the option of asserting that all 100 prisoners have been to the living room by now. If this assertion is false, all 100 prisoners are shot. However, if it is indeed true, all prisoners are set free and inducted into MENSA, since the world could always use more smart people. Thus, the assertion should only be made if the prisoner is 100% certain of its validity. The prisoners are allowed to get together one night in the courtyard, to discuss a plan. What plan should they agree on, so that eventually, someone will make a correct assertion?

## Ideas

* Model each of the prisoners as distinct actors
* Model the living room as a distinct actor
* Create unit tests that will exercise edge cases, and try to keep your prisoners from getting shot.

## How to play along
Join the fun! Add a directory to this repo containing your code.

By convention, we use directory names that tell who wrote the code and what language it's in, separated by a `+`. For example: `bryan_hunter+elixir`.

If you don't have a clue where to start take a peek at some of the existing solutions. 

If you don't already have the right permissions to push to this repo, file an issue! We'll hook you up. You can also submit a pull request for your contributions. However you like to roll.
