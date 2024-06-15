(* week-08_list-map.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 12 Mar 2022 *)

(* ********** *)

let test_list_map_succ candidate =
      (* an instance of the base case: *)
  let bc = (candidate [] = [])
      (* a few handpicked lists: *)
  and b1 = (candidate [0] = [1])
  and b2 = (candidate [1; 0] = [2; 1])
  and b3 = (candidate [2; 1; 0] = [3; 2; 1])
  and b4 = (candidate [3; 2; 1; 0] = [4; 3; 2; 1])
      (* an instance of the induction step: *)
  and is = (let n = 4
            and ns' = [3; 2; 1; 0]
            in let ih = candidate ns'
               in candidate (n :: ns') = succ n :: ih)
  (* etc. *)
  in bc && b1 && b2 && b3 && b4 && is;;

(* ***** *)

let list_map_succ_v0 ns_given =
  let rec visit ns =
    match ns with
    | [] ->
       []
    | n :: ns' ->
       let ih = visit ns'
       in succ n :: ih
  in visit ns_given;;

let () = assert (test_list_map_succ list_map_succ_v0);;

(* ***** *)

let list_map_succ_v1 ns_given =
  let rec visit ns =
    match ns with
    | [] ->
       []
    | n :: ns' ->
       succ n :: visit ns'
  in visit ns_given;;

let () = assert (test_list_map_succ list_map_succ_v1);;

(* ********** *)

let test_list_map_pred candidate =
      (* an instance of the base case: *)
  let bc = (candidate [] = [])
      (* a few handpicked lists: *)
  and b1 = (candidate [1] = [0])
  and b2 = (candidate [2; 1] = [1; 0])
  and b3 = (candidate [3; 2; 1] = [2; 1; 0])
  and b4 = (candidate [4; 3; 2; 1] = [3; 2; 1; 0])
      (* an instance of the induction step: *)
  and is = (let n = 5
            and ns' = [4; 3; 2; 1]
            in let ih = candidate ns'
               in candidate (n :: ns') = pred n :: ih)
  (* etc. *)
  in bc && b1 && b2 && b3 && b4 && is;;

(* ***** *)

let list_map_pred_v0 ns_given =
  let rec visit ns =
    match ns with
    | [] ->
       []
    | n :: ns' ->
       let ih = visit ns'
       in pred n :: ih
  in visit ns_given;;

let () = assert (test_list_map_pred list_map_pred_v0);;

(* ***** *)

let list_map_pred_v1 ns_given =
  let rec visit ns =
    match ns with
    | [] ->
       []
    | n :: ns' ->
       pred n :: visit ns'
  in visit ns_given;;

let () = assert (test_list_map_pred list_map_pred_v1);;

(* ********** *)

let test_list_map_square candidate =
  (candidate [3; 2; 1] = [9; 4; 1])
  (* etc. *);;

let square n =
  n * n;;

(* ***** *)

let list_map_square_v0 ns_given =
  let rec visit ns =
    match ns with
    | [] ->
       []
    | n :: ns' ->
       let ih = visit ns'
       in square n :: ih
  in visit ns_given;;

let () = assert (test_list_map_square list_map_square_v0);;

(* ***** *)

let list_map_square_v1 ns_given =
  let rec visit ns =
    match ns with
    | [] ->
       []
    | n :: ns' ->
       square n :: visit ns'
  in visit ns_given;;

let () = assert (test_list_map_square list_map_square_v1);;

(* ********** *)

let test_list_map_singleton_int candidate =
  (candidate [3; 2; 1] = [[3]; [2]; [1]])
  (* etc. *);;

(* ***** *)

let singleton x =
  [x];;

let list_map_singleton_v0 xs_given =
  let rec visit xs =
    match xs with
    | [] ->
       []
    | x :: xs' ->
       let ih = visit xs'
       in singleton x :: ih
  in visit xs_given;;

let () = assert (test_list_map_singleton_int list_map_singleton_v0);;

(* ***** *)

let list_map_singleton_v1 xs_given =
  let rec visit xs =
    match xs with
    | [] ->
       []
    | x :: xs' ->
       singleton x :: visit xs'
  in visit xs_given;;

let () = assert (test_list_map_singleton_int list_map_singleton_v1);;

(* ********** *)

let list_map_v0 f xs_given =
 (* list_map : ('a -> 'b) -> 'a list -> 'b list *)
  let rec visit xs =
    match xs with
    | [] ->
       []
    | x :: xs' ->
       let ih = visit xs'
       in f x :: ih
  in visit xs_given;;

let () = assert (test_list_map_succ (list_map_v0 succ));;
let () = assert (test_list_map_pred (list_map_v0 pred));;
let () = assert (test_list_map_square (list_map_v0 square));;
let () = assert (test_list_map_singleton_int (list_map_v0 (fun n -> [n])));;

(* ***** *)

let list_map f xs_given =
  (* list_map : ('a -> 'b) -> 'a list -> 'b list *)
  let rec visit xs =
    match xs with
    | [] ->
       []
    | x :: xs' ->
       let ih = visit xs'
       in f x :: ih
  in visit xs_given;;

let () = assert (test_list_map_succ (list_map succ));;
let () = assert (test_list_map_pred (list_map pred));;
let () = assert (test_list_map_square (list_map square));;
let () = assert (test_list_map_singleton_int (list_map (fun n -> [n])));;

(* ***** *)

let () = assert (test_list_map_succ (List.map succ));;
let () = assert (test_list_map_pred (List.map pred));;
let () = assert (test_list_map_square (List.map square));;
let () = assert (test_list_map_singleton_int (List.map (fun n -> [n])));;

(* ********** *)

let list_andmap p xs_given =
  (* list_andmap : ('a -> bool) -> 'a list -> bool *)
  let rec visit xs =
    match xs with
    | [] ->
       true
    | x :: xs' ->
       p x && visit xs'
  in visit xs_given;;

let list_andmap_tail_sensitive p xs_given =
  (* list_andmap_tail_sensitive : ('a -> bool) -> 'a list -> bool *)
  match xs_given with
  | [] ->
     true
  | x :: xs' ->
     let rec visit x xs =
       match xs with
       | [] ->
          p x
       | x' :: xs' ->
          p x && visit x' xs'
     in visit x xs';;

(* ***** *)

let list_ormap p xs_given =
  (* list_ormap : ('a -> bool) -> 'a list -> bool *)
  let rec visit xs =
    match xs with
    | [] ->
       false
    | x :: xs' ->
       p x || visit xs'
  in visit xs_given;;

let list_ormap_tail_sensitive p xs_given =
  (* list_ormap_tail_sensitive : ('a -> bool) -> 'a list -> bool *)
  match xs_given with
  | [] ->
     true
  | x :: xs' ->
     let rec visit x xs =
       match xs with
       | [] ->
          p x
       | x' :: xs' ->
          p x || visit x' xs'
     in visit x xs';;

(* ********** *)

let end_of_file = "week-08_list-map.ml";;

(* 
           OCaml version 4.01.0
   
   # #use "anterior-lists.ml";;
   ...
   # #use "week-08_list-map.ml";;
   val test_list_map_succ : (int list -> int list) -> bool = <fun>
   val list_map_succ_v0 : int list -> int list = <fun>
   val list_map_succ_v1 : int list -> int list = <fun>
   val test_list_map_pred : (int list -> int list) -> bool = <fun>
   val list_map_pred_v0 : int list -> int list = <fun>
   val list_map_pred_v1 : int list -> int list = <fun>
   val test_list_map_square : (int list -> int list) -> bool = <fun>
   val square : int -> int = <fun>
   val list_map_square_v0 : int list -> int list = <fun>
   val list_map_square_v1 : int list -> int list = <fun>
   val test_list_map_singleton_int : (int list -> int list list) -> bool = <fun>
   val singleton : 'a -> 'a list = <fun>
   val list_map_singleton_v0 : 'a list -> 'a list list = <fun>
   val list_map_singleton_v1 : 'a list -> 'a list list = <fun>
   val list_map_v0 : ('a -> 'b) -> 'a list -> 'b list = <fun>
   val list_map_v1 : ('a -> 'b) -> 'a list -> 'b list = <fun>
   val list_andmap : ('a -> bool) -> 'a list -> bool = <fun>
   val list_andmap_tail_sensitive : ('a -> bool) -> 'a list -> bool = <fun>
   val list_ormap : ('a -> bool) -> 'a list -> bool = <fun>
   val list_ormap_tail_sensitive : ('a -> bool) -> 'a list -> bool = <fun>
   val end_of_file : string = "week-08_list-map.ml"
   # 
*)
