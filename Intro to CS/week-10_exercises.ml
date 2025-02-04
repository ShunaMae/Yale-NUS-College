(* week-10_exercises.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)

(* ********** *)

(*
Name of the group on Canvas: WEEK-10_10
*)

(* ********** *)

(* Exercise 01 *)

let exercise_01 = "mandatory";;

type comparison = Lt | Eq | Gt

(* Unit tests *)
let test_compare candidate =
  let b0 = (candidate 3 4 = ~-1)
  and b1 = (candidate 4 4 = 0)
  and b2 = (candidate 0 0 = 0)
  and b3 = (candidate ~-1 6 = ~-1)
  and b4 = (candidate 8 4 = 1)
  in b0 && b1 && b2 && b3 && b4;;


let test_make_comparison candidate =
  let b0 = (candidate 3 4 = Lt)
  and b1 = (candidate 4 4 = Eq)
  and b2 = (candidate 0 0 = Eq)
  and b3 = (candidate ~-1 6 = Lt)
  and b4 = (candidate 8 4 = Gt)
  in b0 && b1 && b2 && b3 && b4;;

(* Make Comp *)
let make_comparison v1 v2 =
 (* make_comparison : 'a -> 'a -> comparison *)
  if v1 < v2 then Lt else if v1 = v2 then Eq else Gt;;


let make_comparison_compare v1 v2 =
  match compare v1 v2 with
  | -1 -> Lt
  | 0 -> Eq
  | _ -> Gt;;

let compare_make_comparison v1 v2 =
  match make_comparison v1 v2 with
  | Lt ->
     ~-1
  | Eq ->
     0
  | Gt ->
     1;;

let () = assert(test_compare compare)
let () = assert(test_compare compare_make_comparison)
let () = assert(test_make_comparison make_comparison)
let () = assert(test_make_comparison make_comparison_compare)
         
(* ********** *)

(* Exercise 02 *)

let exercise_02 = "mandatory";;

let atoi_v0 n =
  let () = assert (n >= 0) in
  let rec visit i =
    if i = 0
    then []
    else let i' = pred i
         in let ih = visit i'
            in i' :: ih
  in visit n;;
  
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
  

let list_length_v3 vs_given =
 (* list_length_v3 : 'a list -> int *)
  let rec visit vs =
    match vs with
    | [] ->
       0
    | v :: vs' ->
       succ (visit vs')
  in visit vs_given;;

let () = assert(test_list_length_int list_length_v3)

(* ********** *)

(* Exercise 03 *)

let exercise_03 = "mandatory";;

let test_list_append_int candidate =
      (* two handpicked lists: *)
  let b0 = (candidate [1; 2; 3] [4; 5] = [1; 2; 3; 4; 5])
      (* an instance of the base case: *)
  and b1 = (candidate [] [1; 0] = [1; 0])
      (* successive instances of the induction step: *)
  and b2 = (candidate [2] [1; 0] = [2; 1; 0])
  and b3 = (candidate [3; 2] [1; 0] = [3; 2; 1; 0])
  and b4 = (candidate [4; 3; 2] [1; 0] = [4; 3; 2; 1; 0])
      (* other handpicked lists: *)
  and b5 = (candidate [10; 20] [] = [10; 20])
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5;;
  
let list_append_v1 xs_given ys_given =
  let rec visit xs =
    match xs with
    | [] ->
       ys_given
    | x :: xs' ->
       x :: visit xs'
  in visit xs_given;;
  
let () = assert(test_list_append_int list_append_v1)

(* ********** *)

(* Exercise 04 *)

let exercise_04 = "mandatory";;

let test_list_map candidate =
  let b0 = (candidate succ [3; 2; 1; 0] = [4; 3; 2; 1])
  and b1 = (candidate pred [2; 1; 0] = [1; 0; ~-1])
  and b2 = (candidate (fun n -> n * n) [3; 2; 1] = [9; 4; 1])
  in b0 && b1 && b2;;
    
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
  
let () = assert(test_list_map list_map)

(* ********** *)

(* Exercise 05 *)

let exercise_05 = "mandatory";;
  
let test_reverse candidate =
  let b0 = (candidate [] = [])
  and b1 = (candidate [0] = [0])
  and b2 = (candidate [1; 0] = [0; 1])
  and b3 = (candidate [2; 1; 0] = [0; 1; 2])
  and b4 = (let ns = atoi_v0 100
            in candidate (candidate ns) = ns)
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4;;

let reverse_v1 vs_init =
  let rec visit vs =
    if vs = []
    then []
    else let ih = visit (List.tl vs)
         in List.append ih [List.hd vs]
  in visit vs_init;;
  
let () = assert(test_reverse reverse_v1);;


(* ********** *)

(* Exercise 06 *)

let exercise_06 = "mandatory";;

(* a *)
type 'a tsil = Lin | Snoc of 'a tsil * 'a;;

(* test_tsil_length *)
let test_tsil_length candidate =
  let n1 = Random.int 5 and n2 = Random.int 1000
  in let b0 = (candidate Lin = 0)
     and b1 = (candidate (Snoc(Lin, 3)) = 1)
     and b2 = (candidate (Snoc(Snoc(Lin, 3), 5)) = 2)
     and b3 = (candidate (Snoc(Snoc(Snoc(Lin, n1), n2), 5)) = 3)
     in b0 && b1 && b2 && b3;;

(* tsil_length *)
let tsil_length ts_given =
  let rec visit ts a =
    match ts with
    | Lin ->
       a
    | Snoc(c, d) ->
       visit c (succ a)
  in visit ts_given 0;;
  

let () = assert (test_tsil_length tsil_length);;

(* b *)
let test_tsil_append candidate =
  let n1 = Random.int 1000 and n2 = Random.int 500
  in let b0 = (candidate Lin Lin = Lin)
     and b1 = (candidate Lin (Snoc(Lin, 3)) = (Snoc(Lin, 3)))
     and b2 = (candidate (Snoc(Snoc(Lin, 3), 4)) (Snoc(Lin, 5)) = (Snoc(Snoc(Snoc(Lin, 3), 4), 5)))
     and b3 = (candidate (Snoc(Lin, n1)) (Snoc(Lin, n2)) = (Snoc(Snoc(Lin, n1), n2)))
     in b0 && b1 && b2 && b3;;

let tsil_append ts1_given ts2_given =
  let rec visit ts =
    match ts with
    | Lin ->
       ts1_given
    | Snoc(c,d) ->
       Snoc(visit c, d)
  in visit ts2_given;;

let () = assert (test_tsil_append tsil_append);;


(* c *)
let test_int_tsil_map candidate =
  let n1 = Random.int 500 and n2 = Random.int 400
  in let b0 = (candidate (fun x -> x/2) (Snoc(Snoc(Lin,4), 5)) = (Snoc(Snoc(Lin, 2), 2)))
     and b1 = (candidate (fun x -> x + 1) (Snoc(Snoc(Snoc(Lin, 4), n1), n2)) = (Snoc(Snoc(Snoc(Lin, 5), succ(n1)), succ(n2))))
     and b2 = (candidate (fun x -> x) Lin = Lin)
     and b3 = (candidate (fun x -> x) (Snoc(Lin, n1)) = (Snoc(Lin, n1)))
     and b4 = (candidate (fun x -> x/2) (Snoc(Snoc(Lin,n1), n2)) = (Snoc(Snoc(Lin, n1/2), n2/2)))
     in b0 && b1 && b2 && b3 && b4;;

let tsil_map f ts_given =
  let rec visit ts =
    match ts with
    | Lin ->
       Lin
    | Snoc(c,d) ->
       Snoc(visit c, f d)
  in visit ts_given;;


let () = assert(test_int_tsil_map tsil_map);;

(* d *)

let test_tsil_reverse candidate =
  let n1 = Random.int 400 and n2 = Random.int 600 
  in let b0 = (candidate Lin = Lin)
     and b1 = (candidate (Snoc(Lin, n1)) = (Snoc(Lin, n1)))
     and b2 = (candidate (Snoc(Snoc(Snoc(Lin, n1), n2), 67)) = (Snoc(Snoc(Snoc(Lin, 67), n2), n1)))
     in b0 && b1 && b2;;

let tsil_reverse ts_given =
  let rec visit ts = 
    match ts with
    | Lin ->
       Lin
    | Snoc(a,b) ->
       tsil_append (Snoc(Lin, b)) (visit a)
  in visit ts_given;;

let tsil_reverse_acc ts_given =
  let rec visit ts a =
    match ts with
    | Lin ->
       a
    | Snoc(c, d) ->
       visit c (Snoc(a, d))
  in visit ts_given Lin;;

let () = assert (test_tsil_reverse tsil_reverse);;
let () = assert (test_tsil_reverse tsil_reverse_acc);;

(* e *)

let test_tsil_of_list candidate =
  let b0 = (candidate [] = Lin)
  and b2 = (candidate (1 :: 0 :: []) = Snoc (Snoc (Lin, 0), 1))
  (* etc. *)
  in b0 && b2;;

let test_list_of_tsil candidate =
  let b0 = (candidate Lin = [])
  and b2 = (candidate (Snoc (Snoc (Lin, 0), 1)) = 1 :: 0 :: [])
  (* etc. *)
  in b0 && b2;;

let tsil_of_list ls =
  let rec visit vs = 
    match vs with
    | [] ->
       Lin
    | v :: vs' ->
       Snoc(visit vs', v)
  in visit ls;;

let list_of_tsil ts =
  let rec visit vs = 
    match vs with
    | Lin ->
       []
    | Snoc(c,d)  ->
       d :: visit c
  in visit ts;;

let () = assert(test_list_of_tsil list_of_tsil);;
let () = assert(test_tsil_of_list tsil_of_list);;

(* f1 *)

let test_tsil_length candidate =
  let n1 = Random.int 5 and n2 = Random.int 1000
  in let b0 = (candidate Lin = 0)
     and b1 = (candidate (Snoc(Lin, 3)) = 1)
     and b2 = (candidate (Snoc(Snoc(Lin, 3), 5)) = 2)
     and b3 = (candidate (Snoc(Snoc(Snoc(Lin, n1), n2), 5)) = 3)
     in b0 && b1 && b2 && b3;;

let tsil_length_using_list ts =
  List.length (list_of_tsil ts);;
  
let () = assert(test_tsil_length tsil_length_using_list);;

(* f2 *)

(* List length unit test *)
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

let list_length_using_tsil ls =
  tsil_length (tsil_of_list ls);;

let () = assert(test_list_length_int list_length_using_tsil);;

(* f3 *)

let test_int_tsil_map candidate =
  let n1 = Random.int 500 and n2 = Random.int 400
  in let b0 = (candidate (fun x -> x/2) (Snoc(Snoc(Lin,4), 5)) = (Snoc(Snoc(Lin, 2), 2)))
     and b1 = (candidate (fun x -> x + 1) (Snoc(Snoc(Snoc(Lin, 4), n1), n2)) = (Snoc(Snoc(Snoc(Lin, 5), succ(n1)), succ(n2))))
     and b2 = (candidate (fun x -> x) Lin = Lin)
     and b3 = (candidate (fun x -> x) (Snoc(Lin, n1)) = (Snoc(Lin, n1)))
     and b4 = (candidate (fun x -> x/2) (Snoc(Snoc(Lin,n1), n2)) = (Snoc(Snoc(Lin, n1/2), n2/2)))
     in b0 && b1 && b2 && b3 && b4;;
     
let tsil_map_using_list f ts =
  tsil_of_list (list_map f (list_of_tsil ts));;
  
let () = assert(test_int_tsil_map tsil_map_using_list);;

(* f4 *)

(* List map unit tests for int/opt/char *)
let test_int_list_map candidate =
  let n1 = Random.int 20 and n2 = Random.int 30
  in let b0 = (candidate (fun x -> x+1) [] = List.map (fun x -> x+1) [])
     and b1 = (candidate (fun x -> x/2) [1;2;3;4] = List.map (fun x -> x/2) [1;2;3;4])
     and b2 = (candidate (fun x -> x) [1;3;5] = List.map (fun x -> x) [1;3;5])
     and b3 = (candidate (fun x -> x*x) [n1;n2] = List.map (fun x -> x*x) [n1;n2])
     in b0 && b1 && b2 && b3;;

let test_int_opt_list_map candidate =
  let b0 = (candidate (fun x -> None) [Some 1;Some 3;Some 4] = List.map (fun x -> None) [Some 1;Some 3;Some 4])
  and b1  = (candidate (fun x -> None) [] = List.map (fun x -> None) [])
  and b2 = (candidate (fun x -> Some x) [Some 1;Some 2; Some 3] = List.map (fun x -> Some x) [Some 1;Some 2;Some 3])
  and b3 = (candidate (fun x -> Some x) [] = List.map (fun x -> Some x) [])
  in b0 && b1 && b2 && b3;;

let test_char_list_map candidate =
  let b0 = (candidate (fun x -> x) [] = [])
  and b1 = (candidate (fun x -> x) ['a';'b'] = ['a'; 'b'])
  and b2 = (candidate (fun i -> (char_of_int(int_of_char i - int_of_char 'a' + int_of_char 'A'))) ['a'; 'b'; 'c'] = ['A'; 'B'; 'C'])
  in b0 && b1 && b2;;

let tsil_length_using_list ts =
  List.length (list_of_tsil ts);;

let () = assert(test_tsil_length tsil_length_using_list);;

let list_length_using_tsil ls =
  tsil_length (tsil_of_list ls);;

let () = assert(test_list_length_int list_length_using_tsil);;

let tsil_map_using_list f ts =
  tsil_of_list (list_map f (list_of_tsil ts));;

let () = assert(test_int_tsil_map tsil_map_using_list);;

let list_map_using_tsil f ls =
  list_of_tsil(tsil_map f (tsil_of_list ls));;

let () = assert(test_int_opt_list_map list_map_using_tsil);;
let () = assert(test_int_list_map list_map_using_tsil);;
let () = assert(test_char_list_map list_map_using_tsil);;

(* g *)

(* list_fold_right and list_fold_left for tsils *)
let tsil_fold_right lin_case snoc_case ts_given =
  let rec traverse ts =
    match ts with
    | Lin ->
       lin_case
    | Snoc(c,d) ->
       let ih = traverse c
       in snoc_case ih d
  in traverse ts_given;;

let tsil_fold_left lin_case snoc_case ts_given =
  let rec traverse ts a =
    match ts with
    | Lin ->
       a
    | Snoc(c,d) ->
       traverse c (snoc_case d a)
  in traverse ts_given lin_case;;

(* tsil_reverse_acc using tsil_fold_left *)
(*tsil_fold_left Lin (fun d a -> Snoc(a,d)) (Snoc(Snoc(Lin, 3), 4));;
- : int tsil = Snoc (Snoc (Lin, 4), 3) *)

(* tsil_length using tsil_fold_left *)
(* tsil_fold_left 0 (fun c a -> succ a) (Snoc(Snoc(Lin,3), 4));;
- : int = 2 *)

(*  tsil_fold_right to reverse a tsil
# tsil_fold_right Lin (fun ih d -> tsil_append (Snoc(Lin,d)) ih) (Snoc(Snoc(Lin, 3), 4));;
- : int tsil = Snoc (Snoc (Lin, 4), 3) *)

(* ********** *)

(* Exercise 07 *)

let exercise_07 = "mandatory";;

let f l  =  
  match l with 
  | [] -> []
  | (a, b)::tl -> [(b, a)];;

let mirror vs_given =
  list_map (fun (a, b) -> (b, a)) vs_given;;

(* mirror [('a',2); ('c',3)];;
- : (int * char) list = [(2, 'a'); (3, 'c')] *)

(* ********** *)

(* Exercise 08 *)

let exercise_08 = "mandatory";;

(* a *)

let test_int_list_mapi candidate =
  let b0 = (candidate (fun i _ -> 4) [] = [])
  and b1 = (candidate (fun i _ -> 5) [ 1; 2; 3; 4; 5 ]
           = List.mapi (fun i _ -> 5) [ 1; 2; 3; 4; 5 ])
  and b2 = (candidate (fun i _ -> i + 5) [ 3; 4; 5 ]
            = List.mapi (fun i _ -> i + 5) [ 3; 4; 5 ])
  and b3 = (candidate (fun i c -> if i = 3 then 3 else c) [ 3; 4; 5; 6; 7; 8 ]
            = List.mapi (fun i c -> if i = 3 then 3 else c) [ 3; 4; 5; 6; 7; 8 ])
  in b0 && b1 && b2 && b3
  
let list_mapi f lst = 
    let len = List.length lst in 
    let rec traverse_list i lst2 =
        if i = len then
        []
        else (f i (List.hd lst2)) :: traverse_list (succ i) (List.tl lst2) in
        traverse_list 0 lst;;

(* list_mapi (fun n v -> (n, v)) ['a'; 'b'; 'c'];;
- : (int * char) list = [(0, 'a'); (1, 'b'); (2, 'c')] *)

(* b *)

let test_charlistidentity candidate =
  let b0 = (candidate [] = [])
  and b1 = (candidate ['a'] = ['a'])
  and b2 = (candidate ['b';'a'] = ['b';'a'])
  and b3 = (candidate ['c'; 'b'; 'a'] = ['c'; 'b'; 'a'])
  in b0 && b1 && b2 && b3;;


let identity lst = list_mapi (fun u v -> v) lst;;

let () = assert (test_charlistidentity identity);;

(* identity ['a'; 'b'; 'c'];;
- : char list = ['a'; 'b'; 'c'] *)

(* c *)

let test_incindex candidate =
  let b0 = (candidate [] = [])
  and b1 = (candidate ['c'] = [0])
  and b2 = (candidate ['b'; 'c'] = [0; 1])
  and b3 = (candidate ['a'; 'b'; 'c'] = [0; 1; 2])
  in b0 && b1 && b2 && b3;;
        
let increasing_func lst = list_mapi (fun u v -> u) lst;;

let () = assert (test_incindex increasing_func);;

(* increasing_func ['a'; 'b'; 'c'];;
- : int list = [0; 1; 2] *)

(* d *)

let test_decindex candidate =
  let b0 = (candidate [] = [])
  and b1 = (candidate ['c'] = [0])
  and b2 = (candidate ['b'; 'c'] = [1; 0])
  and b3 = (candidate ['a'; 'b'; 'c'] = [2; 1; 0])
  in b0 && b1 && b2 && b3;;

let decreasing_func lst = 
  let len = List.length lst
  in list_mapi (fun u v -> (len - u - 1)) lst;;

let () = assert (test_decindex decreasing_func);;
    
(* decreasing_func ['a'; 'b'; 'c'];;
- : int list = [2; 1; 0] *)

(* ********** *)

(* Exercise 10 *)

let exercise_10 = "mandatory";;

let list_fold_right nil_case cons_case vs_given =
 (* list_fold_right : 'a -> ('b -> 'a -> 'a) -> 'b list -> 'a *)
  let rec traverse vs =
       (* traverse : 'b list -> 'a *)
    match vs with
    | [] ->
       nil_case
    | v :: vs' ->
       let ih = traverse vs'
       in cons_case v ih
  in traverse vs_given;;

# let test_intlistidentity candidate =
  let b0 = (candidate [] = [])
  and b1 = (candidate [0] = [0])
  and b2 = (candidate [1;0] = [1;0])
  and b3 = (candidate [2; 1; 0] = [2; 1;0])
  in b0 && b1 && b2 && b3;;
           
let the_following_OCaml_function xs =
  list_fold_right [] (fun x ih -> x :: ih) xs;;

let () = assert (test_intlistidentity the_following_OCaml_function);;
let () = assert (test_charlistidentity the_following_OCaml_function);;
  
(* To visualise: 
the_following_OCaml_function ['a'; 'b'; 'c'];;
- : char list = ['a'; 'b'; 'c'] *)

(* ********** *)

(* Exercise 11 *)

let exercise_11 = "mandatory";;

let list_fold_left nil_case cons_case vs_given =
 (* list_fold_left : 'a -> ('b -> 'a -> 'a) -> 'b list -> 'a *)
  let rec traverse vs a =
       (* traverse : 'b list -> 'a -> 'a *)
    match vs with
    | [] ->
       a
    | v :: vs' ->
       traverse vs' (cons_case v a)
  in traverse vs_given nil_case;;
  
let the_following_other_OCaml_function xs =
  list_fold_left [] (fun x a -> x :: a) xs;;

let () = assert (test_reverse the_following_other_OCaml_function);;
  
(* the_following_other_OCaml_function ['a'; 'b'; 'c'];;
- : char list = ['c'; 'b'; 'a'] *)

(* ********** *)

(* Exercise 12 *)

let exercise_12 = "mandatory";;

type 'a binary_tree =
  Leaf of 'a
| Node of 'a binary_tree * 'a binary_tree;;

let number_of_nodes_v1 t =
 (* number_of_nodes_v1 : binary_tree -> int *)
  let rec visit t =
    match t with
    | Leaf v ->
       0
    | Node (t1, t2) ->
       succ (visit t1 + visit t2)
  in visit t;;
  
let number_of_leaves_v1 t =
 (* number_of_leaves_v1 : 'a binary_tree -> int *)
  let rec visit t =
    match t with
    | Leaf v ->
       1
    | Node (t1, t2) ->
       visit t1 + visit t2
  in visit t;;
  
let generate_random_binary_tree_int n =
  let () = assert (n >= 0) in
  let rec visit n =
    if n = 0
    then Leaf (Random.int 10)
    else match Random.int 3 with
         | 0 ->
            Leaf (pred (- (Random.int 5)))
         | _ ->
            let n' = pred n
            in Node (visit n', visit n')
  in visit n;;
  
let test_random_binary_tree candidate =
  let b0 = (let i = Random.int 5 in
            let tree = candidate i in
            let n_leaves = number_of_leaves_v1 tree and
            n_nodes = number_of_nodes_v1 tree in
            n_leaves = (n_nodes + 1))
            
  and b1 = let i = Random.int 10 in
           let tree = candidate i in
           let n_leaves = number_of_leaves_v1 tree and
            n_nodes = number_of_nodes_v1 tree in
            n_leaves = n_nodes + 1
            
  and b2 = let i = Random.int 15 in
            let tree = candidate i in
            let n_leaves = number_of_leaves_v1 tree and
            n_nodes = number_of_nodes_v1 tree in
            n_leaves = n_nodes + 1
            
  and b3 = let i = Random.int 20 in
            let tree = candidate i in
            let n_leaves = number_of_leaves_v1 tree and
            n_nodes = number_of_nodes_v1 tree in
            n_leaves = n_nodes + 1
                           
  and b4 = let i = Random.int 25 in
           let tree = candidate i in
           let n_leaves = number_of_leaves_v1 tree and
           n_nodes = number_of_nodes_v1 tree in
           n_leaves = n_nodes + 1
            
  (* etc.*)
  in b0 && b1 && b2 && b3 && b4;;
  
let () = assert(test_random_binary_tree generate_random_binary_tree_int);;

(* ********** *)

let end_of_file = "week-10_exercises.ml";;

(*         OCaml version 4.12.0

# #use "week-10_exercises.ml";;
val exercise_01 : string = "mandatory"
type comparison = Lt | Eq | Gt
val test_compare : (int -> int -> int) -> bool = <fun>
val test_make_comparison : (int -> int -> comparison) -> bool = <fun>
val make_comparison : 'a -> 'a -> comparison = <fun>
val make_comparison_compare : 'a -> 'a -> comparison = <fun>
val compare_make_comparison : 'a -> 'a -> int = <fun>
val exercise_02 : string = "mandatory"
val atoi_v0 : int -> int list = <fun>
val test_list_length_int : (int list -> int) -> bool = <fun>
val list_length_v3 : 'a list -> int = <fun>
val exercise_03 : string = "mandatory"
val test_list_append_int : (int list -> int list -> int list) -> bool = <fun>
val list_append_v1 : 'a list -> 'a list -> 'a list = <fun>
val exercise_04 : string = "mandatory"
val test_list_map : ((int -> int) -> int list -> int list) -> bool = <fun>
val list_map : ('a -> 'b) -> 'a list -> 'b list = <fun>
val exercise_05 : string = "mandatory"
val test_reverse : (int list -> int list) -> bool = <fun>
val reverse_v1 : 'a list -> 'a list = <fun>
val exercise_06 : string = "mandatory"
type 'a tsil = Lin | Snoc of 'a tsil * 'a
val test_tsil_length : (int tsil -> int) -> bool = <fun>
val tsil_length : 'a tsil -> int = <fun>
val test_tsil_append : (int tsil -> int tsil -> int tsil) -> bool = <fun>
val tsil_append : 'a tsil -> 'a tsil -> 'a tsil = <fun>
val test_int_tsil_map : ((int -> int) -> int tsil -> int tsil) -> bool = <fun>
val tsil_map : ('a -> 'b) -> 'a tsil -> 'b tsil = <fun>
val test_tsil_reverse : (int tsil -> int tsil) -> bool = <fun>
val tsil_reverse : 'a tsil -> 'a tsil = <fun>
val tsil_reverse_acc : 'a tsil -> 'a tsil = <fun>
val test_tsil_of_list : (int list -> int tsil) -> bool = <fun>
val test_list_of_tsil : (int tsil -> int list) -> bool = <fun>
val tsil_of_list : 'a list -> 'a tsil = <fun>
val list_of_tsil : 'a tsil -> 'a list = <fun>
val test_tsil_length : (int tsil -> int) -> bool = <fun>
val tsil_length_using_list : 'a tsil -> int = <fun>
val test_list_length_int : (int list -> int) -> bool = <fun>
val list_length_using_tsil : 'a list -> int = <fun>
val test_int_tsil_map : ((int -> int) -> int tsil -> int tsil) -> bool = <fun>
val tsil_map_using_list : ('a -> 'b) -> 'a tsil -> 'b tsil = <fun>
val test_int_list_map : ((int -> int) -> int list -> int list) -> bool = <fun>
val test_int_opt_list_map :
  (('a -> 'a option) -> int option list -> int option option list) -> bool =
  <fun>
val test_char_list_map : ((char -> char) -> char list -> char list) -> bool =
  <fun>
val tsil_length_using_list : 'a tsil -> int = <fun>
val list_length_using_tsil : 'a list -> int = <fun>
val tsil_map_using_list : ('a -> 'b) -> 'a tsil -> 'b tsil = <fun>
val list_map_using_tsil : ('a -> 'b) -> 'a list -> 'b list = <fun>
val tsil_fold_right : 'a -> ('a -> 'b -> 'a) -> 'b tsil -> 'a = <fun>
val tsil_fold_left : 'a -> ('b -> 'a -> 'a) -> 'b tsil -> 'a = <fun>
val exercise_07 : string = "mandatory"
val f : ('a * 'b) list -> ('b * 'a) list = <fun>
val mirror : ('a * 'b) list -> ('b * 'a) list = <fun>
val exercise_08 : string = "mandatory"
val test_int_list_mapi : ((int -> int -> int) -> int list -> int list) -> bool = <fun>
val list_mapi : (int -> 'a -> 'b) -> 'a list -> 'b list = <fun>
val identity : 'a list -> 'a list = <fun>
val increasing_func : 'a list -> int list = <fun>
val decreasing_func : 'a list -> int list = <fun>
val exercise_10 : string = "mandatory"
val list_fold_right : 'a -> ('b -> 'a -> 'a) -> 'b list -> 'a = <fun>
val the_following_OCaml_function : 'a list -> 'a list = <fun>
val exercise_11 : string = "mandatory"
val list_fold_left : 'a -> ('b -> 'a -> 'a) -> 'b list -> 'a = <fun>
val the_following_other_OCaml_function : 'a list -> 'a list = <fun>
val exercise_12 : string = "mandatory"
type 'a binary_tree = Leaf of 'a | Node of 'a binary_tree * 'a binary_tree
val number_of_nodes_v1 : 'a binary_tree -> int = <fun>
val number_of_leaves_v1 : 'a binary_tree -> int = <fun>
val generate_random_binary_tree_int : int -> int binary_tree = <fun>
val test_random_binary_tree : (int -> 'a binary_tree) -> bool = <fun>
val end_of_file : string = "week-10_exercises.ml"
#
 *)
