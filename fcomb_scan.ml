open Batteries

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

let enum ?(first="") ?(sep="") ?(last="") ?n f ch =
  match n with
  | None -> Enum.from_loop 0 (function
      | 0 ->
        scan_literal ch first;
        f ch, 1
      | i -> (
          try
            scan_literal ch sep;
            f ch, i + 1
          with Error ->
            scan_literal ch last;
            raise Enum.No_more_elements
        )
    )
  | Some n -> Enum.init n (function
      | 0 ->
        scan_literal ch first;
        f ch
      | i when i = (n - 1) ->
        scan_literal ch sep;
        let elt = f ch in
        scan_literal ch last;
        elt
      | i ->
        scan_literal ch sep;
        f ch
    )

let array ?first ?sep ?last ?n f ch =
  Array.of_enum (enum ?first ?sep ?last ?n f ch)

let line f ch = f IO.(input_string (read_line ch))

let list ?first ?sep ?last ?n f ch =
  List.of_enum (enum ?first ?sep ?last ?n f ch)

let pair ?(first="") ?(sep="") ?(last="") f g ch =
  scan_literal ch first;
  let a = f ch in
  scan_literal ch sep;
  let b = g ch in
  scan_literal ch last;
  (a, b)

let triplet ?(first="") ?(sep="") ?(last="") f g h ch =
  scan_literal ch first;
  let a = f ch in
  scan_literal ch sep;
  let b = g ch in
  scan_literal ch sep;
  let c = h ch in
  scan_literal ch last;
  (a, b, c)

let hpair ?first ?sep ?last f = pair ?first ?sep ?last f f

let htriplet ?first ?sep ?last f = triplet ?first ?sep ?last f f f
