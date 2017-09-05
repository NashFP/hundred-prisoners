module Prisoner :
sig
  type result =
    | Released of int
    | Executed of int
  val warden : int -> result
  val run_test : int -> unit
end
