(* week-04_exercises.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Friday 11 Feb 2022 *)
(* ********** *)

(*
Name of the group on Canvas: WEEK-04_3
*)

(* ********** *)

(* Exercise 03 *)

let exercise_03 = "mandatory"

let test_disjunction candidate =
  candidate true true = true
  && candidate true false = true
  && candidate false true = true
  && candidate false false = false

let exercise_03_positive_test_a =
  test_disjunction (fun b1 b2 -> b1 || b2) = true

let disjunction b1 b2 = if b1 then true else b2
let exercise_03_positive_test_b = test_disjunction disjunction = true

(* ********** *)

(* Exercise 06 *)

let exercise_06 = "mandatory";;

let test_xor candidate =
  candidate true true = false
  && candidate true false = true
  && candidate false true = true
  && candidate false false = false

let exercise_06_positive_test_a = test_xor (fun b1 b2 -> b1 != b2) = true
let xor b1 b2 = if b1 then if b2 then false else true else b2
let exercise_06_positive_test_b = test_xor xor = true

(* ********** *)

(* Exercise 13 *)

let exercise_13 = "mandatory";;

let test_successor candidate =
  candidate ~-1 = 0 && candidate 0 = 1 && candidate 1 = 2
(* etc. *)

let fake_successor n = if n >= ~-1 && n <= 1 then n + 1 else n
let () = assert (test_successor fake_successor)

let test_successor_v2 candidate =
  candidate ~-1 = 0
  && candidate 0 = 1
  && candidate 1 = 2
  && (let ran_pos = Random.int 1073741823 in
      (* 2^30 - 1 *)
      candidate ran_pos = ran_pos + 1)
  &&
  let ran_neg = ~-(Random.int 1073741823) in
  candidate ran_neg = ran_neg + 1
(* etc. *)

(* However, our fake_successor can still pass the unit test, if the random numbers
   are generated in a way that they between -1 to 1. *)
let () = assert (test_successor_v2 fake_successor = false)

(* ********** *)

(* Exercise 14 *)

let exercise_14 = "mandatory";;

let test_polynomials candidate_1 candidate_2 =
  let b0 = candidate_1 0 = candidate_2 0
  and b1 = candidate_1 1 = candidate_2 1
  and b2 = candidate_1 2 = candidate_2 2
  and b3 = candidate_1 3 = candidate_2 3
  and b4 = candidate_1 4 = candidate_2 4
  and b5 = candidate_1 5 = candidate_2 5 in
  b0 && b1 && b2 && b3 && b4 && b5

let power_0 x =
  (* computes x^0 *)
  1

let power_1 x =
  (* computes x^1 *)
  x

let power_2 x =
  (* computes x^2 *)
  x * x

let power_3 x =
  (* computes x^3 *)
  x * x * x

let power_4 x =
  (* computes x^4 *)
  x * x * x * x

let p x = (4 * power_4 x) + (3 * power_3 x) + (2 * power_2 x) + power_1 x
let h x = x * ((x * ((x * ((4 * power_1 x) + 3)) + 2)) + 1)
let () = assert (test_polynomials p h)

let fake_polynomial x =
  ((power_4 x * 4) + (3 * power_3 x) + (2 * power_2 x) + power_1 x) mod 3001

let () = assert (test_polynomials p fake_polynomial)
let () = assert (test_polynomials fake_polynomial h)

let test_polynomials_more_strongly candidate_1 candidate_2 =
  let b0 = candidate_1 0 = candidate_2 0
  and b1 = candidate_1 1 = candidate_2 1
  and b2 = candidate_1 2 = candidate_2 2
  and b3 = candidate_1 3 = candidate_2 3
  and b4 = candidate_1 4 = candidate_2 4
  and b5 = candidate_1 5 = candidate_2 5
  and br =
    let i = Random.int 1000 in
    candidate_1 i = candidate_2 i
  in
  b0 && b1 && b2 && b3 && b4 && b5 && br

let () = assert (test_polynomials_more_strongly p fake_polynomial = false)
let () = assert (test_polynomials_more_strongly fake_polynomial h = false)

let faker_polynomial x =
  ((power_4 x * 4) + (3 * power_3 x) + (2 * power_2 x) + power_1 x)
  mod 9007199254740997

let () = assert (test_polynomials_more_strongly p faker_polynomial)
let () = assert (test_polynomials_more_strongly faker_polynomial h)

let test_polynomials_even_more_strongly candidate_1 candidate_2 n =
  let b0 = candidate_1 0 = candidate_2 0
  and b1 = candidate_1 1 = candidate_2 1
  and b2 = candidate_1 2 = candidate_2 2
  and b3 = candidate_1 3 = candidate_2 3
  and b4 = candidate_1 4 = candidate_2 4
  and b5 = candidate_1 5 = candidate_2 5
  and br =
    let i = Random.int n in
    candidate_1 i = candidate_2 i
  in
  b0 && b1 && b2 && b3 && b4 && b5 && br

let () =
  assert (test_polynomials_even_more_strongly p fake_polynomial 1000000 = false)

(* ********** *)

let end_of_file = "week-04_exercises.ml"

(*
        OCaml version 4.12.0

#use "week-04_exercises.ml";;
val exercise_03 : string = "mandatory"
val test_disjunction : (bool -> bool -> bool) -> bool = <fun>
val exercise_03_positive_test_a : bool = true
val disjunction : bool -> bool -> bool = <fun>
val exercise_03_positive_test_b : bool = true
val exercise_06 : string = "mandatory"
val test_xor : (bool -> bool -> bool) -> bool = <fun>
val exercise_06_positive_test_a : bool = true
val xor : bool -> bool -> bool = <fun>
val exercise_06_positive_test_b : bool = true
val exercise_13 : string = "mandatory"
val test_successor : (int -> int) -> bool = <fun>
val fake_successor : int -> int = <fun>
val test_successor_v2 : (int -> int) -> bool = <fun>
val exercise_14 : string = "mandatory"
val test_polynomials : (int -> 'a) -> (int -> 'a) -> bool = <fun>
val power_0 : 'a -> int = <fun>
val power_1 : 'a -> 'a = <fun>
val power_2 : int -> int = <fun>
val power_3 : int -> int = <fun>
val power_4 : int -> int = <fun>
val p : int -> int = <fun>
val h : int -> int = <fun>
val fake_polynomial : int -> int = <fun>
val test_polynomials_more_strongly : (int -> 'a) -> (int -> 'a) -> bool = <fun>
val faker_polynomial : int -> int = <fun>
val test_polynomials_even_more_strongly :
  (int -> 'a) -> (int -> 'a) -> int -> bool = <fun>
val end_of_file : string = "week-04_exercises.ml"
#
*)
