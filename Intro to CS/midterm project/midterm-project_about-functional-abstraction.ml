(* midterm-project_about-functional-abstraction.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Fri 11 Mar 2022, belatedly *)

(* ********** *)

(* name of the group:SJANN
*)


(* More functional abstraction *)
(* Task *)
let task  = "mandatory"

let test_conjunction candidate =
  (candidate true true = true)
  &&
  (candidate true false = false)
  &&
  (candidate false true = false)
  &&
  (candidate false false = false);;

let test_disjunction candidate =
  (candidate true true = true)
  &&
  (candidate true false = true)
  &&
  (candidate false true = true)
  &&
  (candidate false false = false);;

let test_negated_conjunction candidate =
  (candidate true true = false)
  &&
  (candidate true false = true)
  &&
  (candidate false true = true)
  &&
  (candidate false false = true);;

let test_negated_disjunction candidate =
  (candidate true true = false)
  &&
  (candidate true false = false)
  &&
  (candidate false true = false)
  &&
  (candidate false false = true);;

let test_exclusive_disjunction candidate =
  (candidate true true = false)
  &&
  (candidate true false = true)
  &&
  (candidate false true = true)
  &&
  (candidate false false = false);;

(* ***** *)

let make_boolean_function tt tf ft ff b1 b2 =
  if b1 && b2 then tt
  else if b1 && not b2 then tf
  else if not b1 && b2 then ft
  else ff;;

(* ***** *)

let conjunction_gen =
  make_boolean_function true false false false;;

let () = assert (test_conjunction conjunction_gen = true);;

let disjunction_gen =
  make_boolean_function true true true false;;

let () = assert (test_disjunction disjunction_gen = true);;

let negated_conjunction_gen =
  make_boolean_function false true true true;;

let () = assert (test_negated_conjunction negated_conjunction_gen = true);;

let negated_disjunction_gen =
  make_boolean_function false false false true;;

let () = assert (test_negated_disjunction negated_disjunction_gen = true);;

let exclusive_disjunction_gen =
  make_boolean_function false true true false;;

let () = assert (test_exclusive_disjunction exclusive_disjunction_gen = true);;

(* ********** *)

let end_of_file = "midterm-project_about-functional-abstraction.ml";;


(*
        OCaml version 4.01.0

# #use "midterm-project_about-functional-abstraction.ml";;
val test_conjunction : (bool -> bool -> bool) -> bool = <fun>
val test_disjunction : (bool -> bool -> bool) -> bool = <fun>
val test_negated_conjunction : (bool -> bool -> bool) -> bool = <fun>
val test_negated_disjunction : (bool -> bool -> bool) -> bool = <fun>
val test_exclusive_disjunction : (bool -> bool -> bool) -> bool = <fun>
val make_boolean_function : 'a -> 'a -> 'a -> 'a -> bool -> bool -> 'a =
  <fun>
val conjunction_gen : bool -> bool -> bool = <fun>
val disjunction_gen : bool -> bool -> bool = <fun>
val negated_conjunction_gen : bool -> bool -> bool = <fun>
val negated_disjunction_gen : bool -> bool -> bool = <fun>
val exclusive_disjunction_gen : bool -> bool -> bool = <fun>
val end_of_file : string = "midterm-project_about-functional-abstraction.ml"
#
 *)
