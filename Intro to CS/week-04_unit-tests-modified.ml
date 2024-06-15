(* week-04_unit-tests-modified.ml*)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Fri 04 Feb 2022 *)

(* ********** *)

let test_successor candidate =
  (candidate ~-1 = 0) &&
  (candidate 0 = 1) &&
  (candidate 1 = 2)
  (* etc. *);;

(* ***** *)

let successor_v0 = fun n -> n + 1;;

let () = assert (test_successor successor_v0);;

(* ***** *)

let successor_v0' = fun n -> 1 + n;;

let () = assert (test_successor successor_v0');;

(* ***** *)

let successor_v1 n =
  n + 1;;

let () = assert (test_successor successor_v1);;

(* ***** *)

let successor_v1' n =
  1 + n;;

let () = assert (test_successor successor_v1);;

(* ***** *)

let identity x =
  x;;

let () = assert (test_successor identity = false);;

(* ********** *)

let end_of_file = "week-04_unit-tests-modified.ml";;

(*
        OCaml version 4.01.0

# #use "week-04_unit-tests-modified.ml";;
val test_successor : (int -> int) -> bool = <fun>
val successor_v0 : int -> int = <fun>
val successor_v0' : int -> int = <fun>
val successor_v1 : int -> int = <fun>
val successor_v1' : int -> int = <fun>
val identity : 'a -> 'a = <fun>
val end_of_file : string = "week-04_unit-tests-modified.ml"
# 
*)
