(* Rather than having one counter counting all the prisoners,
 * this algorithm has drones, subcounters, and a master counter.
 * A drone is any prisoner whose only responsibility is turning on
 * the light if they haven't turned it on before. A subcounter counts
 * the drones, and the master counter counts the subcounters.
 * The time period is broken into two blocks of days. Each
 * subcounter is assigned the task of counting num_to_count lights.
 * Once they have seen num_to_count, they stop counting.
 * They only perform their counting during the first block of days.
 * During the second block of days, the subcounters act like drones,
 * turning on the light if they have never done so before, but
 * only if their count has reached num_to_count. During that
 * second block of days, a master counter counts how many subcounters have
 * turned on lights. Once it hits the number of subcounters, it knows that
 * everyone has visited.
 * Drones only turn on the light if they have never turned
 * it on before, and it is during the first block of days. During the
 * second block of days they do nothing.
 * The days are split into drone_day_count, and subcounter_day_count,
 * where drone_day_count is the period when drones turn on the light
 * and subcounters count it, and subcounter_day_count is the period when
 * subcounters turn on the light and the master counter counts
 * subcounters.
 * If we reach the end of subcounter_day_count and not all the subcounters
 * have been counted, we go back to the first period, because perhaps
 * not all the drones have been counted yet, but we don't reset any counts,
 * or lit flags.
 *)

type drone_state = { has_lit: bool; }
type subcounter_state = { count: int; num_to_count: int; has_lit: bool }
type counter_state = {count: int; num_to_count: int }

type prisoner_state =
  | Drone of drone_state
  | Subcounter of subcounter_state
  | Counter of counter_state

type context = {
    state: prisoner_state;
    drone_day_count: int;
    subcounter_day_count: int;
  }

type result = 
  | Released of int
  | Executed of int
  
 
(* What happens when a prisoner visits the room *)
let visit_room prisoner days light context =
    let total_days = context.drone_day_count + context.subcounter_day_count in
    let is_drone_counting_time = days mod total_days < context.drone_day_count in

    match context.state with
        (* If the prisoner is a drone and it is the drone counting period,
         * turn on the light if it is off and this drone has never
         * turned it on before *)
        Drone drone ->
            if is_drone_counting_time then
                if not light && not drone.has_lit then
                    (true, {context with state = Drone { has_lit=true }}, false)
                else
                    (light, context, false)
            else
                (light, context, false)

        (* If the prisoner is a subcounter and it is the droneDayCount
         * period, increment the sum if the light is on, and then turn
         * it off. Otherwise, if it is the subcounterDayCount period
         * and numToCount has been reached and this sub-counter has
         * never turned on the light before, turn it on.
         *)
        | Subcounter counter ->
            if is_drone_counting_time then
                if not light then
                    (false, context, false)
                else if (counter.count < counter.num_to_count) then
                  (false, {context with state=Subcounter {counter with count=counter.count + 1}},
                                       false)
                else
                    (light, context, false)
            else
                if not light then
                    if not counter.has_lit && counter.count == counter.num_to_count then
                        (true, {context with state=Subcounter {counter with has_lit=true}}, false)
                    else
                        (light, context, false)
                else
                    (light, context, false)
        | Counter counter ->
           (* The master counter does nothing during drone counting time.
            * Otherwise, it counts the subcounters. *)
            if is_drone_counting_time then
                (light, context, false)
            else
                if light then
                    if (counter.count+1) == counter.num_to_count then
                        (false, context, true)
                    else
                        (false, {context with state=Counter {counter with count=counter.count+1}}, false)
                else
                    (light, context, false);;

let new_drone ddc sdc = { state=Drone {has_lit=false}; drone_day_count=ddc; subcounter_day_count=sdc};;
let new_subcounter ntc ddc sdc = { state=Subcounter {count=0; num_to_count=ntc; has_lit = false};
                                   drone_day_count=ddc; subcounter_day_count=sdc};;
let new_counter ntc ddc sdc = { state=Counter {count=0; num_to_count=ntc}; drone_day_count=ddc;
                                subcounter_day_count=sdc};;

let rec make_drones ddc sdc n =
    if n == 0 then
        []
    else
        (new_drone ddc sdc) :: (make_drones ddc sdc (n-1))


let rec make_subcounter ddc sdc drones_left ntc n =
    if n == 0 then
        []
    else if drones_left > ntc then
        (new_subcounter ntc ddc sdc) :: make_subcounter ddc sdc (drones_left - ntc) ntc (n-1)
    else
        (new_subcounter drones_left ddc sdc) :: make_subcounter ddc sdc 0 ntc (n-1);;

Random.self_init();;

(* Verify that everyone has visited *)
let rec check_visited has_visited n =
    if n == 0 then
        Array.get has_visited n
    else if Array.get has_visited n then
        check_visited has_visited (n-1)
    else
        false;;

let warden num_prisoners =
    (* Initialize the state of the world *)
    let drone_day_count = 2000 in
    let subcounter_day_count = 2000 in
    let num_counters = num_prisoners / 10 in
    let num_drones = num_prisoners-num_counters-1 in
    let has_visited = Array.make num_prisoners false in
    let num_to_count = (num_drones + (num_counters - 1)) / num_counters in
    let prisoners = Array.of_list ((new_counter num_counters drone_day_count subcounter_day_count) ::
                      ((make_drones drone_day_count subcounter_day_count num_drones) @
                      (make_subcounter drone_day_count subcounter_day_count num_drones num_to_count num_counters))) in
    let rec warden_loop day light  =
        (* Choose a random prisoner *)
        let prisoner = Int32.to_int (Random.int32 (Int32.of_int num_prisoners)) in

        Array.set has_visited prisoner true;
        let prisoner_ctx = Array.get prisoners prisoner in
        let (new_light, new_prisoner_ctx, did_assert) = visit_room prisoner day light prisoner_ctx in
        Array.set prisoners prisoner new_prisoner_ctx;

        (* If the prisoner asserted that everyone has been there, check it *)
        if did_assert then
          if check_visited has_visited (num_prisoners-1) then
            Released day
          else
            Executed day
        else
            warden_loop (day+1) new_light
    in
        warden_loop 0 false

let run_test num_prisoners =
  match warden num_prisoners with
  | Released num -> Printf.printf "Prisoners were released after %d days\n" num
  | Executed num -> Printf.printf "Prisoners were executed after %d days\n" num;;

run_test 100;;                                 
