(* week-11_streams.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 02 Apr 2022 *)

(* ********** *)

type 'a stream =
  | Scons of 'a * 'a stream Lazy.t;;

(* ***** *)

let shd s =
 (* shd : 'a stream -> 'a *)
  match s with
  | Scons (v, _) ->
     v;;

(* or more concisely: *)

let shd (Scons (v, _)) =
 (* shd : 'a stream -> 'a *)
  v;;

(* ***** *)

let stl s =
 (* stl : 'a stream -> 'a stream *)
  match s with
  | Scons (_, ds) ->
     Lazy.force ds;;

(* or more concisely: *)

let stl (Scons (_, ds)) =
 (* stl : 'a stream -> 'a stream *)
  Lazy.force ds;;

(* ********** *)

let stream_make seed next =
 (* stream_make : 'a -> ('a -> 'a) -> 'a stream *)
  let rec produce v =
       (* produce : 'a -> 'a stream *)
    Scons (v, lazy (produce (next v)))
  in produce seed;;

(* ********** *)

(* the stream of natural numbers: *)

let test_nats candidate =
  match candidate with
  | Scons (0, s1) ->
     (match Lazy.force s1 with
      | Scons (1, s2) ->
         (match Lazy.force s2 with
          | Scons (2, s3) ->
             (match Lazy.force s3 with
              | Scons (3, s4) ->
                 (match Lazy.force s4 with
                  | Scons (4, s5) ->
                     true
                  |  _ ->
                      false)
              |  _ ->
                  false)
          |  _ ->
              false)
      |  _ ->
          false)
  | _ ->
     false;;

let nats = stream_make 0 succ;;

let () = assert (test_nats nats);;

(* ********** *)

(* the stream of positive integers: *)

let test_posints candidate =
  match candidate with
  | Scons (1, s2) ->
     (match Lazy.force s2 with
      | Scons (2, s3) ->
         (match Lazy.force s3 with
          | Scons (3, s4) ->
             (match Lazy.force s4 with
              | Scons (4, s5) ->
                 true
              |  _ ->
                  false)
          |  _ ->
              false)
      |  _ ->
          false)
  | _ ->
     false;;

let posints = stream_make 1 succ;;

let () = assert (test_posints posints);;

(* ********** *)

(* the stream of even natural numbers: *)

let test_evens candidate =
  match candidate with
  | Scons (0, s1) ->
     (match Lazy.force s1 with
      | Scons (2, s2) ->
         (match Lazy.force s2 with
          | Scons (4, s3) ->
             (match Lazy.force s3 with
              | Scons (6, s4) ->
                 (match Lazy.force s4 with
                  | Scons (8, s5) ->
                     true
                  |  _ ->
                      false)
              |  _ ->
                  false)
          |  _ ->
              false)
      |  _ ->
          false)
  | _ ->
     false;;

let evens = stream_make 0 (fun i -> i + 2);;

let () = assert (test_evens evens);;

(* ********** *)

(* the stream of odd natural numbers: *)

let test_odds candidate =
  match candidate with
  | Scons (1, s1) ->
     (match Lazy.force s1 with
      | Scons (3, s2) ->
         (match Lazy.force s2 with
          | Scons (5, s3) ->
             (match Lazy.force s3 with
              | Scons (7, s4) ->
                 (match Lazy.force s4 with
                  | Scons (9, s5) ->
                     true
                  |  _ ->
                      false)
              |  _ ->
                  false)
          |  _ ->
              false)
      |  _ ->
          false)
  | _ ->
     false;;

let odds = stream_make 1 (fun i -> i + 2);;

let () = assert (test_odds odds);;

(* ********** *)

let rec stream_merge (Scons (v1, s1)) (Scons (v2, s2)) =
     (* stream_merge : 'a stream -> 'a stream -> 'a stream *)
  Scons (v1,
         lazy (Scons (v2,
                      lazy (stream_merge (Lazy.force s1)
                                         (Lazy.force s2)))));;

let () = assert (test_nats (stream_merge evens odds));;

(* ********** *)

let test_stream_nth_int candidate =
  let b0 = (candidate nats 0 = 0)
  and b1 = (candidate nats 10 = 10)
  and b2 = (candidate evens 10 = 20)
  and b3 = (candidate evens 100 = 200)
  and b4 = (candidate odds 10 = 21)
  and b5 = (candidate odds 100 = 201)
  (* new: *)
  and b6 = let i = Random.int 1000
           in candidate nats i = i
  and b7 = let i = Random.int 1000
           in candidate evens i = 2 * i
  and b8 = let i = Random.int 1000
           in candidate odds i = 2 * i + 1
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8;;

let stream_nth s n =
 (* stream_nth : 'a stream -> int -> 'a *)
  assert (n >= 0);
  let rec loop n (Scons (v, s')) =
    if n = 0
    then v
    else loop (pred n) (Lazy.force s')
  in loop n s;;

let () = assert (test_stream_nth_int stream_nth);;

(* ********** *)

let iota n_init =
 (* iota : int -> int list *)
  let rec visit n a =
    match n with
    | 0 ->
       a
    | _ ->
       let n' = pred n
       in visit n' (n' :: a)
  in visit n_init [];;

let test_stream_prefix_int candidate =
  let b0 = (candidate nats 0 = [])
  and b1 = (candidate nats 5 = [0; 1; 2; 3; 4])
  and b2 = (candidate evens 4 = [0; 2; 4; 6])
  and b3 = (candidate odds 6 = [1; 3; 5; 7; 9; 11])
  (* new *)
  and b4 = let n = Random.int 1000
           in candidate nats n = iota n
  and b5 = let n = Random.int 1000
           in candidate evens n = List.map (fun i -> 2 * i) (iota n)
  and b6 = let n = Random.int 1000
           in candidate odds n = List.map (fun i -> 2 * i + 1) (iota n)
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6;;

let stream_prefix s n =
 (* stream_prefix : 'a stream -> int -> 'a list *)
  assert (n >= 0);
  let rec visit n (Scons (v, s')) =
    if n = 0
    then []
    else let ih = visit (pred n) (Lazy.force s')
         in v :: ih
  in visit n s;;

let () = assert (test_stream_prefix_int stream_prefix);;

(* ********** *)

let test_stream_prepend_int candidate =
  let test vs s =
    stream_prefix (candidate vs s) (List.length vs) = vs
  in let b0 = test [] nats
     and b1 = test [-1] nats
     and b2 = test [-2; -1] nats
     and b3 = test [-3; -2; -1] nats
     in b0 && b1 && b2 && b3;;

let expanded_test_stream_prepend_int candidate =
  let new_test vs s =
    let x = Random.int 100
    in stream_prefix (candidate vs s) (List.length vs + x) = vs @ stream_prefix s x
  in let b0 = new_test [] nats
     and b1 = new_test [-1] nats
     and b2 = new_test [-2; -1] nats
     and b3 = new_test [-3; -2; -1] nats
     in b0 && b1 && b2 && b3;;

let stream_prepend vs s =
  let rec visit vs s =
    match vs with
    | [] ->
       s
    | v :: vs' ->
       let ih = visit vs' s
       in Scons (v, lazy ih)
  in visit vs s;;

let () = assert (test_stream_prepend_int stream_prepend);;

let () = assert (expanded_test_stream_prepend_int stream_prepend);;

let stream_prepend' vs s =
  let rec visit vs s =
    match vs with
    | [] ->
       s
    | v :: vs' ->
       Scons (v, lazy (visit vs' s))
  in visit vs s;;

let () = assert (test_stream_prepend_int stream_prepend');;

let () = assert (expanded_test_stream_prepend_int stream_prepend');;

(* ********** *)

let test_stream_suffix_int candidate =
  let b0 = (let n = Random.int 100
            in stream_prefix (candidate nats 0) n = stream_prefix nats n)
  and b1 = (let n = Random.int 100
            in stream_prefix (candidate nats 1) n = stream_prefix posints n)
  (* etc. *)
  in b0 && b1;;

let fake_stream_suffix s n =
  if n = 0
  then s
  else let (Scons (_, ds')) = s
       in if n = 1
          then Lazy.force ds'
          else s;;

let () = assert (test_stream_suffix_int fake_stream_suffix);;

(* ********** *)

let test_compare_stream_prefixes candidate =
  let b0 = (let n = Random.int 100
            in candidate nats nats n = true)
  and b1 = (let n = Random.int 100
            in candidate evens odds (succ n) = false)
  (* etc. *)
  in b0 && b1;;

let compare_stream_prefixes_v0 s1 s2 n =
  stream_prefix s1 n = stream_prefix s2 n;;

let () = assert (test_compare_stream_prefixes compare_stream_prefixes_v0);;

(* ********** *)

let test_one_and_minus_one_star candidate_stream =
  (stream_prefix candidate_stream 10 = [1; -1; 1; -1; 1; -1; 1; -1; 1; -1]);;

(* ********** *)

let test_zero_and_minus_one_star candidate_stream =
  (stream_prefix candidate_stream 10 = [0; -1; 0; -1; 0; -1; 0; -1; 0; -1]);;

(* ********** *)

let test_interleaved_negative_and_positive_nats candidate_stream =
  (stream_prefix candidate_stream 10 = [0; -1; 2; -3; 4; -5; 6; -7; 8; -9]);;

(* ********** *)

let test_interleaved_ints candidate_stream =
  (stream_prefix candidate_stream 10 = [0; -1; 1; -2; 2; -3; 3; -4; 4; -5]);;

(* ********** *)

(* Exercise 23 *)
let test_stream_filter_in candidate =
  let b0 = (stream_prefix (candidate (fun i -> i mod 2 = 1) nats) 20
            = stream_prefix odds 20)
  and b1 = (stream_prefix (candidate (fun i -> i mod 2 = 0) nats) 20
            = stream_prefix evens 20)
  in b0 && b1;;

let stream_filter_in p xs_given =
  let rec visit (Scons (x, dxs')) =
    if p x
    then Scons (x, lazy (visit (Lazy.force dxs')))
    else visit (Lazy.force dxs')
  in visit xs_given;;

let () = assert (test_stream_filter_in  stream_filter_in);;

(* Could you define stream_filter_in using stream_filter_out? *)

let stream_filter_out p xs_given =
  let rec visit (Scons (x, dxs')) =
    if p x
    then visit (Lazy.force dxs')
    else Scons (x, lazy (visit (Lazy.force dxs')))
  in visit xs_given;;



(* Exercise 25 *)

(* 1 *)

let rec fib n =
  match n with
  | 0 -> 0
  | 1 -> 1
  | _ -> fib (n - 1) + fib (n - 2);;

let fibs_from_scratch =
  let rec make_fibs n =
    Scons (fib n, lazy (make_fibs (succ n)))
  in make_fibs 0;;

how_long (fun () -> stream_prefix fibs_from_cratch 35);;
  


let end_of_file = "week-11_streams.ml";;


