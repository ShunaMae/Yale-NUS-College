(* midterm-project_about-strings.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2021-2022 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Sun 27 Feb 2022 *)

(* ********** *)

(* name of the group: SJANN 
*)

(* ********** *)

(* Question 01 *)

let question_01 = "mandatory";;

let random_char () =
  char_of_int (Random.int 32 + int_of_char ' ');;
  
let random_string n =
  String.make n (random_char ());;

let test_string_concatenation candidate = 
let b0 = (candidate  "abc" "bcd" = "abcbcd")
and b1 = (candidate "123" "456" = "123456")
and b2 = (candidate "123" "abc" = "123abc")
and b3 = (candidate "12a" "Univer4" = "12aUniver4") 
and br = (let s1 = random_string (Random.int 10)
          and s2 = random_string (Random.int 10) 
          in candidate s1 s2 = s1^s2)
and bb = (candidate "" "" = "")
in b0 && b1 && b2 && b3 && br && bb;;

let string_append s1 s2 =
  String.init 
    (String.length (s1^s2)) 
    (fun i -> if i < String.length s1 
              then String.get s1 i 
              else String.get s2 (i - String.length s1));;

let () = assert(test_string_concatenation string_append);;

(* ********** *)

(* Question 02 *)
let question_02 = "mandatory" ;;

let test_warmup candidate =
  (candidate 'a' 'b' 'c' = "abc");;

let string_of_char c =
  String.make 1 c;;

let warmup c0 c1 c2 =
  string_of_char c0 ^ string_of_char c1 ^ string_of_char c2;;

let () = assert (test_warmup warmup);;

let warmup_alt c0 c1 c2 =
  String.init
    3
    (fun i ->
      if i = 0
      then c0
      else (if i = 1
            then c1
            else c2));;

let () = assert (test_warmup warmup_alt);;

(* ********** *)

(* Question 03 *)
let question_03 = "mandatory" ;;

(* In which order are the characters accessed in the given string?*)
(* String.map (fun c -> char_of_int(an_int(int_of_char c))) "abcde" *)

(* unit-test function for String.map*)
let test_string_map candidate =
  let b0 = (candidate (fun c -> char_of_int (int_of_char c + 1)) "abc" = "bcd")
  and b1 = (candidate (fun c -> 'a') "12345" = "aaaaa")
  and b2 = (candidate (fun c -> char_of_int (int_of_char c - 1)) "bcd" = String.map (fun c -> char_of_int (int_of_char c - 1)) "bcd")
  and b3 = (candidate (fun c -> char_of_int (int_of_char c - 1)) "" = "")
  in b0 && b1 && b2 && b3;;

(* implement string_map_up *)
let string_map_up f s =
    let n = String.length s
    in let () = assert (n >= 0) in
       if n = 0
       then ""
       else let rec visit i =
           if i = 0
           then String.make 1 (f(String.get s 0))
           else let i' = pred i
                in let ih = visit i'
                   in ih ^ (String.make 1 (f(String.get s i)))
  in visit (n-1);;

(* implement string_map_down *)

let string_map_down f s =
   let n = String.length s 
   in let () = assert (n >= 0) 
      in let rec visit i = 
         if i = 0
         then  ""
         else let i' = pred i
              in let ih = visit i'
                 in (String.make 1 (f (String.get s (n - i))) ^ ih)
   in visit n;;

let () = assert(test_string_map string_map_up);;
let () = assert(test_string_map string_map_down);;
(* ********** *)

(* Question 04 (optional) *)
let question_04 = "optional";;

let test_string_mapi candidate =
  let b1 = (candidate (fun i _ -> 'a') "abcde" =
            String.mapi (fun i _ -> 'a') "abcde")
  and b2 = (candidate (fun i _ -> char_of_int (i+48)) "gondor" = 
            String.mapi (fun i _ -> char_of_int (i+48)) "gondor")
  and b3 = (candidate (fun i _ -> '%') "" = 
            String.mapi (fun i _ -> '%') "")
  and b4 = (candidate (fun i c -> if i = 3 then '-' else c) "test" = 
            String.mapi (fun i c -> if i = 3 then '-' else c) "test")
  and b4r = (let s = random_string 100
             in candidate (fun i c -> if i = 57 then '$' else c) s =
             String.mapi (fun i c -> if i = 57 then '$' else c) s)
  in b1 && b2 && b3 && b4 && b4r;;

(* In which order are the characters accessed? *)
(* String.mapi (fun i _ -> char_of_int (an_int i)) "abcde";; *) 

(* implement from left to right*)

let string_mapi_up f s =
    let n = String.length s
    in if n = 0
       then ""
       else let rec visit i  =
              if i = 0
              then String.make 1 (f 0 (String.get s 0))
              else let i' = pred i
                   in let ih = visit i'
                      in ih ^ String.make 1 (f i (String.get s i))
            in visit (n-1);;

(* implement from right to left*)
let string_mapi_down f s =
    (* Right to left *)
    let n = String.length s in
    if n = 0 then ""
    else let rec visit i =
           if i = 0
           then String.make 1 (f (n-1) (String.get s (n-1)))
           else  let i' = pred i
                 in let ih = visit i'
                    in String.make 1 (f (n-1-i) (String.get s (n-1-i))) ^ ih
         in visit (n-1);;

let () = assert(test_string_mapi string_mapi_up);;
let () = assert(test_string_mapi string_mapi_down);;
(* ********** *)

(* Question 05 *)
let question_05 = "mandatory" ;;

let test_string_reverse candidate =
  let b1 = (candidate "abcde" = "edcba")
  and b2 = (candidate "" = "")
  and b3 = (candidate "abba" = "abba")
  and b4 = (candidate "sauron" = "noruas")
  and br = (let c0 = random_char ()
            and c1 = random_char ()
            and c2 = random_char ()
            in candidate (warmup c0 c1 c2) = (warmup c2 c1 c0))
in b1 && b2 && b3 && b4 && br;;


let string_reverse_mapi s =
  String.mapi (fun i _ -> String.get s ((String.length s)-i-1) ) s;;

let string_reverse_rec s =
    let n = String.length s
    in let () = assert (n >= 0) 
       in if n = 0
          then ""
          else let rec visit i =
               if i = 0
               then String.make 1 (String.get s (n-1))
               else let i' = pred i
                    in let ih = visit i'
                       in ih ^ (String.make 1 (String.get s ((String.length s)-i-1)))
  in visit (n-1);;


let () = assert(test_string_reverse string_reverse_mapi);;
let () = assert(test_string_reverse string_reverse_rec);;


(* ********** *)

(* Question 06 *)
let question_06 = "mandatory";; 

let unit_test_string_reverse_for_question_5 string_reverse candidate = 
let b0 = (candidate "" "" = (string_reverse "")^(string_reverse ""))
and b1 = (candidate "abc" "123" = (string_reverse "123")^(string_reverse "abc"))
and b2 = (candidate "kingfisher" "yalenus" = (string_reverse "yalenus")^(string_reverse "kingfisher"))
and b3 = (candidate "1234" "4321" = (string_reverse "4321")^(string_reverse "1234"))
and br = (let s1 = random_string (Random.int 10)
          and s2 = random_string (Random.int 10)
          in candidate s1 s2 = (string_reverse s2)^(string_reverse s1))
in b0 && b1 && b2 && b3 && br;;
(* ********** *)

(* Question 07 *)
let question_07 = "mandatory";;

let make_palindrome n = 
  let s = String.init (n / 2) (fun i -> random_char ())
  in if n mod 2 = 0
     then s ^ (string_reverse_mapi s)
     else s ^ "x" ^ (string_reverse_mapi s);;

(* examples *)
make_palindrome 10;;
make_palindrome 5;;
make_palindrome 0;;


(* ********** *)

(* Question 08 *)

let question_08 = "mandatory";;

let test_palindrome_detector candidate = 
let b0 = (candidate "abcdefedcba" = true)
and b1 = (candidate "a" = true)
and b2 = (candidate "aaaaaaaaa" = true)
and b3 = (candidate "123454321" = true)
and b4 = (candidate "ab" = false)
and b5 = (candidate "yale" = false)
and b6 = (candidate "nus" = false)
and b7 = (candidate "" = true)
and br = (let p = make_palindrome 5 
          in candidate p = true)
and bp = (let q = make_palindrome 6
          in candidate q = true)
in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7 && br && bp;;


(* with String.mapi *)
let palindromep_mapi s = string_reverse_mapi s = s


(* recursive solution*)

let make_boolean_function tt tf ft ff b1 b2 =
  if b1 && b2 then tt
  else if b1 && not b2 then tf
  else if not b1 && b2 then ft
  else ff;;

let conjunction_gen =
  make_boolean_function true false false false;;

let palindromep_rec s =
    let is_palindrome = true
    in let n = String.length s
       in if n = 0
          then true
          else let () = assert (n > 0)
               in let rec visit i =
                  if i = 0
                  then is_palindrome = (String.get s 0 = String.get s (n-1))
                  else let i' = pred i
                       in let ih = visit i'
                          in is_palindrome = conjunction_gen ih (String.get s i = String.get s (n-1-i))
    in visit (n/2) ;;

let () = assert(test_palindrome_detector palindromep_mapi);;
let () = assert(test_palindrome_detector palindromep_rec);;

(* ********** *)

(* Question 09 (not optional) *)

let question_09 = "not optional";;
let reverse_palindrome s = s

(* ********** *)

(* Question 10 (optional) *)

let string_map f s =
  assert false;;

(* ********** *)

(* Question 11 (optional) *)

let string_mapi f s =
  assert false;;

(* ********** *)

(* Question 12 *)
let question_12 = "mandatory" ;;


let digitp c =
  '0' <= c && c <= '9';;

let test_string_andmap candidate =
  (candidate digitp "" = true) &&
  (candidate digitp "123" = true) &&
  (candidate digitp "abc" = false) &&
  (candidate digitp "123abc" = false);;

let string_andmap predicate s =
  let is_true = true
  in let n = String.length s
      in if n = 0
         then is_true
         else let () = assert (n > 0)
              in let rec visit i =
                 if i = 0
                 then is_true = predicate (String.get s 0)
                 else let i' = pred i
                      in let ih = visit i'
                          in is_true= conjunction_gen ih (predicate (String.get s i))
    in visit (n-1);;

let string_andmap predicate s =
 let n = String.length s
     in if n = 0 then true
        else let rec visit i =
               if i = 0
               then predicate (String.get s 0)
               else let i' = pred i
                    in let ih = visit i'
                       in ih && predicate (String.get s i)
             in visit (n-1);;


let fake_string_andmap predicate s =
    if s = "onlydigits"
    then true
    else string_andmap predicate s;;


let () = assert (test_string_andmap string_andmap);;
let () = assert (test_string_andmap fake_string_andmap);;

(* ***** *)

let test_string_ormap candidate =
  (candidate digitp "" = false) &&
  (candidate digitp "123" = true) &&
  (candidate digitp "abc" = false) &&
  (candidate digitp "123abc" = true);;

let string_ormap f s =
  assert false;;

let string_ormap predicate s =
   let n = String.length s
     in if n = 0 then false
        else let rec visit i =
               if i = 0
               then predicate (String.get s 0)
               else let i' = pred i
                    in let ih = visit i'
                       in ih ||  predicate (String.get s i)
             in visit (n-1);;

let () = assert (test_string_ormap string_ormap);;


(* ********** *)

(* Question 13 (optional) *)

let test_string_concatmap candidate =
  (candidate (fun c -> String.make 2 c) "abc" = "aabbcc");;

let concatmap f s =
  assert false;;

(* ***** *)

let test_show_string candidate =
  (candidate "" = "\"\"") &&
  (candidate "abc" = "\"abc\"") &&
  (candidate "ab\\cd" = "\"ab\\\\cd\"") &&
  (candidate "\"" = "\"\\\"\"");;

(* Rationale:

   # Printf.printf "%s\n" "\"\"";;
   ""
   - : unit = ()
   # Printf.printf "%s\n" "\"abc\"";;
   "abc"
   - : unit = ()
   # Printf.printf "%s\n" "\"ab\\\\cd\"";;
   "ab\\cd"
   - : unit = ()
   # Printf.printf "%s\n" "\"\\\"\"";;
   "\""
   - : unit = ()
   # 
*)

let show_string s =
  assert false;;

(* Wanted:

   # Printf.printf "%s\n" (show_string "");;
   ""
   - : unit = ()
   # Printf.printf "%s\n" (show_string "abc");;
   "abc"
   - : unit = ()
   # Printf.printf "%s\n" (show_string "ab\\cd");;
   "ab\\cd"
   - : unit = ()
   # Printf.printf "%s\n" (show_string "\"");;
   "\""
   - : unit = ()
   # 
*)

(* ********** *)

let end_of_file = "midterm-project_about-strings.ml";;

(*
        OCaml version 4.12.0
        
#  #use "midterm-project_about-strings.ml";;
val question_01 : string = "mandatory"
val random_char : unit -> char = <fun>
val random_string : int -> string = <fun>
val test_string_concatenation : (string -> string -> string) -> bool = <fun>
val string_append : string -> string -> string = <fun>
val question_02 : string = "mandatory"
val test_warmup : (char -> char -> char -> string) -> bool = <fun>
val string_of_char : char -> string = <fun>
val warmup : char -> char -> char -> string = <fun>
val warmup_alt : char -> char -> char -> string = <fun>
val question_03 : string = "mandatory"
val test_string_map : ((char -> char) -> string -> string) -> bool = <fun>
val string_map_up : (char -> char) -> string -> string = <fun>
val string_map_down : (char -> char) -> string -> string = <fun>
val question_04 : string = "optional"
val test_string_mapi : ((int -> char -> char) -> string -> string) -> bool =
  <fun>
val string_mapi_up : (int -> char -> char) -> string -> string = <fun>
val string_mapi_down : (int -> char -> char) -> string -> string = <fun>
val question_05 : string = "mandatory"
val test_string_reverse : (string -> string) -> bool = <fun>
val string_reverse_mapi : string -> string = <fun>
val string_reverse_rec : string -> string = <fun>
val question_06 : string = "mandatory"
val unit_test_string_reverse_for_question_5 :
  (string -> string) -> (string -> string -> string) -> bool = <fun>
val question_07 : string = "mandatory"
val make_palindrome : int -> string = <fun>
- : string = "!.4%99%4.!"
- : string = "9>x>9"
- : string = ""
val question_08 : string = "mandatory"
val test_palindrome_detector : (string -> bool) -> bool = <fun>
val palindromep_mapi : string -> bool = <fun>
val make_boolean_function : 'a -> 'a -> 'a -> 'a -> bool -> bool -> 'a = <fun>
val conjunction_gen : bool -> bool -> bool = <fun>
val palindromep_rec : string -> bool = <fun>
val question_09 : string = "not optional"
val reverse_palindrome : 'a -> 'a = <fun>
val string_map : 'a -> 'b -> 'c = <fun>
val string_mapi : 'a -> 'b -> 'c = <fun>
val question_12 : string = "mandatory"
val digitp : char -> bool = <fun>
val test_string_andmap : ((char -> bool) -> string -> bool) -> bool = <fun>
val string_andmap : (char -> bool) -> string -> bool = <fun>
val string_andmap : (char -> bool) -> string -> bool = <fun>
val fake_string_andmap : (char -> bool) -> string -> bool = <fun>
val test_string_ormap : ((char -> bool) -> string -> bool) -> bool = <fun>
val string_ormap : 'a -> 'b -> 'c = <fun>
val string_ormap : (char -> bool) -> string -> bool = <fun>
val test_string_concatmap : ((char -> string) -> string -> string) -> bool =
  <fun>
val concatmap : 'a -> 'b -> 'c = <fun>
val test_show_string : (string -> string) -> bool = <fun>
val show_string : 'a -> 'b = <fun>
val end_of_file : string = "midterm-project_about-strings.ml"
# 
*)

