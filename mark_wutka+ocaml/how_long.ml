(* This program computes the average number of days it takes for
 * every prisoner to have visited the room at least once
 *)

Random.self_init();;

(* Verify that everyone has visited *)
let rec checkVisited hasVisited n =
    if n == 0 then
        Array.get hasVisited n
    else if Array.get hasVisited n then
        checkVisited hasVisited (n-1)
    else
        false;;

(* Count how many days it takes for n prisoners selected at random to
 * have visited the room.
 *)
let count_days n =
    let hasVisited = Array.make n false in
    let rec check_em_1 days hasVisited =
        let prisoner = Int32.to_int (Random.int32 (Int32.of_int n)) in
        Array.set hasVisited prisoner true;
        if checkVisited hasVisited (n-1) then
           days
        else
            check_em_1 (days+1) hasVisited
    in check_em_1 1 hasVisited;;

(* Compute the average of n trials of 100 prisoners to see on average
 * how long it takes for each prisoner to visit the room.
 *)
let rec do_average sum numSums n =
    if n == 0 then
        (print_string "The average number was "; print_float (float sum /. float numSums); print_string "\n")
    else
        let newSum = sum + (count_days 100) in
        do_average newSum (numSums+1) (n-1);;

(* Compute the average for 10,000 trials *)
do_average 0 0 10000
