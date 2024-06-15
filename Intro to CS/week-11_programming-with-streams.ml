(* week-11_programming-with-streams.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sun 10 Apr 2022, with time and how_long *)
(* was: *)
(* Version of Sat 02 Apr 2022 *)

(* ********** *)

let time thunk =
  let time = Sys.time ()
  in (thunk ();
      Printf.sprintf "Elapsed time: %f seconds" (Sys.time() -. time));;

let how_long thunk =
  let time = Sys.time ()
  in let result = thunk ()
     in (Printf.sprintf "Elapsed time: %f seconds" (Sys.time() -. time), result);;

(*
   # how_long (fun () -> 42);;
   - : string * int = ("Elapsed time: 0.000006 seconds", 42)
   # 
*)

let how_long' thunk =
  let time = Sys.time ()
  in let result = thunk ()
     in (Sys.time() -. time, result);;

(* ********** *)

let iota n_init =
 (* iota : int -> int list *)
  let () = assert (n_init >= 0) in
  let rec visit n a =
    match n with
    | 0 ->
       a
    | _ ->
       let n' = pred n
       in visit n' (n' :: a)
  in visit n_init [];;

(* ********** *)

type 'a stream =
  | Scons of 'a * 'a stream Lazy.t;;

let shd (Scons (v, _)) =
 (* shd : 'a stream -> 'a *)
  v;;

let stl (Scons (_, ds)) =
 (* stl : 'a stream -> 'a stream *)
  Lazy.force ds;;

let stream_nth s n =
 (* stream_nth : 'a stream -> int -> 'a *)
  let () = assert (n >= 0) in
  let rec loop n (Scons (v, s')) =
    if n = 0
    then v
    else loop (pred n) (Lazy.force s')
  in loop n s;;

(* ********** *)

let stream_make seed_init next =
 (* stream_make : 'a -> ('a -> 'a) -> 'a stream *)
  let rec emanate seed_current =
       (* emanate : 'a -> 'a stream *)
    Scons (seed_current, lazy (emanate (next seed_current)))
  in emanate seed_init;;

let nats = stream_make 0 succ;;

let posnats = stream_make 1 succ;;

let evens = stream_make 0 (fun i -> i + 2);;

let odds = stream_make 1 (fun i -> i + 2);;

(* ********** *)

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

let () = assert (test_nats nats);;

(* ********** *)

let test_posnats candidate =
  match candidate with
  | Scons (1, s1) ->
     (match Lazy.force s1 with
      | Scons (2, s2) ->
         (match Lazy.force s2 with
          | Scons (3, s3) ->
             (match Lazy.force s3 with
              | Scons (4, s4) ->
                 (match Lazy.force s4 with
                  | Scons (5, s5) ->
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

let () = assert (test_posnats posnats);;

(* ********** *)

let stream_prefix s n =
 (* stream_prefix : 'a stream -> int -> 'a list *)
  let () = assert (n >= 0) in
  let rec visit n (Scons (v, s')) =
    if n = 0
    then []
    else let ih = visit (pred n) (Lazy.force s')
         in v :: ih
  in visit n s;;

(* ********** *)

let stutter2 vs_init =
 (* stutter2 : 'a list -> 'a list *)
  let rec visit vs =
       (* visit : 'a list -> 'a list *)
    match vs with
    | [] ->
       []
    | v :: vs' ->
       v :: v :: visit vs'
  in visit vs_init;;

let test_stream_stutter2 candidate =
  let b0 = (let n = Random.int 100
            in stream_prefix (candidate nats) (2 * n)
               = stutter2 (iota n))
  (* etc. *)
  in b0;;

let rec stream_stutter2 (Scons (v, ds)) =
  Scons (v, lazy (Scons (v, lazy (stream_stutter2 (Lazy.force ds)))));;

let () = assert (test_stream_stutter2 stream_stutter2);;

(* ********** *)

let test_stream_map candidate =
  let b0 = (let n = Random.int 100
            in stream_prefix (candidate succ nats) n = stream_prefix posnats n)
  and b1 = (let n = Random.int 100
            in stream_prefix (candidate (fun i -> 2 * i) nats) n = stream_prefix evens n)
  in b0 && b1;;

let stream_map f s =
 (* stream_map : ('a -> 'b) -> 'a stream -> 'b stream *)
  let rec visit (Scons (v, ds)) =
       (* visit : 'a stream -> 'b stream *)
    Scons (f v, lazy (visit (Lazy.force ds)))
  in visit s;;
  
let () = assert (test_stream_map stream_map);;

(* ***** *)

let stream_map2 f s1 s2 =
 (* stream_map2 : ('a -> 'b -> 'c) -> 'a stream -> 'b stream -> 'c stream *)
  let rec visit2 (Scons (v1, ds1)) (Scons (v2, ds2)) =
       (* visit2 : 'a stream -> 'b stream -> 'c stream *)
    Scons (f v1 v2, lazy (visit2 (Lazy.force ds1) (Lazy.force ds2)))
  in visit2 s1 s2;;

let () = assert (let n = Random.int 1000
                 in stream_nth (stream_map2 (+)
                                            (stream_make 1 succ)    (* stream of positive integers *)
                                            (stream_make ~-1 pred)) (* stream of negative integers *)
                               n
                    = 0)

(* ********** *)

let test_stream_filter_out candidate =
  let b0 = (stream_prefix (candidate (fun i -> i mod 2 = 1) nats) 20
            =  stream_prefix evens 20)
  and b1 = (stream_prefix (candidate (fun i -> i mod 2 = 0) nats) 20
            = stream_prefix odds 20)
  (* etc. *)
  in b0 && b1;;

(* ***** *)

let stream_filter_out_v0 p xs_init =
  let rec visit xs =
    if p (shd xs)
    then visit (stl xs)
    else Scons (shd xs, lazy (visit (stl xs)))
  in visit xs_init;;

let () = assert (test_stream_filter_out stream_filter_out_v0);;

(* ***** *)

let stream_filter_out_v1 p xs_init =
  let rec visit xs =
    let x = shd xs
    and xs' = stl xs
    in if p x
       then visit xs'
       else Scons (x, lazy (visit xs'))
  in visit xs_init;;

let () = assert (test_stream_filter_out stream_filter_out_v1);;

(* ***** *)

let stream_filter_out_v2 p xs_init =
  let rec visit xs =
    match xs with
    | Scons (x, suspended_xs') ->
       if p x
       then visit (Lazy.force suspended_xs')
       else Scons (x, lazy (visit (Lazy.force suspended_xs')))
  in visit xs_init;;

let () = assert (test_stream_filter_out stream_filter_out_v2);;

(* ***** *)

let stream_filter_out_v3 p xs_init =
  let rec visit (Scons (x, suspended_xs')) =
    if p x
    then visit (Lazy.force suspended_xs')
    else Scons (x, lazy (visit (Lazy.force suspended_xs')))
  in visit xs_init;;

let () = assert (test_stream_filter_out stream_filter_out_v3);;

(* ********** *)

let stream_of_prime_numbers =
  let rec down_this_stream (Scons (x, ds')) =
    Scons (x, lazy (down_this_stream (stream_filter_out_v3 (fun i -> i mod x = 0) (Lazy.force ds'))))
  in down_this_stream (stream_make 2 succ);;

(* ********** *)

let test_stream_of_pairs_of_successive_non_negative_integers candidate =
  let b0 = (stream_prefix candidate 0 =
              [])
  and b1 = (stream_prefix candidate 1 =
              [(0, 1)])
  and b7 = (stream_prefix candidate 7 =
              [(0, 1); (2, 3); (4, 5); (6, 7); (8, 9); (10, 11); (12, 13)])
  in b0 && b1 && b7;;

let stream_of_pairs_of_successive_non_negative_integers_v0 = 
  stream_make (0, 1) (fun (_, j) -> (j + 1, j + 2));;
  
let () = assert (test_stream_of_pairs_of_successive_non_negative_integers stream_of_pairs_of_successive_non_negative_integers_v0);;

(* ***** *)

let test_stream_of_triples_of_successive_non_negative_integers candidate =
  let b0 = (stream_prefix candidate 0 =
              [])
  and b1 = (stream_prefix candidate 1 =
              [(0, 1, 2)])
  and b5 = (stream_prefix candidate 5 =
              [(0, 1, 2); (3, 4, 5); (6, 7, 8); (9, 10, 11); (12, 13, 14)])
  in b0 && b1 && b5;;

let stream_of_triples_of_successive_non_negative_integers_v0 =
  stream_make (0, 1, 2) (fun (_, _, k) -> (k + 1, k + 2, k + 3));;

let () = assert (test_stream_of_triples_of_successive_non_negative_integers stream_of_triples_of_successive_non_negative_integers_v0);;

let test_transduce_2_3_int candidate =
  let b0 = test_stream_of_triples_of_successive_non_negative_integers
             (candidate stream_of_pairs_of_successive_non_negative_integers_v0)
  and b1 = let n = Random.int 100
           in stream_prefix (candidate stream_of_pairs_of_successive_non_negative_integers_v0) n
              = stream_prefix stream_of_triples_of_successive_non_negative_integers_v0 n
  in b0 && b1;;

let test_transduce_3_2_int candidate =
  let b0 = test_stream_of_pairs_of_successive_non_negative_integers
             (candidate stream_of_triples_of_successive_non_negative_integers_v0)
  and b1 = let n = Random.int 100
           in stream_prefix (candidate stream_of_triples_of_successive_non_negative_integers_v0) n
              = stream_prefix stream_of_pairs_of_successive_non_negative_integers_v0 n
  in b0 && b1;;

let rec transduce_2_3 (Scons ((v1, v2), ds1)) =
     (* transduce_2_3 : ('a * 'a) stream -> ('a * 'a * 'a) stream *)
  let (Scons ((v3, v4), ds2)) = Lazy.force ds1
     in Scons ((v1, v2, v3),
               lazy (let (Scons ((v5, v6), ds3)) = Lazy.force ds2
                     in Scons ((v4, v5, v6),
                               lazy (transduce_2_3 (Lazy.force ds3)))));;

let () = assert (test_transduce_2_3_int transduce_2_3);;

let rec transduce_3_2 (Scons ((v1, v2, v3), ds1)) =
     (* transduce_3_2 : ('a * 'a * 'a) stream -> ('a * 'a) stream *)
  Scons ((v1, v2),
         lazy (let (Scons ((v4, v5, v6), ds2)) = Lazy.force ds1
               in Scons ((v3, v4),
                         lazy (Scons ((v5, v6),
                                      lazy (transduce_3_2 (Lazy.force ds2)))))));;

let () = assert (test_transduce_3_2_int transduce_3_2);;

(* ***** *)

let rec transduce_1_2 (Scons (v1, ds1)) =
    (* transduce_1_2 : 'a stream -> ('a * 'a) stream *)
  let (Scons (v2, ds2)) = Lazy.force ds1
  in Scons ((v1, v2), lazy (transduce_1_2 (Lazy.force ds2)));;

let stream_of_pairs_of_successive_non_negative_integers_v1 = 
  transduce_1_2 nats;;

let () = assert (test_stream_of_pairs_of_successive_non_negative_integers stream_of_pairs_of_successive_non_negative_integers_v1);;

let stream_of_triples_of_successive_non_negative_integers_v1 = 
  transduce_2_3 (transduce_1_2 nats);;

let () = assert (test_stream_of_triples_of_successive_non_negative_integers stream_of_triples_of_successive_non_negative_integers_v1);;

let transduce_1_3 s =
 (* transduce_1_3 : 'a stream -> ('a * 'a * 'a) stream *)
  transduce_2_3 (transduce_1_2 s);;

(* ********** *)

let test_fibs candidate =
  match candidate with
  | Scons (0, s1) ->
     (match Lazy.force s1 with
      | Scons (1, s2) ->
         (match Lazy.force s2 with
          | Scons (1, s3) ->
             (match Lazy.force s3 with
              | Scons (2, s4) ->
                 (match Lazy.force s4 with
                  | Scons (3, s5) ->
                     (match Lazy.force s5 with
                      | Scons (5, s6) ->
                         (match Lazy.force s6 with
                          | Scons (8, s7) ->
                             (match Lazy.force s7 with
                              | Scons (13, s7) ->
                                 true
                              |  _ ->
                                  false)
                          |  _ ->
                              false)
                      |  _ ->
                          false)
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

let rec fib n =
  match n with
  | 0 -> 0
  | 1 -> 1
  | _ -> fib (n - 1) + fib (n - 2);;

let fibs_from_scratch =
  let rec make_fibs n =
    Scons (fib n, lazy (make_fibs (succ n)))
  in make_fibs 0;;

let () = assert (test_fibs fibs_from_scratch);;

let fibs_incremental =
  let rec make_fibs fib_i fib_succ_i =
    Scons (fib_i, lazy (make_fibs fib_succ_i (fib_i + fib_succ_i)))
  in make_fibs 0 1;;

let () = assert (test_fibs fibs_incremental);;

let fibs_incremental' =
  let rec make_fibs fib_i fib_i_plus_1 =
    Scons (fib_i,
           lazy (Scons (fib_i_plus_1,
                        let fib_i_plus_2 = fib_i + fib_i_plus_1
                        in let fib_i_plus_3 = fib_i_plus_1 + fib_i_plus_2
                           in lazy (make_fibs fib_i_plus_2 fib_i_plus_3))))
  in make_fibs 0 1;;

let () = assert (test_fibs fibs_incremental');;

(* ********** *)

let rec nats_bootstrapped =
  Scons (0, lazy (stream_map succ nats_bootstrapped));;

let () = assert (test_nats nats_bootstrapped);;

let rec fibs_bootstrapped = 
  Scons (0, lazy (Scons (1, lazy (stream_map2 (+) fibs_bootstrapped (stl fibs_bootstrapped)))));;

let () = assert (test_fibs fibs_bootstrapped);;

(* ***** *)

let rec fibs_bootstrapped' = 
  let rec tail_fibs_bootstrapped' = Scons (1, lazy (stream_map2 (+) fibs_bootstrapped' tail_fibs_bootstrapped'))
  in Scons (0, lazy tail_fibs_bootstrapped');;

let () = assert (test_fibs fibs_bootstrapped');;

(* ********** *)

let end_of_file = "week-11_programming-with-streams.ml";;

(*
           OCaml version 4.01.0
   
   # #use "week-11_programming-with-streams.ml";;
   val iota : int -> int list = <fun>
   type 'a stream = Scons of 'a * 'a stream Lazy.t
   val shd : 'a stream -> 'a = <fun>
   val stl : 'a stream -> 'a stream = <fun>
   val stream_nth : 'a stream -> int -> 'a = <fun>
   val stream_make : 'a -> ('a -> 'a) -> 'a stream = <fun>
   val nats : int stream = Scons (0, <lazy>)
   val posnats : int stream = Scons (1, <lazy>)
   val evens : int stream = Scons (0, <lazy>)
   val odds : int stream = Scons (1, <lazy>)
   val test_nats : int stream -> bool = <fun>
   val test_posnats : int stream -> bool = <fun>
   val stream_prefix : 'a stream -> int -> 'a list = <fun>
   val stutter2 : 'a list -> 'a list = <fun>
   val test_stream_stutter2 : (int stream -> int stream) -> bool = <fun>
   val stream_stutter2 : 'a stream -> 'a stream = <fun>
   val test_stream_map : ((int -> int) -> int stream -> int stream) -> bool = <fun>
   val stream_map : ('a -> 'b) -> 'a stream -> 'b stream = <fun>
   val stream_map2 : ('a -> 'b -> 'c) -> 'a stream -> 'b stream -> 'c stream = <fun>
   val test_stream_filter_out : ((int -> bool) -> int stream -> int stream) -> bool = <fun>
   val stream_filter_out_v0 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
   val stream_filter_out_v1 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
   val stream_filter_out_v2 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
   val stream_filter_out_v3 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
   val stream_of_prime_numbers : int stream = Scons (2, <lazy>)
   val test_stream_of_pairs_of_successive_non_negative_integers : (int * int) stream -> bool = <fun>
   val stream_of_pairs_of_successive_non_negative_integers_v0 : (int * int) stream = Scons ((0, 1), <lazy>)
   val test_stream_of_triples_of_successive_non_negative_integers : (int * int * int) stream -> bool = <fun>
   val stream_of_triples_of_successive_non_negative_integers_v0 : (int * int * int) stream = Scons ((0, 1, 2), <lazy>)
   val test_transduce_2_3_int : ((int * int) stream -> (int * int * int) stream) -> bool = <fun>
   val test_transduce_3_2_int : ((int * int * int) stream -> (int * int) stream) -> bool = <fun>
   val transduce_2_3 : ('a * 'a) stream -> ('a * 'a * 'a) stream = <fun>
   val transduce_3_2 : ('a * 'a * 'a) stream -> ('a * 'a) stream = <fun>
   val transduce_1_2 : 'a stream -> ('a * 'a) stream = <fun>
   val stream_of_pairs_of_successive_non_negative_integers_v1 : (int * int) stream = Scons ((0, 1), <lazy>)
   val stream_of_triples_of_successive_non_negative_integers_v1 : (int * int * int) stream = Scons ((0, 1, 2), <lazy>)
   val transduce_1_3 : 'a stream -> ('a * 'a * 'a) stream = <fun>
   val test_fibs : int stream -> bool = <fun>
   val fib : int -> int = <fun>
   val fibs_from_scratch : int stream = Scons (0, <lazy>)
   val fibs_incremental : int stream = Scons (0, <lazy>)
   val fibs_incremental' : int stream = Scons (0, <lazy>)
   val nats_bootstrapped : int stream = Scons (0, <lazy>)
   val fibs_bootstrapped : int stream = Scons (0, <lazy>)
   val fibs_bootstrapped' : int stream = Scons (0, lazy (Scons (1, <lazy>)))
   val end_of_file : string = "week-11_programming-with-streams.ml"
   # 
*)
