(* midterm-project_miscellany.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Fri 11 Mar 2022, belatedly *)

(* ********** *)

(* name of the group:SJANN *)

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

(* Exercise 03 from Week 06 *)

let exercise_03 = "mandatory";;

let test_nat_of_digits candidate =
  let b1 = (candidate "9" = 9)
  and b2 = (candidate "89" = 89)
  and b3 = (candidate "789" = 789)
  and b4 = (candidate "6789" = 6789)
  and br = (let n = Random.int 10000
            in candidate (string_of_int n) = n)
  in b1 && b2 && b3 && b4 && br;;

let nat_of_digit c =
  let () = assert ('0' <= c && c <= '9') in
  int_of_char c - int_of_char '0';;

let nat_of_digits_gen s =
  let n = String.length s in  
  nat_parafold_right (nat_of_digit (String.get s 0)) (fun i' ih -> ih * 10 + nat_of_digit (String.get s (succ i'))) (n-1) ;;

let () = assert (test_nat_of_digits nat_of_digits_gen);; 

(* ********** *)

(* Exercise 07 from Week 06 *)

let exercise_07 = "mandatory";;

(* Exercise 07a *)


let test_sigma candidate =
  let b0 = (let f x =  x in candidate f 3 = 6)
  and b1 = (let f x = x in candidate f 24 = ((24*25)/2))
  and br = (let n = Random.int 20 and f x = x in candidate f n = (n * (n+1) / 2))
  and bc1 = (let f x = 2 * x in
            candidate f 0 = 0)
  and is1 = (let n = Random.int 20 and f x = 2 * x in candidate f (n+1) = (candidate f (n)) + f (n+1))
  and b3 = (let f x = 3 * x + 5 in
            candidate f 4 = 55)
  and bc2 = (let f x = 3 * x + 5 in
            candidate f 0 = 5)
  and is2 = (let k = Random.int 7
            and f x = 3 * x + 5 in
            (candidate f (k+1) = (candidate f k) + ((3 *(k+1)) + 5)))
  in b0 && b1 && br && bc1 && is1 && b3 && bc2 && is2;;

(* ***** *)

(* Exercise 07b *)

let sigma_rec f n =
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then f 0
    else (visit (pred i)) + (f i)
  in visit n;;
  
(* ***** *)

(* Exercise 07c *)

let () = assert (test_sigma sigma_rec);;

(* ***** *)

(* Exercise 07d *)

let sigma_gen f n =
  nat_parafold_right (f 0) (fun i' ih -> ih + (f (succ i'))) n;;

let () = assert (test_sigma sigma_gen);;

(* ***** *)

(* Exercise 07e *)

let test_summatorial candidate =
  let b0 = (candidate 0 = 0)
  and b1 = (candidate 1 = 0 + 1)
  and b2 = (candidate 2 = 0 + 1 + 2)
  and b3 = (candidate 3 = 0 + 1 + 2 + 3)
  and b4 = (candidate 4 = 0 + 1 + 2 + 3 + 4)
  and b5 = (candidate 5 = 0 + 1 + 2 + 3 + 4 + 5)
  and b6 = (candidate 6 = 0 + 1 + 2 + 3 + 4 + 5 + 6)
  and b7 = (candidate 7 = 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7)
  and b8 = (candidate 8 = 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8;;

let summatorial_gen n =
  sigma_rec (fun x -> x) n;;


let () = assert (test_summatorial summatorial_gen);;

(* ***** *)

(* Exercise 07f *)

let test_sum_of_the_first_consecutive_odd_natural_numbers candidate =
  let b0 = (candidate 0 = 1)
  and b1 = (candidate 1 = 1 + 3)
  and b2 = (candidate 2 = 1 + 3 + 5)
  and b3 = (candidate 3 = 1 + 3 + 5 + 7)
  and b4 = (candidate 4 = 1 + 3 + 5 + 7 + 9)
  and b5 = (candidate 5 = 1 + 3 + 5 + 7 + 9 + 11)
  and b6 = (candidate 6 = 1 + 3 + 5 + 7 + 9 + 11 + 13)
  and b7 = (candidate 7 = 1 + 3 + 5 + 7 + 9 + 11 + 13 + 15)
  and b8 = (candidate 8 = 1 + 3 + 5 + 7 + 9 + 11 + 13 + 15 + 17)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8;;

(* Using our recursive function sigma *) 

let sum_of_the_first_consecutive_odd_natural_numbers_rec n =
sigma_rec (fun x -> (2*x) + 1) n;;

let () = assert (test_sum_of_the_first_consecutive_odd_natural_numbers sum_of_the_first_consecutive_odd_natural_numbers_rec);;

(* Using our nat_parafold_right version of sigma *)

let sum_of_the_first_consecutive_odd_natural_numbers_gen n =
  sigma_gen (fun x -> (2*x) + 1) n;;

let () = assert (test_sum_of_the_first_consecutive_odd_natural_numbers sum_of_the_first_consecutive_odd_natural_numbers_gen);;

(* ********** *)

let end_of_file = "midterm-project_miscellany.ml";;

(*
        OCaml version 4.01.0

# #use "midterm-project_miscellany-final.ml";;
val nat_fold_right : 'a -> ('a -> 'a) -> int -> 'a = <fun>
val nat_parafold_right : 'a -> (int -> 'a -> 'a) -> int -> 'a = <fun>
val exercise_03 : string = "mandatory"
val test_nat_of_digits : (string -> int) -> bool = <fun>
val nat_of_digit : char -> int = <fun>
val nat_of_digits_gen : string -> int = <fun>
val exercise_07 : string = "mandatory"
val test_sigma : ((int -> int) -> int -> int) -> bool = <fun>
val sigma_rec : (int -> int) -> int -> int = <fun>
val sigma_gen : (int -> int) -> int -> int = <fun>
val test_summatorial : (int -> int) -> bool = <fun>
val summatorial_gen : int -> int = <fun>
val test_sum_of_the_first_consecutive_odd_natural_numbers :
  (int -> int) -> bool = <fun>
val sum_of_the_first_consecutive_odd_natural_numbers_rec : int -> int = <fun>
val sum_of_the_first_consecutive_odd_natural_numbers_gen : int -> int = <fun>
val end_of_file : string = "midterm-project_miscellany.ml"
#  
*)
