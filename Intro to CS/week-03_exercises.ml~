(* week-03_exercises.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 29 Jan 2022 *)

(* ********** *)

(*
Name of the group on Canvas: WEEK-03_
*)

(* ********** *)

(* Exercise 10 *)

let exercise_10 = "mandatory";;

let test_successor candidate =
  true;;

let exercise_10_positive_test_a = (test_successor (fun i -> i + 1) = true);;

let exercise_10_positive_test_b = (test_successor (fun i -> 1 + i) = true);;

let exercise_10_positive_test_c = (test_successor succ = true);;

(*
let exercise_10_negative_test_a = (test_successor (fun i -> i) = false);;

let exercise_10_negative_test_b = (test_successor (fun i -> i + 2) = false);;
*)

(* Can you implement a fake successor function,
   i.e., one that is incorrect but that passes the unit tests? *)
(*
let fake_successor n =
  ...;;

let exercise_10_test_fake_successor = (test_successor succ = true);;
*)

(* ********** *)

(* Exercise 11 *)

let exercise_11 = "mandatory";;

let test_not candidate =
  true;;

(*
let exercise_11_positive_test_a = (test_not not = true);;

let exercise_11_negative_test_a = (test_not (fun b -> b) = false);;
*)

(*
let neg_v1 b =
  if ... then ... else ...;;

let exercise_11_positive_test_b = (test_not neg_v1 = true);;
*)

(*
let neg_v2 b =
  ... = ...;;

let exercise_11_positive_test_b = (test_not neg_v2 = true);;
*)

(* Can you implement a fake negation function,
   i.e., one that is incorrect but that passes the unit tests? *)
(*
let fake_not b =
  ...;;

let exercise_11_test_fake_not = (test_not fake_not = true);;
*)

(* ********** *)

(* Exercise 13 *)

let exercise_13 = "mandatory";;

let test_twice_less_than candidate =
     (candidate 100 200 300 = true)
(*
  && (candidate ... ... ... = true)
  && (candidate ... ... ... = true)
*)
  && (candidate 100 100 300 = false)
(*
  && (candidate ... ... ... = false)
  && ...
*)
  (* etc. *);;

(*
let twice_less_than_v0 i j k =
  ...;;

let exercise_13_positive_test_a = (test_twice_less_than twice_less_than_v0 = true);;
*)

(*
let twice_less_than_v1 i j k =
  ...;;

let exercise_13_positive_test_b = (test_twice_less_than twice_less_than_v1 = true);;
*)

(*
let twice_less_than_v2 i j k =
  ...;;

let exercise_13_positive_test_c = (test_twice_less_than twice_less_than_v2 = true);;
*)

(*
let exercise_13_negative_test_a = (test_twice_less_than ... = false);;
*)

(* Can you implement a fake twice_less_than function,
   i.e., one that is incorrect but that passes the unit tests? *)
(*
let fake_twice_less_than i j k =
  ...;;

let exercise_13_test_fake_twice_less_than = (test_twice_less_than fake_twice_less_than = true);;
*)

(* ********** *)

(* Exercise 15 *)

let exercise_15 = "mandatory";;

let test_sum_of_first_odd_positive_numbers candidate =
  true;;

(* ********** *)

(* Exercise 14 (recommended) *)

let exercise_14 = "recommended";;

let test_sum_of_first_non_negative_numbers candidate =
  true;;

(* ********** *)

let end_of_file = "week-03_exercises-updated.ml";;

(* remember to update the digital signature below *)

(*
        OCaml version 4.01.0

val exercise_10 : string = "mandatory"
val test_successor : 'a -> bool = <fun>
val exercise_10_positive_test_a : bool = true
val exercise_10_positive_test_b : bool = true
val exercise_10_positive_test_c : bool = true
val exercise_11 : string = "mandatory"
val test_not : 'a -> bool = <fun>
val exercise_13 : string = "mandatory"
val test_twice_less_than : (int -> int -> int -> bool) -> bool = <fun>
val exercise_15 : string = "mandatory"
val test_sum_of_first_odd_positive_numbers : 'a -> bool = <fun>
val exercise_14 : string = "recommended"
val test_sum_of_first_non_negative_numbers : 'a -> bool = <fun>
val end_of_file : string = "week-03_exercises.ml"
*)
