(* oral-exam.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Shuna Maekawa shuna@u.yale-nus.edu.sg *)
(* Version of Thu 28 Apr 2022 *)

(* unit-test function *)

let test_list_appendp_int candidate =
  (* element of zero *) 
  let b0 = (candidate [] [10; 20] [10; 20] = true)
  and b1 = (candidate [0] [10; 20] [0; 10; 20] = true)
  and b2 = (candidate [1; 0] [10; 20] [1; 0; 10; 20] = true)
  and b3 = (candidate [2; 1; 0] [10; 20] [2; 1; 0; 10; 20] = true)
  and b1n = (candidate [] [10; 20] [] = false)
  and b2n = (candidate [0] [10; 20] [10; 20; 0] = false)
  in  b0 && b1 && b2 && b3 && b1n && b2n;;
(* ********** *)

(* simple implementation*)
let list_appendp v1s v2s v3s =
  List.append v1s v2s = v3s;;

let () = assert(test_list_appendp_int  list_appendp)
(*it passes the unit test*)

(*recursive implementation*)
let list_appendp v1s v2s v3s =
  let rec visit v1s v3s =
    match v1s with
    | [] ->
       v2s =  v3s
    | v1 :: v1s' ->
       (match v3s with
        | [] ->
           false
        |v3 :: v3s' ->
          (v3 = v1) && visit v1s' v3s')       
  in visit v1s v3s;;  

(* test the implementation *)
let () = assert(test_list_appendp_int list_appendp);;
         
let end_of_file = "oral-exam.ml";;

(*
        OCaml version 4.10.0

# #use "oral-exam.ml";;
val test_list_appendp_int :
  (int list -> int list -> int list -> bool) -> bool = <fun>
val list_appendp : 'a list -> 'a list -> 'a list -> bool = <fun>
val list_appendp : 'a list -> 'a list -> 'a list -> bool = <fun>
val end_of_file : string = "oral-exam.ml"
# 
 *)
