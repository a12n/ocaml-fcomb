open Batteries

type 'a scanner = IO.input -> 'a

exception Error

let scan_aux ch fmt =
  try Scanf.bscanf (Scanf.Scanning.from_input ch) fmt (fun v -> v)
  with (Scanf.Scan_failure _) -> raise Error
     | IO.Input_closed -> raise Error

let scan_literal ch str = scan_aux ch (Scanf.format_from_string str "%s")

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

(* let enum ?(first=" ") ?(sep=" ") ?(last=" ") ?n f ch = *)


(* val array : ?first:string -> ?sep:string -> ?last:string -> ?n:int -> 'a t -> 'a array t *)

let line f ch = f (IO.input_string (IO.read_line ch))

(* val list : ?first:string -> ?sep:string -> ?last:string -> ?n:int -> 'a t -> 'a list t *)

let pair ?(first=" ") ?(sep=" ") ?(last=" ") f g ch =
  ignore (scan_literal ch first);
  let a = f ch in
  ignore (scan_literal ch sep);
  let b = g ch in
  ignore (scan_literal ch last);
  (a, b)

let triplet ?(first=" ") ?(sep=" ") ?(last=" ") f g h ch =
  ignore (scan_literal ch first);
  let a = f ch in
  ignore (scan_literal ch sep);
  let b = g ch in
  ignore (scan_literal ch sep);
  let c = h ch in
  ignore (scan_literal ch last);
  (a, b, c)

let hpair ?first ?sep ?last f = pair ?first ?sep ?last f f

let htriplet ?first ?sep ?last f = triplet ?first ?sep ?last f f f
