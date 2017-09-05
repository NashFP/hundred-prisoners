open Prisoner;;

let rec run_tests num_prisoners num_tests successes failures =
  if num_tests == 0 then
    (successes, failures)
  else
    match Prisoner.warden num_prisoners with
    | Prisoner.Released num -> run_tests num_prisoners (num_tests-1) (successes+1) failures
    | Prisoner.Executed num -> run_tests num_prisoners (num_tests-1) successes (failures+1)

let num_prisoners =
  if (Array.length Sys.argv) > 1 then
    int_of_string Sys.argv.(1)
  else
    100;;

let num_tests =
  if (Array.length Sys.argv) > 2 then
    int_of_string Sys.argv.(2)
  else
    1000;;

let (successes, failures) = run_tests num_prisoners num_tests 0 0;;
Printf.printf "There were %d successes and %d failures\n" successes failures
