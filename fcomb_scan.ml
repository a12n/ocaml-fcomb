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

let bool ch = scan_aux ch " %B"
let char ch = scan_aux ch " %c"
let float ch = scan_aux ch " %f"
let int ch = scan_aux ch " %i"
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
