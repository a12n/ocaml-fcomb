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
  | "" -> raise Error
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

let big_int ch = Big_int.big_int_of_string (string ch)
let num ch = Num.num_of_string (string ch)

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
