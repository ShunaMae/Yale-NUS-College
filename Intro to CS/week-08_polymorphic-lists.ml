(* week-08_polymorphic-lists.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 12 Mar 2022 *)
(* Version of Thu 07 Apr 2022, with the definition of list_length_v3 *)
(* was: *)
(* Version of Sat 12 Mar 2022 *)

(* ********** *)

let indent indentation =
  String.make (2 * indentation) ' ';;

(* ********** *)

let show_int n =
 (* show_int : int -> string *)
  if n < 0
  then "~" ^ string_of_int n
  else string_of_int n;;

let show_bool b =
 (* show_bool : bool -> string *)
  if b
  then "true"
  else "false";;

let show_char c =
 (* show_char : char -> string *)
  "'" ^ String.make 1 c ^ "'";;

let show_string s =
 (* show_string : string -> string *)
  "\"" ^ s ^ "\"";;

(* ********** *)

let show_pair show_a show_b (a, b) =
 (* show_pair : ('a -> string) -> ('b -> string) -> 'a * 'b -> string *)
  "(" ^ show_a a ^ ", " ^ show_b b ^ ")";;

(* ********** *)

let test_show_int_list candidate =
  let b0 = (candidate []
            = "[]")
  and b1 = (candidate [0]
            = "0 :: []")
  and b2 = (candidate [1; 0]
            = "1 :: 0 :: []")
  and b3 = (candidate [2; 1; 0]
            = "2 :: 1 :: 0 :: []")
  and b4 = (candidate [~-2; ~-1; 0]
            = "~-2 :: ~-1 :: 0 :: []")
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4;;

let test_show_bool_list candidate =
  let b0 = (candidate []
            = "[]")
  and b1 = (candidate [false]
            = "false :: []")
  and b2 = (candidate [true; false]
            = "true :: false :: []")
  and b3 = (candidate [true; true; false]
            = "true :: true :: false :: []")
  (* etc. *)
  in b0 && b1 && b2 && b3;;
           
let test_show_int_list_list candidate =
  let b0 = (candidate [[]]
            = "[] :: []")
  and b1 = (candidate [[0]]
            = "(0 :: []) :: []")
  and b2 = (candidate [[1; 0]; [0]]
            = "(1 :: 0 :: []) :: (0 :: []) :: []")
  and b3 = (candidate [[2; 1; 0]; [1; 0]; [0]]
            = "(2 :: 1 :: 0 :: []) :: (1 :: 0 :: []) :: (0 :: []) :: []")
  and b4 = (candidate [[3; 2; 1; 0]; [2; 1; 0]; [1; 0]; [0]]
            = "(3 :: 2 :: 1 :: 0 :: []) :: (2 :: 1 :: 0 :: []) :: (1 :: 0 :: []) :: (0 :: []) :: []")
  and b5 = (candidate [[~-2; ~-1; 0]; [3; 2; 1; 0]; [2; 1; 0]; [1; 0]; [0]]
            = "(~-2 :: ~-1 :: 0 :: []) :: (3 :: 2 :: 1 :: 0 :: []) :: (2 :: 1 :: 0 :: []) :: (1 :: 0 :: []) :: (0 :: []) :: []")
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5;;

(* ***** *)

let show_list show_v vs_given =
  let rec show_list_aux vs =
    if vs = []
    then "[]"
    else let v = List.hd vs
         and vs' = List.tl vs
         in let uvs' = show_list_aux vs'
            in (show_v v) ^ " :: " ^ uvs'
  in show_list_aux vs_given;;

let () = assert (test_show_int_list (show_list show_int));;

let () = assert (test_show_bool_list (show_list show_bool));;

let () = assert (test_show_int_list_list (show_list (show_list show_int)) = false);;

(* ***** *)

let show_listp show_v vs =
  if vs = []
  then "[]"
  else "(" ^ show_list show_v vs ^ ")";;

let () = assert (test_show_int_list_list (show_list (show_listp show_int)));;

(* ********** *)

(* A more practical version that emits "[ ... ]" rather than "... :: ... :: []": *)

let test_show_int_list candidate =
  let b0 = (candidate []
            = "[]")
  and b1 = (candidate [0]
            = "[0]")
  and b2 = (candidate [1; 0]
            = "[1; 0]")
  and b3 = (candidate [2; 1; 0]
            = "[2; 1; 0]")
  and b4 = (candidate [~-2; ~-1; 0]
            = "[~-2; ~-1; 0]")
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4;;

let test_show_bool_list candidate =
  let b0 = (candidate []
            = "[]")
  and b1 = (candidate [false]
            = "[false]")
  and b2 = (candidate [true; false]
            = "[true; false]")
  and b3 = (candidate [true; true; false]
            = "[true; true; false]")
  (* etc. *)
  in b0 && b1 && b2 && b3;;  

let test_show_int_list_list candidate =
  let b0 = (candidate [[]]
            = "[[]]")
  and b1 = (candidate [[0]]
            = "[[0]]")
  and b2 = (candidate [[1; 0]; [0]]
            = "[[1; 0]; [0]]")
  and b3 = (candidate [[2; 1; 0]; [1; 0]; [0]]
            = "[[2; 1; 0]; [1; 0]; [0]]")
  and b4 = (candidate [[3; 2; 1; 0]; [2; 1; 0]; [1; 0]; [0]]
            = "[[3; 2; 1; 0]; [2; 1; 0]; [1; 0]; [0]]")
  and b5 = (candidate [[~-2; ~-1; 0]; [3; 2; 1; 0]; [2; 1; 0]; [1; 0]; [0]]
            = "[[~-2; ~-1; 0]; [3; 2; 1; 0]; [2; 1; 0]; [1; 0]; [0]]")
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5;;

let show_list show_v vs_given =
  if vs_given = []
  then "[]"
  else let v = List.hd vs_given
       and vs' = List.tl vs_given
       in let rec show_list_aux vs v =
            if vs = []
            then show_v v
            else let v' = List.hd vs
                 and vs' = List.tl vs
                 in let uvs' = show_list_aux vs' v'
                    in (show_v v) ^ "; " ^ uvs'
          in "[" ^ (show_list_aux vs' v) ^ "]";;

let () = assert (test_show_int_list (show_list show_int));;

let () = assert (test_show_bool_list (show_list show_bool));;

let () = assert (test_show_int_list_list (show_list (show_list show_int)));;

(* ********** *)

let test_atoi candidate =
      (* base case: *)
  let bc = (candidate 0 = [])
      (* instance of the induction step: *)
  and is = (let n' = Random.int 10
            in candidate (succ n') = n' :: candidate n')
      (* a few handpicked numbers: *)
  and b1 = (candidate 1 = [0])
  and b2 = (candidate 2 = [1; 0])
  and b3 = (candidate 3 = [2; 1; 0])
  and b4 = (candidate 4 = [3; 2; 1; 0])
  (* etc. *)
  in bc && is && b1 && b2 && b3 && b4;;

(* ***** *)

let atoi_v0 n =
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then []
    else let i' = pred i
         in let ih = visit i'
            in i' :: ih
  in visit n;;

let () = assert (test_atoi atoi_v0);;

(* ***** *)

let traced_atoi_v0 n =
  let () = Printf.printf "atoi_v0 %d ->\n" n in
  let () = assert (n >= 0)
  in let rec visit i indentation =
       let () = Printf.printf "%svisit %d ->\n" (indent indentation) i in
       let result = if i = 0
                    then []
                    else let i' = pred i
                         in let ih = visit i' (indentation + 1)
                            in i' :: ih
       in let () = Printf.printf "%svisit %d <- %s\n" (indent indentation) i (show_list show_int result) in
          result
     in let final_result = visit n 1
        in let () = Printf.printf "atoi_v0 %d <- %s\n" n (show_list show_int final_result) in
           final_result;;

(* ********** *)

let test_list_length_int candidate =
      (* the base case: *)
  let bc = (candidate [] = 0)
      (* instance of the induction step: *)
  and is = (let n = Random.int 1000
            in let ns = atoi_v0 n
               in candidate (n :: ns) = succ (candidate ns))
      (* a few handpicked lists: *)
  and b1 = (1 = candidate [1])
  and b2 = (2 = candidate [2; 1])
  and b3 = (3 = candidate [3; 2; 1])
  and b4 = (4 = candidate [4; 3; 2; 1])
      (* a few automatically generated lists: *)
  and b5 = (candidate (atoi_v0 5) = 5)
  and b6 = (candidate (atoi_v0 10) = 10)
  and b7 = (candidate (atoi_v0 100) = 100)
  (* etc. *)
  in bc && is && b1 && b2 && b3 && b4 && b5 && b6 && b7;;

(* ***** *)

let list_length_v0 vs_given =
 (* list_length_v0 : 'a list -> int *)
  let rec visit vs =
    if vs = []
    then 0
    else let _ = List.hd vs
         and vs' = List.tl vs
         in let ih = visit vs'
            in succ ih
  in visit vs_given;;

let () = assert (test_list_length_int list_length_v0);;

(* ***** *)

let traced_list_length_v0 show_v vs_given =
 (* traced_list_length_v0 : ('a -> string) -> 'a list -> int *)
  let () = Printf.printf "list_length_v0 %s ->\n" (show_list show_v vs_given) in
  let rec visit vs indentation =
    let () = Printf.printf "%svisit %s ->\n" (indent indentation) (show_list show_v vs) in
    let result = if vs = []
                 then 0
                 else let _ = List.hd vs
                      and vs' = List.tl vs
                      in let ih = visit vs' (indentation + 1)
                         in succ ih
       in let () = Printf.printf "%svisit %s <- %d\n" (indent indentation) (show_list show_v vs) result in
          result
    in let final_result = visit vs_given 1
       in let () = Printf.printf "list_length_v0 %s <- %d\n" (show_list show_v vs_given) final_result in
          final_result;;

(*
   # traced_list_length_v0 show_int [1; 2; 3; 4; 5];;
   list_length_v0 [1; 2; 3; 4; 5] ->
     visit [1; 2; 3; 4; 5] ->
       visit [2; 3; 4; 5] ->
         visit [3; 4; 5] ->
           visit [4; 5] ->
             visit [5] ->
               visit [] ->
               visit [] <- 0
             visit [5] <- 1
           visit [4; 5] <- 2
         visit [3; 4; 5] <- 3
       visit [2; 3; 4; 5] <- 4
     visit [1; 2; 3; 4; 5] <- 5
   list_length_v0 [1; 2; 3; 4; 5] <- 5
   - : int = 5
   # traced_list_length_v0 show_string ["1"; "2"; "3"; "4"; "5"];;
   list_length_v0 ["1"; "2"; "3"; "4"; "5"] ->
     visit ["1"; "2"; "3"; "4"; "5"] ->
       visit ["2"; "3"; "4"; "5"] ->
         visit ["3"; "4"; "5"] ->
           visit ["4"; "5"] ->
             visit ["5"] ->
               visit [] ->
               visit [] <- 0
             visit ["5"] <- 1
           visit ["4"; "5"] <- 2
         visit ["3"; "4"; "5"] <- 3
       visit ["2"; "3"; "4"; "5"] <- 4
     visit ["1"; "2"; "3"; "4"; "5"] <- 5
   list_length_v0 ["1"; "2"; "3"; "4"; "5"] <- 5
   - : int = 5
   # traced_list_length_v0 (show_list show_string) [["1"]; ["2"]; ["3"]; ["4"]; ["5"]];;
   list_length_v0 [["1"]; ["2"]; ["3"]; ["4"]; ["5"]] ->
     visit [["1"]; ["2"]; ["3"]; ["4"]; ["5"]] ->
       visit [["2"]; ["3"]; ["4"]; ["5"]] ->
         visit [["3"]; ["4"]; ["5"]] ->
           visit [["4"]; ["5"]] ->
             visit [["5"]] ->
               visit [] ->
               visit [] <- 0
             visit [["5"]] <- 1
           visit [["4"]; ["5"]] <- 2
         visit [["3"]; ["4"]; ["5"]] <- 3
       visit [["2"]; ["3"]; ["4"]; ["5"]] <- 4
     visit [["1"]; ["2"]; ["3"]; ["4"]; ["5"]] <- 5
   list_length_v0 [["1"]; ["2"]; ["3"]; ["4"]; ["5"]] <- 5
   - : int = 5
   # 
*)

(* ***** *)

let list_length_v1 vs_given =
  let rec visit vs =
    if vs = []
    then 0
    else succ (visit (List.tl vs))
  in visit vs_given;;

let () = assert (test_list_length_int list_length_v1);;

(* ***** *)

let list_length_v2 vs_given =
 (* list_length_v2 : 'a list -> int *)
  let rec visit vs =
    match vs with
    | [] ->
       0
    | v :: vs' ->
       let ih = visit vs'
       in succ ih
  in visit vs_given;;

let () = assert (test_list_length_int list_length_v2);;

(* ***** *)

let list_length_v3 vs_given =
 (* list_length_v3 : 'a list -> int *)
  let rec visit vs =
    match vs with
    | [] ->
       0
    | v :: vs' ->
       succ (visit vs')
  in visit vs_given;;

let () = assert (test_list_length_int list_length_v3);;

(* ********** *)

let show_list show_v vs_given =
  match vs_given with
  | [] ->
     "[]"
  | v :: vs ->
     let rec show_list_aux v vs =
       match vs with
       | [] ->
          show_v v
       | v' :: vs' ->
          (show_v v) ^ "; " ^ (show_list_aux v' vs')
     in "[" ^ show_list_aux v vs ^ "]";;

(* ********** *)

let test_list_suffixes candidate =
  let b0 = (candidate [] = [[]])
  and b1 = (candidate [0] = [[0]; []])
  and b2 = (candidate [1; 0] = [[1; 0]; [0]; []])
  and b3 = (candidate [2; 1; 0] = [[2; 1; 0]; [1; 0]; [0]; []])
  (* etc. *)
  in b0 && b1 && b2 && b3;;

(* ***** *)

let list_suffixes_v0 vs_given =
  let rec visit vs =
    match vs with
    | [] ->
       [[]]
    | v :: vs' ->
       let ih = visit vs'
       in (v :: vs') :: ih
  in visit vs_given;;

let () = assert (test_list_suffixes list_suffixes_v0);;

(* ***** *)

let list_suffixes_v1 vs_given =
  let rec visit vs =
    match vs with
    | [] ->
       [[]]
    | v :: vs' ->
       (v :: vs') :: (visit vs')
  in visit vs_given;;

let () = assert (test_list_suffixes list_suffixes_v1);;

(* ***** *)

let list_suffixes_v2 vs_given =
  let rec visit vs =
    match vs with
    | [] ->
       vs :: []
    | v :: vs' ->
       vs :: (visit vs')
  in visit vs_given;;

let () = assert (test_list_suffixes list_suffixes_v2);;

(* ***** *)

let list_suffixes_v3 vs_given =
  let rec visit vs =
    vs :: match vs with
          | [] ->
             []
          | v :: vs' ->
             visit vs'
  in visit vs_given;;

let () = assert (test_list_suffixes list_suffixes_v3);;

(* ********** *)

let end_of_file = "week-08_polymorphic-lists.ml";;

(*
        OCaml version 4.01.0

# #use "anterior-lists.ml";;
...
# #use "week-08_polymorphic-lists.ml";;
val indent : int -> string = <fun>
val show_int : int -> string = <fun>
val show_bool : bool -> string = <fun>
val show_char : char -> string = <fun>
val show_string : string -> string = <fun>
val show_pair : ('a -> string) -> ('b -> string) -> 'a * 'b -> string = <fun>
val test_show_int_list : (int list -> string) -> bool = <fun>
val test_show_bool_list : (bool list -> string) -> bool = <fun>
val test_show_int_list_list : (int list list -> string) -> bool = <fun>
val show_list : ('a -> string) -> 'a list -> string = <fun>
val show_listp : ('a -> string) -> 'a list -> string = <fun>
val test_show_int_list : (int list -> string) -> bool = <fun>
val test_show_bool_list : (bool list -> string) -> bool = <fun>
val test_show_int_list_list : (int list list -> string) -> bool = <fun>
val show_list : ('a -> string) -> 'a list -> string = <fun>
val test_atoi : (int -> int list) -> bool = <fun>
val atoi_v0 : int -> int list = <fun>
val traced_atoi_v0 : int -> int list = <fun>
val test_list_length_int : (int list -> int) -> bool = <fun>
val list_length_v0 : 'a list -> int = <fun>
val traced_list_length_v0 : ('a -> string) -> 'a list -> int = <fun>
val list_length_v1 : 'a list -> int = <fun>
val list_length_v2 : 'a list -> int = <fun>
val list_length_v3 : 'a list -> int = <fun>
val show_list : ('a -> string) -> 'a list -> string = <fun>
val test_list_suffixes : (int list -> int list list) -> bool = <fun>
val list_suffixes_v0 : 'a list -> 'a list list = <fun>
val list_suffixes_v1 : 'a list -> 'a list list = <fun>
val list_suffixes_v2 : 'a list -> 'a list list = <fun>
val list_suffixes_v3 : 'a list -> 'a list list = <fun>
val end_of_file : string = "week-08_polymorphic-lists.ml"
# 
*)
