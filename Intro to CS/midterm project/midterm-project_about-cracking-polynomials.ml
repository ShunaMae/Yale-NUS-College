(* midterm-project_about-cracking-polynomials.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Fri 04 Mar 2022, using a power function and with some food for thought *)
(* was: *)
(* Version of Sun 27 Feb 2022 *)

(* ********** *)

(* name of the group:SJANN
*)

(* ********** *)

let commiseration = [|"Bummer:";
                      "Bad luck:";
                      "More bad luck:";
                      "Trouble ahead:";
                      "Commiseration city, that's what it is:";
                      "Yes, it's hard to believe, but";
                      "There we go again:";
                      "Truth be told,";
                      "Now that's bizarre:";
                      "Once again,";
                      "Well,";
                      "Unfortunately,";
                      "Argh:";
                      "The proof is not trivial:";
                      "Something is amiss:";
                      "Surprise:";
                      "You need a break:";
                      "I don't want to alarm you, but";
                      "You probably would prefer to receive a random love letter, but";
                      "This is not a pipe dream:";
                    |];;

let random_int () =
  if Random.bool ()
  then Random.int 1000
  else -(Random.int 1000);;

(* ********** *)

let power x n =
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then 1
    else x * visit (pred i)
  in visit n;;

let make_polynomial_0 a0 x =
  a0 * power x 0;;

let make_polynomial_1 a1 a0 x =
  a1 * power x 1 + a0 * power x 0;;

let make_polynomial_2 a2 a1 a0 x =
  a2 * power x 2 + a1 * power x 1 + a0 * power x 0;;

let make_polynomial_3 a3 a2 a1 a0 x =
  a3 * power x 3 + a2 * power x 2 + a1 * power x 1 + a0 * power x 0;;


(* ********** *)

(* First degree: *)

let first_degree = "mandatory";;

let test_crack_1_once candidate =
  let a1 = random_int ()
  and a0 = random_int ()
  in let p1 = make_polynomial_1 a1 a0
     in let expected_result = (a1, a0)
        and ((a1', a0') as actual_result) = candidate p1
        in if actual_result = expected_result
           then true
           else let () = Printf.printf
                           "%s\ntest_crack_1_once failed for %i * x^1 + %i\nwith %i instead of %i and %i instead of %i\n"
                           (Array.get commiseration (Random.int (Array.length commiseration)))
                           a1 a0 a1' a1 a0' a0
                in false;;

let test_crack_1 candidate =
  test_crack_1_once candidate && test_crack_1_once candidate && test_crack_1_once candidate;;

(* ***** *)

let crack_1 p =
  let p_0 = p 0
  and p_1 = p 1
  in let a0 = p_0
     and a1 = p_1 - p_0
     in (a1, a0);;

let () = assert (test_crack_1 crack_1);;

(* ********** *)

(* Second degree: *)

let second_degree = "mandatory";;

let test_crack_2_once candidate =
  let a2 = random_int ()
  and a1 = random_int ()
  and a0 = random_int ()
  in let p2 = make_polynomial_2 a2 a1 a0
     in let expected_result = (a2, a1, a0)
        and ((a2', a1', a0') as actual_result) = candidate p2
        in if actual_result = expected_result
           then true
           else let () = Printf.printf
                           "%s\ntest_crack_2_once failed for %i * x^2 + %i * x^1 + %i\nwith %i instead of %i, %i instead of %i, and %i instead of %i\n"
                           (Array.get commiseration (Random.int (Array.length commiseration)))
                           a2 a1 a0 a2' a2 a1' a1 a0' a0
                in false;;

let test_crack_2 candidate =
  test_crack_2_once candidate && test_crack_2_once candidate && test_crack_2_once candidate;;

(* ***** *)

let crack_2 p =
  let p_0 =  p 0
  and p_1 =  p 1
  and p_m1 = p (-1)
  in let a0 = p_0
     and a2_plus_a1 = p_1 - p_0 
     and a2_minus_a1 = p_m1 - p_0
     in let a2 = (a2_plus_a1 + a2_minus_a1) / 2
        in let a1 = a2_plus_a1 - a2
           in (a2,a1,a0);;

let () = assert (test_crack_2 crack_2);;

(* Can crack_2 be used to implement crack_!?*)

let crack_1_alt p = 
  let (a2, a1, a0) = crack_2 p 
  in (a1, a0);;

let () = assert (test_crack_1 crack_1_alt);;


(* ********** *)

(* Zeroth degree: *)

let zeroth_degre = "mandatory";;

let test_crack_0_once candidate =
  let a0 = random_int ()
  in let p0 = make_polynomial_0 a0
     in let expected_result = a0
        and (a0' as actual_result) = candidate p0
        in if actual_result = expected_result
           then true
           else let () = Printf.printf
                           "%s\ntest_crack_0_once failed for %i\nwith %i instead of %i\n"
                           (Array.get commiseration (Random.int (Array.length commiseration)))
                           a0 a0' a0'
                in false;;

let test_crack_0 candidate =
  test_crack_0_once candidate && test_crack_0_once candidate && test_crack_0_once candidate;;


(* Substituting zero *)
let crack_0a p = p 0;;

let () = assert (test_crack_0 crack_0a);; 

(* Using crack_2* *)

let crack_0b p =
  let (a2, a1, a0) = crack_2 p
  in a0;;

let () = assert (test_crack_0 crack_0b);;

(* Using crack_1 *)

let crack_0c p =
  let (a1, a0) = crack_1 p
  in a0;;

let () = assert (test_crack_0 crack_0c);;

(* ********** *)

(* Third degree: *)

let third_degree = "mandatory";;

let test_crack_3_once candidate =
  let a3 = random_int ()
  and a2 = random_int ()
  and a1 = random_int ()
  and a0 = random_int ()
  in let p3 = make_polynomial_3 a3 a2 a1 a0
     in let expected_result = (a3, a2, a1, a0)
        and ((a3', a2', a1', a0') as actual_result) = candidate p3
        in if actual_result = expected_result
           then true
           else let () = Printf.printf
                           "%s\ntest_crack_3_once failed for %i * x^3 + %i * x^2 + %i * x^1 + %i\nwith %i instead of %i, %i instead of %i, %i instead of %i, and %i instead of %i\n"
                           (Array.get commiseration (Random.int (Array.length commiseration)))
                           a3 a2 a1 a0 a3' a3 a2' a2 a1' a1 a0' a0
                in false;;

let test_crack_3 candidate =
  test_crack_3_once candidate && test_crack_3_once candidate && test_crack_3_once candidate;;

(* ***** *)

let crack_3 p =
  let p_0 = p 0
  and p_1 = p 1
  and p_2 = p 2
  and p_m1 = p (-1)
  in let a0 = p_0
     and a2 = (p_1 + p_m1 - (p_0 * 2)) / 2
     in let a3 = (p_2 - (2 * a2) + a0 - (2 * p_1)) / 6
        in let a1 = p_1 - a0 - a2 - a3
           in (a3, a2, a1, a0);;
 

let () = assert (test_crack_3 crack_3);;

(* Can crack_3 be used to implement crack_2? *)
let crack_2_alt_v1 p = 
  let (a3, a2, a1, a0) =  crack_3 p
  in (a2, a1, a0) 

let () = assert (test_crack_2 crack_2_alt_v1)

(* Can crack_3 be used to implement crack_1?*)
let crack_1_alt_v2 p  = 
  let (a3, a2, a1, a0) = crack_3 p
  in (a1, a0) 

let () = assert (test_crack_1 crack_1_alt_v2)

(* Can crack_3 be used to implement crack_0? *)
let crack_0d p =
  let (a3, a2, a1, a0) = crack_3 p
  in a0

let () = assert (test_crack_0 crack_0d)

(* ********** *)

(* Fourth Degree:*)

let fourth_degree = "mandatory";;

let make_polynomial_4 a4 a3 a2 a1 a0 x = 
  a4 * power x 4 + a3 * power x 3 + a2 * power x 2 + a1 * power x 1 + a0 * power x 0;;


let test_crack_4_once candidate = 
  let a4 = random_int ()
  and a3 = random_int ()
  and a2 = random_int ()
  and a1 = random_int ()
  and a0 = random_int ()
  in let p4 = make_polynomial_4 a4 a3 a2 a1 a0
     in let expected_result = (a4, a3, a2, a1, a0) 
        and ((a4', a3', a2', a1', a0') as actual_result) = candidate p4
        in if actual_result = expected_result
           then true 
           else let () = Printf.printf
                            "test_crack_4_once failed for %i * x^4 + %i * x^3 + %i * x^2 + %i * x^1 + %i with (%i, %i, %i, %i, %i)\n"
                            a4 a3 a2 a1 a0 a4' a3' a2' a1' a0'
                in false;;

let test_crack_4  candidate =
  test_crack_4_once candidate && test_crack_4_once candidate && test_crack_4_once candidate;;

let crack_4 p = 
  let p_0 = p 0
  and p_1 = p 1
  and p_m1 = p (-1)
  and p_2 = p 2
  and p_m2 = p (-2)
  in let a0 = p_0
     and a3 = (p_2 - p_m2 - (2 * p_1) + (2 * p_m1)) / 12
     and a1 = ((8 * p_1) - (8 * p_m1) - p_2 + p_m2) / 12
     in let a4 = (p_2 - (4 * p_1) - (4 * a3) + (2 * a1) + (3 * a0)) / 12
        in let a2 = p_1 - a4 - a3 - a1 - a0
           in (a4,a3,a2,a1,a0);;

let () = assert (test_crack_4 crack_4);;

let end_of_file = "midterm-project_about-cracking-polynomials.ml";;

(*
        OCaml version 4.01.0

# #use "midterm-project_about-cracking-polynomials.ml";;
val commiseration : string array =
 [|"Bummer:"; "Bad luck:"; "More bad luck:"; "Trouble ahead:";
   "Commiseration city, that's what it is:";
   "Yes, it's hard to believe, but"; "There we go again:"; "Truth be told,";
   "Now that's bizarre:"; "Once again,"; "Well,"; "Unfortunately,"; "Argh:";
   "The proof is not trivial:"; "Something is amiss:"; "Surprise:";
   "You need a break:"; "I don't want to alarm you, but";
   "You probably would prefer to receive a random love letter, but";
   "This is not a pipe dream:"|]
val random_int : unit -> int = <fun>
val power : int -> int -> int = <fun>
val make_polynomial_0 : int -> int -> int = <fun>
val make_polynomial_1 : int -> int -> int -> int = <fun>
val make_polynomial_2 : int -> int -> int -> int -> int = <fun>
val make_polynomial_3 : int -> int -> int -> int -> int -> int = <fun>
val first_degree : string = "mandatory"
val test_crack_1_once : ((int -> int) -> int * int) -> bool = <fun>
val test_crack_1 : ((int -> int) -> int * int) -> bool = <fun>
val crack_1 : (int -> int) -> int * int = <fun>
val second_degree : string = "mandatory"
val test_crack_2_once : ((int -> int) -> int * int * int) -> bool = <fun>
val test_crack_2 : ((int -> int) -> int * int * int) -> bool = <fun>
val crack_2 : (int -> int) -> int * int * int = <fun>
val crack_1_alt : (int -> int) -> int * int = <fun>
val zeroth_degre : string = "mandatory"
val test_crack_0_once : ((int -> int) -> int) -> bool = <fun>
val test_crack_0 : ((int -> int) -> int) -> bool = <fun>
val crack_0a : (int -> 'a) -> 'a = <fun>
val crack_0b : (int -> int) -> int = <fun>
val crack_0c : (int -> int) -> int = <fun>
val third_degree : string = "mandatory"
val test_crack_3_once : ((int -> int) -> int * int * int * int) -> bool = <fun>
val test_crack_3 : ((int -> int) -> int * int * int * int) -> bool = <fun>
val crack_3 : (int -> int) -> int * int * int * int = <fun>
val crack_2_alt_v1 : (int -> int) -> int * int * int = <fun>
val crack_1_alt_v2 : (int -> int) -> int * int = <fun>
val crack_0d : (int -> int) -> int = <fun>
val fourth_degree : string = "mandatory"
val make_polynomial_4 : int -> int -> int -> int -> int -> int -> int = <fun>
val test_crack_4_once : ((int -> int) -> int * int * int * int * int) -> bool = <fun>
val test_crack_4 : ((int -> int) -> int * int * int * int * int) -> bool = <fun>
val crack_4 : (int -> int) -> int * int * int * int * int = <fun>
val end_of_file : string = "midterm-project_about-cracking-polynomials.ml"
# 
*)
