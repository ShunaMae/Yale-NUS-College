(* week-13_exercises.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sat 02 Apr 2022 *)

(* ********** *)

(* Exercise 15a *)

module Foo_maker (M : sig val n : int end) =
  struct
    let n = M.n + 1
  end;;

module Foo_0 =
  struct
    let n = 0
  end;;

module Foo_1 = Foo_maker (Foo_0);;

module Foo_2 = Foo_maker (Foo_maker (Foo_0));;

module Foo_3 = Foo_maker (Foo_maker (Foo_maker (Foo_0)));;

module Foo_4 = Foo_maker (Foo_maker (Foo_maker (Foo_maker (Foo_0))));;

module Foo_5 = Foo_maker (Foo_maker (Foo_maker (Foo_maker (Foo_maker (Foo_0)))));;

(* ********** *)

(* Exercise 15b *)

module Bar_maker (M : sig val n : int val bar_n : int end) =
  struct
    let n = M.n + 1
    let bar_n = n * M.bar_n
  end;;

module Bar_0 =
  struct
    let n = 0
    let bar_n = 1
  end;;

module Bar_1 = Bar_maker (Bar_0);;

module Bar_2 = Bar_maker (Bar_maker (Bar_0));;

module Bar_3 = Bar_maker (Bar_maker (Bar_maker (Bar_0)));;

module Bar_4 = Bar_maker (Bar_maker (Bar_maker (Bar_maker (Bar_0))));;

module Bar_5 = Bar_maker (Bar_maker (Bar_maker (Bar_maker (Bar_maker (Bar_0)))));;

(* ********** *)

(* Exercise 15c *)

module Baz_maker (M : sig val i : int val j : int end) =
  struct
    let i = M.j
    and j = M.i + M.j
  end;;

module Baz_0 =
  struct
    let i = 0
    let j = 1
  end;;

module Baz_1 = Baz_maker (Baz_0);;

module Baz_2 = Baz_maker (Baz_maker (Baz_0));;

module Baz_3 = Baz_maker (Baz_maker (Baz_maker (Baz_0)));;

module Baz_4 = Baz_maker (Baz_maker (Baz_maker (Baz_maker (Baz_0))));;

module Baz_5 = Baz_maker (Baz_maker (Baz_maker (Baz_maker (Baz_maker (Baz_0)))));;

(* ********** *)

let end_of_file = "week-13_exercises.ml";;

(*
           OCaml version 4.01.0
   
   # #use "week-13_exercises.ml";;
   module Foo_maker : functor (M : sig val n : int end) -> sig val n : int end
   module Foo_0 : sig val n : int end
   module Foo_1 : sig val n : int end
   module Foo_2 : sig val n : int end
   module Foo_3 : sig val n : int end
   module Foo_4 : sig val n : int end
   module Foo_5 : sig val n : int end
   module Bar_maker :
     functor (M : sig val n : int val bar_n : int end) ->
       sig val n : int val bar_n : int end
   module Bar_0 : sig val n : int val bar_n : int end
   module Bar_1 : sig val n : int val bar_n : int end
   module Bar_2 : sig val n : int val bar_n : int end
   module Bar_3 : sig val n : int val bar_n : int end
   module Bar_4 : sig val n : int val bar_n : int end
   module Bar_5 : sig val n : int val bar_n : int end
   module Baz_maker :
     functor (M : sig val i : int val j : int end) ->
       sig val i : int val j : int end
   module Baz_0 : sig val i : int val j : int end
   module Baz_1 : sig val i : int val j : int end
   module Baz_2 : sig val i : int val j : int end
   module Baz_3 : sig val i : int val j : int end
   module Baz_4 : sig val i : int val j : int end
   module Baz_5 : sig val i : int val j : int end
   val end_of_file : string = "week-13_exercises.ml"
   # 
*)
