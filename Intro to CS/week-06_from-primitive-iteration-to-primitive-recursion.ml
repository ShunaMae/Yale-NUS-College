(* week-06_from-primitive-iteration-to-primitive-recursion.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 26 Feb 2022, with "last_index" in the definition of "rotate_right_1" *)
(* was: *)
(* Version of Sat 19 Feb 2022 *)

(* ********** *)

let nat_fold_right zero_case succ_case n =
  (* nat_fold_right : 'a -> ('a -> 'a) -> int -> 'a *)
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then zero_case
    else let i' = pred i
         in let ih = visit i'
            in succ_case ih    (* <-- succ_case takes one argument *)
  in visit n;;

let nat_parafold_right zero_case succ_case n =
  (* nat_parafold_right : 'a -> (int -> 'a -> 'a) -> int -> 'a *)
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then zero_case
    else let i' = pred i
         in let ih = visit i'
            in succ_case i' ih    (* <-- succ_case takes two arguments *)
  in visit n;;

(* ********** *)

(* Exercise 3 *)

let test_predecessor_a candidate =
  let b0 = (candidate 0 = 0)
  and b1 = (candidate 1 = 0)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (let n = Random.int 1000
            in candidate (succ n) = n)
  in b0 && b1 && b2 && b3 && b4;;

let predecessor_a n =
  let () = assert (n >= 0) in
  assert false;;

(*
let () = assert (test_predecessor_a predecessor_a = true);;
*)

(* ***** *)

let test_predecessor_b candidate =
  let b0 = (candidate 0 = 0)
  and b1 = (candidate 1 = 0)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (let n = Random.int 1000
            in candidate n = pred n)
  in b0 && b1 && b2 && b3 && b4;;

(* ***** *)

let test_predecessor_c candidate =
  let b0 = (candidate 0 = min_int)
  and b1 = (candidate 1 = 0)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (let n = Random.int 1000
            in candidate (succ n) = n)
  in b0 && b1 && b2 && b3 && b4;;

let predecessor_c n =
  let () = assert (n >= 0) in
  assert false;;

(*
let () = assert (test_predecessor_c predecessor_c = true);;
*)

(* ***** *)

let test_predecessor_d candidate =
  let b0 = (candidate 0 = -1)
  and b1 = (candidate 1 = 0)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (let n = Random.int 1000
            in candidate (succ n) = n)
  in b0 && b1 && b2 && b3 && b4;;

let predecessor_d n =
  let () = assert (n >= 0) in
  assert false;;

(*
let () = assert (test_predecessor_d predecessor_d = true);;
*)

(* ***** *)

let test_predecessor_e candidate =
  let b0 = (candidate 0 = -1)
  and b1 = (candidate 1 = 0)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (let n = Random.int 1000
            in candidate n = pred n)
  in b0 && b1 && b2 && b3 && b4;;

(* ********** *)

(* Exercise 4 *)

let test_predecessor candidate =
  let b0 = (candidate 0 = 0)
  and b1 = (candidate 1 = 0)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (let n = Random.int 1000
            in candidate (succ n) = n)
  in b0 && b1 && b2 && b3 && b4;;

let predecessor_using_nat_fold_right n =
  let () = assert (n >= 0) in
  assert false;;

(*
let () = assert (test_predecessor predecessor_using_nat_fold_right = true);;
*)

(* ********** *)

let test_fac candidate =
      (* the base case: *)
  let b0 = (candidate 0 = 1)
      (* some intuitive cases: *)
  and b1 = (candidate 1 = 1)
  and b2 = (candidate 2 = 2)
  and b3 = (candidate 3 = 6)
  and b4 = (candidate 4 = 24)
  and b5 = (candidate 5 = 120)
      (* instance of the induction step: *)
  and b6 = (let n = Random.int 20
            in candidate (succ n) = (succ n) * candidate n)
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6;;

(* ***** *)

let fac_v0 n =
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then 1
    else let i' = pred i
         in let ih = visit i'
            in (succ i') * ih
  in visit n;;

let () = assert (test_fac fac_v0);;

(* ***** *)

let fac_v1 n =
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then 1
    else let i' = pred i
         in let ih = visit i'
            in i * ih
  in visit n;;

let () = assert (test_fac fac_v1);;

(* ***** *)

let fac_v2 n =
  nat_parafold_right 1 (fun n' ih -> (succ n') * ih) n;;

let () = assert (test_fac fac_v2);;

(* ********** *)

let test_rotate_left_1 candidate =
  let b0 = (candidate "" = "")
  and b1 = (candidate "a" = "a")
  and b2 = (candidate "ab" = "ba")
  and b3 = (candidate "abc" = "bca")
  and b5 = (candidate "abcde" = "bcdea")
  in b0 && b1 && b2 && b3 && b5;;

let rotate_left_1a s =
  let last_index = String.length s - 1
  in String.mapi (fun i c ->
                   if i = last_index
                   then String.get s 0
                   else String.get s (i + 1))
                 s;;

let () = assert (test_rotate_left_1 rotate_left_1a);;

let rotate_left_1b s =
  let last_index = String.length s - 1
  in String.mapi (fun i c ->
                   String.get s (if i = last_index
                                 then 0
                                 else i + 1))
                 s;;

let () = assert (test_rotate_left_1 rotate_left_1b);;

let rotate_left_1c s =
  let n = String.length s
  in String.mapi (fun i c ->
                   String.get s ((i + 1) mod n))
                 s;;

let () = assert (test_rotate_left_1 rotate_left_1c);;

(* ******)

let test_rotate_right_1 candidate =
  let b0 = (candidate "" = "")
  and b1 = (candidate "a" = "a")
  and b2 = (candidate "ab" = "ba")
  and b3 = (candidate "abc" = "cab")
  and b5 = (candidate "abcde" = "eabcd")
  in b0 && b1 && b2 && b3 && b5;;

let rotate_right_1 s =
  let n = String.length s
  in let last_index = n - 1
     in String.mapi (fun i c ->
                      String.get s ((i + last_index) mod n))
                    s;;

let () = assert (test_rotate_right_1 rotate_right_1);;

(* ********** *)

let end_of_file = "week-06_from-primitive-iteration-to-primitive-recursion.ml";;

(*
        OCaml version 4.01.0

# #use "anterior-strings.ml";;
module String :
  sig
    ...
  end
# #use "week-06_from-primitive-iteration-to-primitive-recursion.ml";;
val nat_fold_right : 'a -> ('a -> 'a) -> int -> 'a = <fun>
val nat_parafold_right : 'a -> (int -> 'a -> 'a) -> int -> 'a = <fun>
val test_fac : (int -> int) -> bool = <fun>
val fac_v0 : int -> int = <fun>
val fac_v1 : int -> int = <fun>
val fac_v2 : int -> int = <fun>
val test_rotate_left_1 : (string -> string) -> bool = <fun>
val rotate_left_1a : string -> string = <fun>
val rotate_left_1b : string -> string = <fun>
val rotate_left_1c : string -> string = <fun>
val test_rotate_right_1 : (string -> string) -> bool = <fun>
val rotate_right_1 : string -> string = <fun>
val end_of_file : string =
  "week-06_from-primitive-iteration-to-primitive-recursion.ml"
# 
*)
