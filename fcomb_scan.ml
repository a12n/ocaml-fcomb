(*${*)
open Batteries
(*$}*)

type 'a scanner = IO.input -> 'a

exception Error

let scan_aux ch fmt =
  try Scanf.bscanf (Scanf.Scanning.from_input ch) fmt (fun v -> v)
  with (Scanf.Scan_failure _) -> raise Error
     | IO.Input_closed -> raise Error

let scan_literal ch str =
  scan_aux ch (Scanf.format_from_string str "") ()

let string ch =
  match scan_aux ch " %s" with
  | "" -> raise End_of_file
  | str -> str

(*$T string
  (string (IO.input_string " \n \nxyz ")) = "xyz"
  try ignore (string (IO.input_string "")); false with End_of_file -> true
*)

let bool ch = scan_aux ch " %B"

(*$T bool
  (bool (IO.input_string "false")) = false
  (bool (IO.input_string "true")) = true
  try ignore (bool (IO.input_string "")); false with End_of_file -> true
  try ignore (bool (IO.input_string "0")); false with Error -> true
*)

let char ch = scan_aux ch " %c"

(*$T char
  (char (IO.input_string " a b c ")) = 'a'
  (char (IO.input_string "123")) = '1'
  (char (IO.input_string "\n1\n2")) = '1'
  (char (IO.input_string "abc")) = 'a'
  try ignore (char (IO.input_string "")); false with End_of_file -> true
*)

let float ch = scan_aux ch " %f"

(*$T float
  Float.approx_equal (Fcomb_scan.float (IO.input_string "-1.")) (-1.0)
  Float.approx_equal (Fcomb_scan.float (IO.input_string "1")) 1.0
  Float.approx_equal (Fcomb_scan.float (IO.input_string "1.")) 1.0
  Float.approx_equal (Fcomb_scan.float (IO.input_string "1.23")) 1.23
  Float.approx_equal (Fcomb_scan.float (IO.input_string "1e6")) 1e6
  try ignore (Fcomb_scan.float (IO.input_string "")); false with End_of_file -> true
  try ignore (Fcomb_scan.float (IO.input_string "a")); false with Error -> true
*)

let int ch = scan_aux ch " %i"

(*$T int
  (int (IO.input_string " -5 ")) = (-5)
  (int (IO.input_string " 0b101 ")) = 5
  (int (IO.input_string " 0x10 ")) = 16
  (int (IO.input_string "1")) = 1
  try ignore (int (IO.input_string "")); false with End_of_file -> true
*)

let unit _ch = ()

let bit ch = int ch <> 0

(*$T bit
  (bit (IO.input_string " -5 ")) = true
  (bit (IO.input_string " 0 ")) = false
  (bit (IO.input_string " 1 ")) = true
  (bit (IO.input_string " 134 ")) = true
  try ignore (bit (IO.input_string "")); false with End_of_file -> true
*)

let big_int ch = Big_int.big_int_of_string (string ch)

(*$T big_int
  Big_int.equal (big_int (IO.input_string " -5 ")) Big_int.(of_int (-5))
  try ignore (big_int (IO.input_string "")); false with End_of_file -> true
*)

let num ch = Num.num_of_string (string ch)

(*$T num
  Num.equal (num (IO.input_string " -3/4 ")) Num.(of_int (-3) / of_int 4)
  Num.equal (num (IO.input_string " 12 ")) Num.(of_int 12)
  try ignore (num (IO.input_string "")); false with End_of_file -> true
*)

let enum ?n f ch =
  match n with
  | None -> Enum.from_loop 0 (function
      | 0 -> f ch, 1
      | i -> f ch, i + 1
    )
  | Some n -> Enum.init n (function
      | 0 -> f ch
      | i when i = (n - 1) -> f ch
      | i -> f ch
    )

let array ?n f ch = Array.of_enum (enum ?n f ch)

(*$T array
  (array char (IO.input_string "A B C")) = [|'A'; 'B'; 'C'|]
  (array char (IO.input_string "ABC")) = [|'A'; 'B'; 'C'|]
  (array int (IO.input_string " 1 2 3 ")) = [|1; 2; 3|]
  (array int (IO.input_string "")) = [||]
  try ignore (array ~n:1 int (IO.input_string "")); false with End_of_file -> true
  try ignore (array ~n:2 int (IO.input_string " a b ")); false with Error -> true
*)

let line f ch = f IO.(input_string (read_line ch))

let list ?n f ch = List.of_enum (enum ?n f ch)

let pair f g ch =
  let a = f ch in
  let b = g ch in
  (a, b)

let triplet f g h ch =
  let a = f ch in
  let b = g ch in
  let c = h ch in
  (a, b, c)

let hpair f = pair f f

let htriplet f = triplet f f f
