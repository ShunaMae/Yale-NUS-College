(* week-13_annotate.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sun 17 Apr 2022 *)

(* ********** *)

let test_fac (candidate : int -> int) : bool =
  let (b0 : bool) = (candidate 0 = 1)
  and (b1 : bool) = (candidate 1 = 1)
  and (b2 : bool) = (candidate 2 = 2)
  and (b3 : bool) = (candidate 3 = 6)
  and (b4 : bool) = (candidate 4 = 24)
  and (b5 : bool) = (let (n : int) = Random.int 15
            in candidate (succ n)
               = succ n * candidate n)
  in b0 && b1 && b2 && b3 && b4 && b5;;

let fac (n : int) : int =
  assert (n >= 0);
  let rec visit (i : int) : int =
    if i = 0
    then 1
    else i * visit (pred i)
  in visit n;;

let () = (assert (test_fac fac) : unit);;

(* ********** *)

let test_show_int (candidate : int -> string) : bool =
  let (b0 : bool) = (candidate 0 = "0")
  and (b1 : bool) = (candidate 123 = "123")
  and (b2 : bool) = (candidate (-123) = "(-123)")
  in b0 && b1 && b2;;

let show_int (n : int) : string =
  if n < 0
  then (("(" ^ string_of_int n ^ ")") : string)
  else string_of_int n;;

let () = (assert (test_show_int show_int) : unit);;

(* ***** *)

let test_show_pair (candidate : ((int -> string) -> (int -> string) -> int * int -> string)) : bool =
  (candidate show_int show_int (1, -1) = "(1, (-1))");;

let show_pair (show_v1 : 'a -> string) (show_v2 : 'b -> string) ((v1, v2) : 'a * 'b) : string =
  "(" ^ (show_v1 v1) ^ ", " ^ (show_v2 v2) ^ ")";;

let (() : unit) = assert (test_show_pair show_pair);;

(* ********** *)

let nat_fold_right (zero_case : 'a) (succ_case : 'a -> 'a) (n : int) : 'a =
  assert (n >= 0);
  let rec visit (i : int) : 'a =
    if i = 0
    then zero_case
    else succ_case (visit (pred i))    (* <-- succ_case takes one argument *)
  in visit n;;

let nat_parafold_right (zero_case : 'a) (succ_case : int -> 'a -> 'a) (n : int) : 'a =
  assert (n >= 0);
  let rec visit (i : int) : 'a =
    if i = 0
    then zero_case
    else let i' = pred i
         in succ_case i' (visit i')    (* <-- succ_case takes two arguments *)
  in visit n;;

(* ********** *)

let test_evenp_and_oddp (evenp_candidate : int -> bool) (oddp_candidate : int -> bool) : bool =
  let (b0 : bool) = (evenp_candidate 0 = true)
  and (b1 : bool) = (oddp_candidate 0 = false)
  and (b2 : bool) = (let (n' : int) = Random.int 1000
            in evenp_candidate (succ n') = oddp_candidate n')
  and (b3 : bool) = (let n' = Random.int 1000
            in oddp_candidate (succ n') = evenp_candidate n')
  in b0 && b1 && b2 && b3;;

let ((evenp : int -> bool), (oddp : int -> bool)) =
  let rec evenp_aux (n : int) : bool =
    if n = 0
    then true
    else oddp_aux (pred n)
  and oddp_aux n =
    if n = 0
    then false
    else evenp_aux (pred n)
  in ((fun n ->
        assert (n >= 0);
        evenp_aux n),
      (fun n ->
        assert (n >= 0);
        oddp_aux n));;

let (() : unit) = assert (test_evenp_and_oddp evenp oddp);;

(* ********** *)

let test_list_map_int (candidate : ((int -> int) -> int list -> int list)) : bool =
  let f = (fun (n : int) -> 10 * n)
  and (ns : int list) = List.init (Random.int 20) (fun _ -> if Random.bool () then Random.int 100 else - (Random.int 100))
  in candidate f ns = List.map f ns;;

let list_map (f : 'a -> 'b) (xs_given : 'a list) : 'b list =
  let rec visit (xs : 'a list) : 'b list=
    match xs with
    | [] ->
       []
    | x :: xs' ->
       f x :: visit xs'
  in visit xs_given;;

let () = (assert (test_list_map_int list_map) : unit);;

(* ********** *)

let test_list_reverse_int (candidate : int list -> int list) : bool =
  let (b0 : bool) = (candidate [] = [])
  and (b1 : bool) = (candidate [0] = [0])
  and (b2 : bool) = (candidate [1; 0] = [0; 1])
  and (b3 : bool) = (candidate [2; 1; 0] = [0; 1; 2])
  and (b4 : bool) = (let (ns : int list) = List.init (Random.int 20) (fun _ -> if Random.bool () then Random.int 100 else - (Random.int 100))
            in candidate (candidate ns) = ns)
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4;;

let list_reverse (vs_given : 'a list) : 'a list =
  let rec visit (vs : 'a list) (a : 'a list) : 'a list =
    match vs with
    | [] ->
       a
    | v :: vs' ->
       visit vs' (v :: a)
  in visit vs_given [];;

let () = (assert (test_list_reverse_int list_reverse) : unit);;

(* ********** *)

let end_of_file = "week-13_annotate.ml";;

(*
        OCaml version 4.10.0

# #use "week-13_annotate.ml";;
val test_fac : (int -> int) -> bool = <fun>
val fac : int -> int = <fun>
val test_show_int : (int -> string) -> bool = <fun>
val show_int : int -> string = <fun>
val test_show_pair :
  ((int -> string) -> (int -> string) -> int * int -> string) -> bool = <fun>
val show_pair : ('a -> string) -> ('b -> string) -> 'a * 'b -> string = <fun>
val nat_fold_right : 'a -> ('a -> 'a) -> int -> 'a = <fun>
val nat_parafold_right : 'a -> (int -> 'a -> 'a) -> int -> 'a = <fun>
val test_evenp_and_oddp : (int -> bool) -> (int -> bool) -> bool = <fun>
val evenp : int -> bool = <fun>
val oddp : int -> bool = <fun>
val test_list_map_int : ((int -> int) -> int list -> int list) -> bool =
  <fun>
val list_map : ('a -> 'b) -> 'a list -> 'b list = <fun>
val test_list_reverse_int : (int list -> int list) -> bool = <fun>
val list_reverse : 'a list -> 'a list = <fun>
val end_of_file : string = "week-13_annotate.ml"
# 
 *)
