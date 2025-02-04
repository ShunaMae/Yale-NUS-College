(* mini-project_about-depth-first-and-breadth-first-traversals.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 02 Apr 2022 *)

(* ********** *)

(* name of group: 
*)

(* ********** *)

let make_indentation n =
  String.make (2 * n) ' ';;

let show_bool b =
  if b
  then "true"
  else "false";;

let show_int n =
  if n < 0
  then "~" ^ string_of_int n
  else string_of_int n;;

let show_list show_yourself vs =
 (* show_list : ('a -> string) -> 'a list -> string *)
  match vs with
  | [] ->
     "[]"
  | v :: vs' ->
     let rec show_list_aux vs' v =
       match vs' with
       | [] ->
          show_yourself v
       | v' :: vs'' ->
          let ih = show_list_aux vs''
          in (show_yourself v) ^ "; " ^ (ih v')
     in "[" ^ show_list_aux vs' v ^ "]";;

(* ********** *)

module type QUEUE =
  sig
    type 'a queue
    val empty : 'a queue
    val is_empty : 'a queue -> bool
    val enqueue : 'a -> 'a queue -> 'a queue
    val dequeue : 'a queue -> ('a * 'a queue) option
    val show : ('a -> string) -> 'a queue -> string
  end;;

(* ********** *)

let test_lifo_queue_int_one test result =
  result || let () = Printf.printf "test_lifo_queue_int %s failed\n" test in false;;

let test_lifo_queue_int empty is_empty enqueue dequeue =
  let b0 = test_lifo_queue_int_one
             "b0"
             (is_empty empty = true)
  and b1 = test_lifo_queue_int_one
             "b1"
             (is_empty (enqueue 3 empty) = false)
  and b2 = test_lifo_queue_int_one
             "b2"
             (match dequeue empty with
              | Some _ ->
                 false
              | None ->
                 true)
  and b3 = test_lifo_queue_int_one
             "b3"
             (match dequeue (enqueue 3 empty) with
              | Some (x, q) ->
                 x = 3 && is_empty q
              | None ->
                 false)
  and b4 = test_lifo_queue_int_one
             "b4"
             (match dequeue (enqueue 4 (enqueue 3 empty)) with
              | Some (x, q) ->
                 x = 4 && (match dequeue q with
                           | Some (y, q') ->
                              y = 3 && is_empty q'
                           | None ->
                              false)
              | None ->
                 false)
  and b5 = test_lifo_queue_int_one
             "b5"
             (match dequeue (enqueue 4 (enqueue 3 (enqueue 2 (enqueue 1 empty)))) with
              | Some (n4, q4) ->
                 n4 = 4 && (match dequeue q4 with
                            | Some (n3, q3) ->
                               n3 = 3 && (match dequeue q3 with
                                          | Some (n2, q2) ->
                                             n2 = 2 && (match dequeue q2 with
                                                        | Some (n1, q1) ->
                                                           n1 = 1 && is_empty q1
                                                        | None ->
                                                           false)
                                          | None ->
                                             false)
                            | None ->
                               false)
              | None ->
                 false)
  and b6 = test_lifo_queue_int_one
             "b6"
             (let q1 = enqueue 1 empty
              in let q2 = enqueue 2 q1
                 in let q3 = enqueue 3 q2
                    in match dequeue q3 with
                       | Some (n4, q4) ->
                          n4 = 3 && (match dequeue q4 with
                                     | Some (n5, q5) ->
                                        n5 = 2 && (let q6 = enqueue 4 q5
                                                   in let q7 = enqueue 5 q6
                                                      in match dequeue q7 with
                                                         | Some (n8, q8) ->
                                                            n8 = 5 && (match dequeue q8 with
                                                                       | Some (n9, q9) ->
                                                                          n9 = 4 && (match dequeue q9 with
                                                                                     | Some (n10, q10) ->
                                                                                        n10 = 1 && is_empty q10
                                                                                     | None ->
                                                                                        false)
                                                                       | None ->
                                                                          false)
                                                         | None ->
                                                            false)
                                     | None ->
                                        false)
                       | None ->
                          false)
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6;;

(* ********** *)

let test_fifo_queue_int_one test result =
  result || let () = Printf.printf "test_fifo_queue_int %s failed\n" test in false;;

let test_fifo_queue_int empty is_empty enqueue dequeue =
  let b0 = test_fifo_queue_int_one
             "b0"
             (is_empty empty = true)
  and b1 = test_fifo_queue_int_one
             "b1"
             (is_empty (enqueue 3 empty) = false)
  and b2 = test_fifo_queue_int_one
             "b2"
             (match dequeue empty with
              | Some _ ->
                 false
              | None ->
                 true)
  and b3 = test_fifo_queue_int_one
             "b3"
             (match dequeue (enqueue 3 empty) with
              | Some (x, q) ->
                 x = 3 && is_empty q
              | None ->
                 false)
  and b4 = test_fifo_queue_int_one
             "b4"
             (match dequeue (enqueue 4 (enqueue 3 empty)) with
              | Some (x, q) ->
                 x = 3 && (match dequeue q with
                           | Some (y, q') ->
                              y = 4 && is_empty q'
                           | None ->
                              false)
              | None ->
                 false)
  and b5 = test_fifo_queue_int_one
             "b5"
             (match dequeue (enqueue 4 (enqueue 3 (enqueue 2 (enqueue 1 empty)))) with
              | Some (n1, q1) ->
                 n1 = 1 && (match dequeue q1 with
                            | Some (n2, q2) ->
                               n2 = 2 && (match dequeue q2 with
                                          | Some (n3, q3) ->
                                             n3 = 3 && (match dequeue q3 with
                                                        | Some (n4, q4) ->
                                                           n4 = 4 && is_empty q4
                                                        | None ->
                                                           false)
                                          | None ->
                                             false)
                            | None ->
                               false)
              | None ->
                 false)
  and b6 = test_fifo_queue_int_one
             "b6"
             (let q1 = enqueue 1 empty
              in let q2 = enqueue 2 q1
                 in let q3 = enqueue 3 q2
                    in match dequeue q3 with
                       | Some (n4, q4) ->
                          n4 = 1 && (match dequeue q4 with
                                     | Some (n5, q5) ->
                                        n5 = 2 && (let q6 = enqueue 4 q5
                                                   in let q7 = enqueue 5 q6
                                                      in match dequeue q7 with
                                                         | Some (n8, q8) ->
                                                            n8 = 3 && (match dequeue q8 with
                                                                       | Some (n9, q9) ->
                                                                          n9 = 4 && (match dequeue q9 with
                                                                                     | Some (n10, q10) ->
                                                                                        n10 = 5 && is_empty q10
                                                                                     | None ->
                                                                                        false)
                                                                       | None ->
                                                                          false)
                                                         | None ->
                                                            false)
                                     | None ->
                                        false)
                       | None ->
                          false)
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6;;

(* ********** *)

(* Representing a last-in, first-out queue, i.e., a stack,
   as the list of its (stackable) elements: *)

module Lifo : QUEUE =
  struct
    type 'a queue = 'a list

    let empty = []

    let is_empty q =
      match q with
      | [] ->
         true
      | _ :: _ ->
         false

    let is_empty' q =
      q = []

    let enqueue v q =
      v :: q

    let dequeue q =
      match q with
      | [] ->
         None
      | v :: q' ->
         Some (v, q')

    let show show_yourself q =
      show_list show_yourself q
  end;;

let () = assert (test_lifo_queue_int Lifo.empty
                                     Lifo.is_empty
                                     Lifo.enqueue
                                     Lifo.dequeue);;

(* ********** *)

(* Representing a first-in, first-out queue, i.e., a queue,
   as a pair of lists of its (enqueueable) elements,
   using Okasaki's representation: *)

module Fifo : QUEUE =
  struct
    type 'a queue = 'a list * 'a list

    let empty =
      ([], [])

    let is_empty q =
      q = ([], [])

    let enqueue x (pool, reversed_prefix) =
      (pool, x :: reversed_prefix)

    let dequeue (pool, reversed_prefix) =
      match pool with
      | [] ->
         (match List.rev reversed_prefix with
          | [] ->
             None
          | x :: new_pool ->
             Some (x, (new_pool, [])))
      | x :: pool' ->
         Some (x, (pool', reversed_prefix))

    (* rendering Okasaki's representation: *)
    let show show_yourself (pool, reversed_prefix) =
      "(" ^ show_list show_yourself pool ^ ", " ^ show_list show_yourself reversed_prefix ^ ")"

    (* rendering a list representation where the last enqueued element occurs first: *)
    let show show_yourself (pool, reversed_prefix) =
      show_list show_yourself (pool @ List.rev reversed_prefix)
  end;;

let () = assert (test_fifo_queue_int Fifo.empty
                                     Fifo.is_empty
                                     Fifo.enqueue
                                     Fifo.dequeue);;

(* ********** *)

type 'a binary_tree =
  | Leaf of 'a
  | Node of 'a binary_tree * 'a binary_tree;;

let show_binary_tree show_yourself t =
  let rec visit t =
    match t with
    | Leaf v ->
       "Leaf " ^ (show_yourself v)
    | Node (t1, t2) ->
       "Node (" ^ visit t1 ^ ", " ^ visit t2 ^ ")"
  in visit t;;

let binary_tree_fold leaf_case node_case t_given =
  let rec visit t =
    match t with
    | Leaf v ->
       leaf_case v
    | Node (t1, t2) ->
       node_case (visit t1) (visit t2)
  in visit t_given;;

(* ********** *)

let t1 = Node (Node (Leaf 3,
		     Leaf 2),
	       Node (Node (Leaf 5,
			   Leaf 4),
		     Leaf 1));;

let t2 = Node (Node (Leaf 1,
		     Leaf 2),
	       Node (Node (Leaf 3,
			   Leaf 4),
		     Leaf 5));;

let t3 = Node (Node (Leaf 5,
		     Leaf 4),
	       Node (Node (Leaf 3,
			   Leaf 2),
		     Leaf 1));;

let t4 = Node (Node (Leaf 1,
		     Leaf 2),
	       Node (Node (Leaf 4,
			   Leaf 5),
		     Leaf 3));;

(* ***** *)

let traverse_foo empty enqueue dequeue t =
  let rec process q =
    match dequeue q with
    | None ->
       []
    | Some (t, q') ->
       (match t with
        | Leaf x ->
           x :: process q'
        | Node (t1, t2) ->
           process (enqueue t1 (enqueue t2 q')))
  in process (enqueue t empty);;

let traced_traverse_foo show_yourself empty enqueue dequeue show_queue t =
  let rec process q depth =
    Printf.printf "%sprocess_foo %s ->\n" (make_indentation depth) (show_queue (show_binary_tree show_yourself) q);
    match dequeue q with
    | None ->
       Printf.printf "%sprocess_foo %s <- %s\n" (make_indentation depth) (show_queue (show_binary_tree show_yourself) q) (show_list show_yourself []);
       []
    | Some (t, q') ->
       (match t with
        | Leaf x ->
           let result = x :: process q' (succ depth)
           in Printf.printf "%sprocess_foo %s <- %s\n" (make_indentation depth) (show_queue (show_binary_tree show_yourself) q) (show_list show_yourself result);
              result
        | Node (t1, t2) ->
           process (enqueue t1 (enqueue t2 q')) depth)
  in process (enqueue t empty) 0;;

(* ***** *)

let traverse_foo_lifo t =
 (* traverse_foo_lifo : 'a binary_tree -> 'a list *) 
  traverse_foo Lifo.empty Lifo.enqueue Lifo.dequeue t;;

let t1_foo_lifo = traverse_foo_lifo t1;;
let t2_foo_lifo = traverse_foo_lifo t2;;
let t3_foo_lifo = traverse_foo_lifo t3;;
let t4_foo_lifo = traverse_foo_lifo t4;;

let traced_traverse_foo_lifo_int t =
 (* traced_traverse_foo_lifo_int : int binary_tree -> int list *) 
  traced_traverse_foo show_int Lifo.empty Lifo.enqueue Lifo.dequeue Lifo.show t;;

(*
  # traced_traverse_foo_lifo_int t1;;
  ...
  # traced_traverse_foo_lifo_int t2;;
  ...
  # traced_traverse_foo_lifo_int t3;;
  ...
  # traced_traverse_foo_lifo_int t4;;
  ...
  # 
*)

(* ***** *)

let traverse_foo_fifo t =
 (* traverse_foo_fifo : 'a binary_tree -> 'a list *)
  traverse_foo Fifo.empty Fifo.enqueue Fifo.dequeue t;;

let t1_foo_fifo = traverse_foo_fifo t1;;
let t2_foo_fifo = traverse_foo_fifo t2;;
let t3_foo_fifo = traverse_foo_fifo t3;;
let t4_foo_fifo = traverse_foo_fifo t4;;

let traced_traverse_foo_fifo_int t =
 (* traced_traverse_foo_fifo_int : int binary_tree -> int list *)
  traced_traverse_foo show_int Fifo.empty Fifo.enqueue Fifo.dequeue Fifo.show t;;

(*
traced_traverse_foo_fifo_int t1;;
traced_traverse_foo_fifo_int t2;;
traced_traverse_foo_fifo_int t3;;
traced_traverse_foo_fifo_int t4;;
 *)

(* ***** *)

let traverse_bar empty enqueue dequeue t =
  let rec process q =
    match dequeue q with
    | None ->
       []
    | Some (t, q') ->
       (match t with
        | Leaf x ->
           x :: process q'
        | Node (t1, t2) ->
           process (enqueue t2 (enqueue t1 q')))
  in process (enqueue t empty);;

let traced_traverse_bar show_yourself empty enqueue dequeue show_queue t =
  let rec process q depth =
    Printf.printf "%sprocess_bar %s ->\n" (make_indentation depth) (show_queue (show_binary_tree show_yourself) q);
    match dequeue q with
    | None ->
       Printf.printf "%sprocess_bar %s <- %s\n" (make_indentation depth) (show_queue (show_binary_tree show_yourself) q) (show_list show_yourself []);
       []
    | Some (t, q') ->
       (match t with
        | Leaf x ->
           let result = x :: process q' (succ depth)
           in Printf.printf "%sprocess_bar %s <- %s\n" (make_indentation depth) (show_queue (show_binary_tree show_yourself) q) (show_list show_yourself result);
              result
        | Node (t1, t2) ->
           process (enqueue t2 (enqueue t1 q')) depth)
  in process (enqueue t empty) 0;;

(* ***** *)

let traverse_bar_lifo t =
 (* traverse_bar_lifo : 'a binary_tree -> 'a list *)
  traverse_bar Lifo.empty Lifo.enqueue Lifo.dequeue t;;

let t1_bar_lifo = traverse_bar_lifo t1;;
let t2_bar_lifo = traverse_bar_lifo t2;;
let t3_bar_lifo = traverse_bar_lifo t3;;
let t4_bar_lifo = traverse_bar_lifo t4;;


let traced_traverse_bar_lifo_int t =
 (* traced_traverse_bar_lifo : int binary_tree -> int list *)
  traced_traverse_bar show_int Lifo.empty Lifo.enqueue Lifo.dequeue Lifo.show t;;

(*
  # traced_traverse_bar_lifo_int t1;;
  ...
  # traced_traverse_bar_lifo_int t2;;
  ...
  # traced_traverse_bar_lifo_int t3;;
  ...
  # traced_traverse_bar_lifo_int t4;;
  ...
  # 
*)

(* ***** *)

let traverse_bar_fifo t =
 (* traverse_bar_fifo : 'a binary_tree -> 'a list *)
  traverse_bar Fifo.empty Fifo.enqueue Fifo.dequeue t;;

let t1_bar_fifo = traverse_bar_fifo t1;;
let t2_bar_fifo = traverse_bar_fifo t2;;
let t3_bar_fifo = traverse_bar_fifo t3;;
let t4_bar_fifo = traverse_bar_fifo t4;;


let traced_traverse_bar_fifo_int t =
 (* traced_traverse_bar_fifo_int : int binary_tree -> int list *)
  traced_traverse_bar show_int Fifo.empty Fifo.enqueue Fifo.dequeue Fifo.show t;;

(*
  # traced_traverse_bar_fifo_int t1;;
  ...
  # traced_traverse_bar_fifo_int t2;;
  ...
  # traced_traverse_bar_fifo_int t3;;
  ...
  # traced_traverse_bar_fifo_int t4;;
  ...
  # 
*)

(* ********** *)

let end_of_file = "mini-project_about-depth-first-and-breadth-first-traversals.ml";;

(*
           OCaml version 4.01.0
   
   # #use "mini-project_about-depth-first-and-breadth-first-traversals.ml";;
   val make_indentation : int -> string = <fun>
   val show_bool : bool -> string = <fun>
   val show_int : int -> string = <fun>
   val show_list : ('a -> string) -> 'a list -> string = <fun>
   module type QUEUE =
     sig
       type 'a queue
       val empty : 'a queue
       val is_empty : 'a queue -> bool
       val enqueue : 'a -> 'a queue -> 'a queue
       val dequeue : 'a queue -> ('a * 'a queue) option
       val show : ('a -> string) -> 'a queue -> string
     end
   val test_lifo_queue_int_one : string -> bool -> bool = <fun>
   val test_lifo_queue_int : 'a -> ('a -> bool) -> (int -> 'a -> 'a) -> ('a -> (int * 'a) option) -> bool = <fun>
   val test_fifo_queue_int_one : string -> bool -> bool = <fun>
   val test_fifo_queue_int : 'a -> ('a -> bool) -> (int -> 'a -> 'a) -> ('a -> (int * 'a) option) -> bool = <fun>
   module Lifo : QUEUE
   module Fifo : QUEUE
   type 'a binary_tree = Leaf of 'a | Node of 'a binary_tree * 'a binary_tree
   val show_binary_tree : ('a -> string) -> 'a binary_tree -> string = <fun>
   val binary_tree_fold : ('a -> 'b) -> ('b -> 'b -> 'b) -> 'a binary_tree -> 'b = <fun>
   val t1 : int binary_tree = Node (Node (Leaf 3, Leaf 2), Node (Node (Leaf 5, Leaf 4), Leaf 1))
   val t2 : int binary_tree = Node (Node (Leaf 1, Leaf 2), Node (Node (Leaf 3, Leaf 4), Leaf 5))
   val t3 : int binary_tree = Node (Node (Leaf 5, Leaf 4), Node (Node (Leaf 3, Leaf 2), Leaf 1))
   val t4 : int binary_tree = Node (Node (Leaf 1, Leaf 2), Node (Node (Leaf 4, Leaf 5), Leaf 3))
   val traverse_foo : 'a -> ('b binary_tree -> 'a -> 'a) -> ('a -> ('b binary_tree * 'a) option) -> 'b binary_tree -> 'b list = <fun>
   val traced_traverse_foo : ('a -> string) -> 'b -> ('a binary_tree -> 'b -> 'b) -> ('b -> ('a binary_tree * 'b) option) -> (('a binary_tree -> string) -> 'b -> string) -> 'a binary_tree -> 'a list = <fun>
   val traverse_foo_lifo : 'a binary_tree -> 'a list = <fun>
   val t1_foo_lifo : int list = [3; 2; 5; 4; 1]
   val t2_foo_lifo : int list = [1; 2; 3; 4; 5]
   val t3_foo_lifo : int list = [5; 4; 3; 2; 1]
   val t4_foo_lifo : int list = [1; 2; 4; 5; 3]
   val traced_traverse_foo_lifo_int : int binary_tree -> int list = <fun>
   val traverse_foo_fifo : 'a binary_tree -> 'a list = <fun>
   val t1_foo_fifo : int list = [1; 2; 3; 4; 5]
   val t2_foo_fifo : int list = [5; 2; 1; 4; 3]
   val t3_foo_fifo : int list = [1; 4; 5; 2; 3]
   val t4_foo_fifo : int list = [3; 2; 1; 5; 4]
   val traced_traverse_foo_fifo_int : int binary_tree -> int list = <fun>
   val traverse_bar : 'a -> ('b binary_tree -> 'a -> 'a) -> ('a -> ('b binary_tree * 'a) option) -> 'b binary_tree -> 'b list = <fun>
   val traced_traverse_bar : ('a -> string) -> 'b -> ('a binary_tree -> 'b -> 'b) -> ('b -> ('a binary_tree * 'b) option) -> (('a binary_tree -> string) -> 'b -> string) -> 'a binary_tree -> 'a list = <fun>
   val traverse_bar_lifo : 'a binary_tree -> 'a list = <fun>
   val t1_bar_lifo : int list = [1; 4; 5; 2; 3]
   val t2_bar_lifo : int list = [5; 4; 3; 2; 1]
   val t3_bar_lifo : int list = [1; 2; 3; 4; 5]
   val t4_bar_lifo : int list = [3; 5; 4; 2; 1]
   val traced_traverse_bar_lifo_int : int binary_tree -> int list = <fun>
   val traverse_bar_fifo : 'a binary_tree -> 'a list = <fun>
   val t1_bar_fifo : int list = [3; 2; 1; 5; 4]
   val t2_bar_fifo : int list = [1; 2; 5; 3; 4]
   val t3_bar_fifo : int list = [5; 4; 1; 3; 2]
   val t4_bar_fifo : int list = [1; 2; 3; 4; 5]
   val traced_traverse_bar_fifo_int : int binary_tree -> int list = <fun>
   val end_of_file : string = "mini-project_about-depth-first-and-breadth-first-traversals.ml"
   # 
*)
