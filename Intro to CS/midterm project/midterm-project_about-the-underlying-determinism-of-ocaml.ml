(* midterm-project_about-the-underlying-determinism-of-ocaml.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Thu 03 Mar 2022, with a_char fixed *)
(* was: *)
(* Version of Sun 27 Feb 2022 *)

(* ********** *)

(* name of the group: SJANN
*)

(* ********** *)

let an_int n =
 (* an_int : int -> int *)
  let () = Printf.printf "processing %d...\n" n
  in n;;

let a_bool b =
 (* a_bool : bool -> bool *)
  let () = Printf.printf "processing %B...\n" b
  in b;;

let a_char c =
 (* a_char : char -> char *)
  let () = Printf.printf "processing '%c'...\n" c
  in c;;

let a_string s =
 (* a_string : string -> string *)
  let () = Printf.printf "processing \"%s\"...\n" s
  in s;;

let a_unit () =
 (* a_unit : unit -> unit *)
  let () = Printf.printf "processing the unit value...\n"
  in ();;

let a_function f =
 (* a_function : ('a -> 'b) -> 'a -> 'b *)
  let () = Printf.printf "processing a function...\n"
  in fun x -> f x;;

(* ********** *)
(* Question 2 *)
(* Are a function's sub expressions evaluated from left to right or right to left? The answer is right to left. *)
(* let int_add_one_param = a_function Int.add (an_int 3);;

let int_add_two_param =  Int.add (an_int 3) (an_int 4);; *)



(* Question 3 *)
(* Order in which tuple is evaluated, from right to left *)
(* let traced_tuple = (an_int 1, an_int 12, an_int 17);; *)



(* Question 6 *)
(* Multiple definiens of a let expression. The trace shows that OCaml evaluates definienses from left to right. *) 
(* let x = (an_int 10) and y = an_int(100) in x + y;; *)



(* Question 7 *)
(* Example showing that both expressions are not equivalent *)
(* let x = (an_int 1) and y = (an_int 2) in x + y;;

let y = (fun (x, y) -> x + y) (an_int 1, an_int 2);; *)


(* Question 8 *)
(* Boolean conjunction: left to right *)
(* a_bool (a_bool true && a_bool false);; 

a_bool (a_bool false && a_bool true);;

a_bool (a_bool true && a_bool true);;

a_bool (a_bool false && a_bool false);; *)



(* Question 9 *)
(* Sub-question 2: No, because impure expressions can yield side effects. This example compares the top expression with 0. The trace of the top expression shows that it is not equivalent to 0. *)
(* (an_int 5) * 0;; 
0;; *)



(* Question 10 *)
(* Part a: No Running both expressions demonstrates that the traces are different. *)
(* let x1 = an_int 3 and x2 = an_int 4 in (x1, x2);;
let x2 = an_int 4 and x1 = an_int 3 in (x1,x2);; *)

(* Part b: No. Running both expressions demonstrates that the traces are different. *)
(* let x1 = an_int 1 in let x2 = an_int 2 in (x1,x2);; *)
(* let x2 = an_int 2 in let x1 = an_int 1 in (x1,x2);; *)



(* Question 12 *)
(* Non-strict function with non-terminating parameter. The parameter is a recursive function that calls itself without terminating. For this reason, the function is commented out. Use C-c C-c to interrupt *)
(* (fun _ -> 42) (let rec foo = fun m -> foo m
					  in foo 1);; *)



     (*   OCaml version 4.12.0

# #use "midterm-project_about-the-underlying-determinism-of-ocaml.ml";;
val an_int : int -> int = <fun>
val a_bool : bool -> bool = <fun>
val a_char : char -> char = <fun>
val a_string : string -> string = <fun>
val a_unit : unit -> unit = <fun>
val a_function : ('a -> 'b) -> 'a -> 'b = <fun>
val end_of_file : string =
  "midterm-project_about-the-underlying-determinism-of-ocaml.ml"
# *)



let end_of_file = "midterm-project_about-the-underlying-determinism-of-ocaml.ml";;
