(* Streams *)

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


(* Stutter, for lists *)
let stutter2 vs_given =
 (* stutter2 : 'a list -> 'a list *)
  let rec visit vs =
       (* visit : 'a list -> 'a list *)
    match vs with
    | [] ->
       []
    | v :: vs' ->
       let ih = visit vs'
       in v :: v :: ih
  in visit vs_given;;


(* Stutter unit test *)
let test_stream_stutter2 candidate =
  let b0 = (let n = Random.int 100
            in stream_prefix (candidate nats) (2 * n)
               = stutter2 (iota n))
  (* etc. *)
  in b0;;


(* Stutter *)
let rec stream_stutter2 (Scons (v, ds)) =
  Scons (v, lazy (Scons (v, lazy (stream_stutter2 (Lazy.force ds)))));;



let test_stream_filter_out candidate =
  let b0 = (stream_prefix (candidate (fun i -> i mod 2 = 1) nats) 20
            =  stream_prefix evens 20)
  and b1 = (stream_prefix (candidate (fun i -> i mod 2 = 0) nats) 20
            = stream_prefix odds 20)
  (* etc. *)
  in b0 && b1;;



let test_stream_filter_out candidate =
  let b0 = (stream_prefix (candidate (fun i -> i mod 2 = 1) nats) 20
            =  stream_prefix evens 20)
  and b1 = (stream_prefix (candidate (fun i -> i mod 2 = 0) nats) 20
            = stream_prefix odds 20)
  (* etc. *)
  in b0 && b1;;


let stream_filter_out_v0 p xs_given =
  let rec visit xs =
    if p (shd xs)
    then visit (stl xs)
    else Scons (shd xs, lazy (visit (stl xs)))
  in visit xs_given;;



let stream_filter_out_v1 p xs_given =
  let rec visit xs =
    let x = shd xs
    and xs' = stl xs
    in if p x
       then visit xs'
       else Scons (x, lazy (visit xs'))
  in visit xs_given;;


let stream_filter_out_v2 p xs_given =
  let rec visit xs =
    match xs with
    | Scons (x, dxs') ->
       if p x
       then visit (Lazy.force dxs')
       else Scons (x, lazy (visit (Lazy.force dxs')))
  in visit xs_given;;



let stream_filter_out_v3 p xs_given =
  let rec visit (Scons (x, dxs')) =
    if p x
    then visit (Lazy.force dxs')
    else Scons (x, lazy (visit (Lazy.force dxs')))
  in visit xs_given;;





(* Stream filter in *)
(* Exercise 23 of final report *)
(* Unit test *)
let posnats = stream_make 1 (fun i -> i + 1);;

(* Evens and odds defined above *)

(* Use evens, posnats and odds streams for our unit test*) 

let test_stream_filter_in candidate =
  let b0 = (stream_prefix (candidate (fun i -> i > 0) posnats) 20 = stream_prefix posnats 20)
  and b1 = (stream_prefix (candidate (fun i -> i > 0) nats) 20 = stream_prefix posnats 20)
  and b2 = (stream_prefix (candidate (fun i -> i >= 0) nats) 20 = stream_prefix nats 20)
  and b3 = (stream_prefix (candidate (fun i -> i mod 2 = 1) nats) 20 = stream_prefix odds 20)
  and b4 = (stream_prefix (candidate (fun i -> i mod 2 = 0) nats) 20 = stream_prefix evens 20)
  in b0 && b1 && b2 && b3 && b4;;




(* Implementation *)

let stream_filter_in p xs_given =
  let rec visit (Scons(x, dxs')) =
    if p x
    then Scons (x, lazy (visit (Lazy.force dxs')))
    else visit (Lazy.force dxs')
  in visit xs_given;;


let () = assert (test_stream_filter_in stream_filter_in);;


(* stream_filter_in might not return a result, if it the recursive function does not terminate: 

# stream_filter_in (fun i -> i mod 2 = 1) evens;;
  C-c C-cInterrupted.

 *)

(* We can also define stream_filter_in using stream_filter_out *)

let stream_filter_in_using_filter_out p (Scons (x, dxs')) = 
  stream_filter_out_v1 (fun x -> not (p x)) (Scons (x, dxs'));;

let () = assert (test_stream_filter_in stream_filter_in_using_filter_out);;








(* FIBONACCI *)
(* Exercise 25 *)
(* Unit test for fibonacci streams *)
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


(* Fibonaccis *)
let rec fib n =
  match n with
  | 0 -> 0
  | 1 -> 1
  | _ -> fib (n - 1) + fib (n - 2);;


(* Create a fibonacci stream *)
let fibs_from_scratch =
  let rec make_fibs n =
    Scons (fib n, lazy (make_fibs (succ n)))
  in make_fibs 0;;


(* For exercise 25, we use the how_long function that takes a parameterless function and applies it, returning the result of the function application as well as how long it took for OCaml to perform the application. *)

(* 1 *) 
how_long (fun () -> stream_prefix fibs_from_scratch 35);;

(* "Elapsed time: 1.252032 seconds",
 [0; 1; 1; 2; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 610; 987; 1597;
  2584; 4181; 6765; 10946; 17711; 28657; 46368; 75025; 121393; 196418;
  317811; 514229; 832040; 1346269; 2178309; 3524578; 5702887]) *)

(* 2 *) 
how_long (fun () -> stream_prefix fibs_from_scratch 35);;

(* ("Elapsed time: 0.000009 seconds",
 [0; 1; 1; 2; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 610; 987; 1597;
  2584; 4181; 6765; 10946; 17711; 28657; 46368; 75025; 121393; 196418;
  317811; 514229; 832040; 1346269; 2178309; 3524578; 5702887])

 *)

(* 4 *) 

how_long (fun () -> stream_prefix fibs_from_scratch 34);;

(* 
("Elapsed time: 0.000006 seconds",
 [0; 1; 1; 2; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 610; 987; 1597;
  2584; 4181; 6765; 10946; 17711; 28657; 46368; 75025; 121393; 196418;
  317811; 514229; 832040; 1346269; 2178309; 3524578])
 *)


(* 5 *) 
how_long (fun () -> stream_prefix fibs_from_scratch 36);;

(*
("Elapsed time: 0.688242 seconds",
 [0; 1; 1; 2; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 610; 987; 1597;
  2584; 4181; 6765; 10946; 17711; 28657; 46368; 75025; 121393; 196418;
  317811; 514229; 832040; 1346269; 2178309; 3524578; 5702887; 9227465])
 *)



(* EXERCISE 26 *)
let fibs_incremental =
  let rec make_fibs fib_i fib_succ_i =
    Scons (fib_i, lazy (make_fibs fib_succ_i (fib_i + fib_succ_i)))
  in make_fibs 0 1;;

let () = assert (test_fibs fibs_incremental);;

(*

- : string * int list =
("Elapsed time: 0.000016 seconds",
 [0; 1; 1; 2; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 610; 987; 1597;
  2584; 4181; 6765; 10946; 17711; 28657; 46368; 75025; 121393; 196418;
  317811; 514229; 832040; 1346269; 2178309; 3524578; 5702887; 9227465;
  14930352; 24157817; 39088169; 63245986; 102334155; 165580141; 267914296;
  433494437; 701408733; 1134903170; 1836311903; 2971215073; 4807526976;
  7778742049; 12586269025; 20365011074; 32951280099; 53316291173;
  86267571272; 139583862445; 225851433717; 365435296162; 591286729879;
  956722026041; 1548008755920; 2504730781961; 4052739537881; 6557470319842;
  10610209857723; 17167680177565; 27777890035288; 44945570212853;
  72723460248141; 117669030460994; 190392490709135; 308061521170129;
  498454011879264; 806515533049393; 1304969544928657; 2111485077978050;
  3416454622906707; 5527939700884757; 8944394323791464; 14472334024676221;
  23416728348467685; 37889062373143906; 61305790721611591; 99194853094755497;
  160500643816367088; 259695496911122585; 420196140727489673;
  679891637638612258; 1100087778366101931; 1779979416004714189;
  2880067194370816120])

 *)

(* Repeated again:

# how_long (fun () -> stream_prefix fibs_incremental 91);;
- : string * int list =
("Elapsed time: 0.000009 seconds",
 [0; 1; 1; 2; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 610; 987; 1597;
  2584; 4181; 6765; 10946; 17711; 28657; 46368; 75025; 121393; 196418;
  317811; 514229; 832040; 1346269; 2178309; 3524578; 5702887; 9227465;
  14930352; 24157817; 39088169; 63245986; 102334155; 165580141; 267914296;
  433494437; 701408733; 1134903170; 1836311903; 2971215073; 4807526976;
  7778742049; 12586269025; 20365011074; 32951280099; 53316291173;
  86267571272; 139583862445; 225851433717; 365435296162; 591286729879;
  956722026041; 1548008755920; 2504730781961; 4052739537881; 6557470319842;
  10610209857723; 17167680177565; 27777890035288; 44945570212853;
  72723460248141; 117669030460994; 190392490709135; 308061521170129;
  498454011879264; 806515533049393; 1304969544928657; 2111485077978050;
  3416454622906707; 5527939700884757; 8944394323791464; 14472334024676221;
  23416728348467685; 37889062373143906; 61305790721611591; 99194853094755497;
  160500643816367088; 259695496911122585; 420196140727489673;
  679891637638612258; 1100087778366101931; 1779979416004714189;
  2880067194370816120])

 *)

(* All very fast for 90 and 92 *)
(* Last element for 92 is negative, is that integer overflow? *)


how_long (fun () -> stream_prefix fibs_incremental 92);;
let end_of_file = "streams.ml";;

(*         OCaml version 4.12.0

# #use "streams.ml";;
val time : (unit -> 'a) -> string = <fun>
val how_long : (unit -> 'a) -> string * 'a = <fun>
val how_long' : (unit -> 'a) -> float * 'a = <fun>
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
val test_stream_filter_out :
  ((int -> bool) -> int stream -> int stream) -> bool = <fun>
val test_stream_filter_out :
  ((int -> bool) -> int stream -> int stream) -> bool = <fun>
val stream_filter_out_v0 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
val stream_filter_out_v1 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
val stream_filter_out_v2 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
val stream_filter_out_v3 : ('a -> bool) -> 'a stream -> 'a stream = <fun>
val posnats : int stream = Scons (1, <lazy>)
val test_stream_filter_in :
  ((int -> bool) -> int stream -> int stream) -> bool = <fun>
val stream_filter_in : ('a -> bool) -> 'a stream -> 'a stream = <fun>
val stream_filter_in_using_filter_out :
  ('a -> bool) -> 'a stream -> 'a stream = <fun>
val test_fibs : int stream -> bool = <fun>
val fib : int -> int = <fun>
val fibs_from_scratch : int stream = Scons (0, <lazy>)
val end_of_file : string = "streams.ml"

 *)
