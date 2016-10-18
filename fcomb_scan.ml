(*${*)
open Batteries
(*$}*)

module type S = sig
  type 'a scanner

  val big_int : Big_int.big_int scanner
  val bit : bool scanner
  val bool : bool scanner
  val char : char scanner
  val float : float scanner
  val int : int scanner
  val num : Num.num scanner
  val string : string scanner
  val unit : unit scanner

  val array : ?n:int -> 'a scanner -> 'a array scanner
  val enum : ?n:int -> 'a scanner -> 'a Enum.t scanner
  val hpair : 'a scanner -> ('a * 'a) scanner
  val htriplet : 'a scanner -> ('a * 'a * 'a) scanner
  val line : 'a scanner -> 'a scanner
  val list : ?n:int -> 'a scanner -> 'a list scanner
  val pair : 'a scanner -> 'b scanner -> ('a * 'b) scanner
  val triplet : 'a scanner -> 'b scanner -> 'c scanner -> ('a * 'b * 'c) scanner
end

exception Error

module Ch = struct
  (*$< Ch *)

  type 'a scanner = IO.input -> 'a

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
    Float.approx_equal (Fcomb_scan.Ch.float (IO.input_string "-1.")) (-1.0)
    Float.approx_equal (Fcomb_scan.Ch.float (IO.input_string "1")) 1.0
    Float.approx_equal (Fcomb_scan.Ch.float (IO.input_string "1.")) 1.0
    Float.approx_equal (Fcomb_scan.Ch.float (IO.input_string "1.23")) 1.23
    Float.approx_equal (Fcomb_scan.Ch.float (IO.input_string "1e6")) 1e6
    try ignore (Fcomb_scan.Ch.float (IO.input_string "")); false with End_of_file -> true
    try ignore (Fcomb_scan.Ch.float (IO.input_string "a")); false with Error -> true
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
    | None -> Enum.from (fun () ->
        try
          f ch
        with Error | End_of_file -> raise Enum.No_more_elements
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

  (*$T pair
    (pair char int (IO.input_string "A 1")) = ('A', 1)
    (pair char int (IO.input_string "A1")) = ('A', 1)
    (pair int char (IO.input_string "1 A")) = (1, 'A')
  *)

  let triplet f g h ch =
    let a = f ch in
    let b = g ch in
    let c = h ch in
    (a, b, c)

  let hpair f = pair f f

  let htriplet f = triplet f f f

  (*$>*)
end

type 'a scanner = unit -> 'a

let of_ch f = function () -> f IO.stdin
let to_ch f = function (_ch : IO.input) -> f ()

let big_int = of_ch Ch.big_int
let bit = of_ch Ch.bit
let bool = of_ch Ch.bool
let char = of_ch Ch.char
let float = of_ch Ch.float
let int = of_ch Ch.int
let num = of_ch Ch.num
let string = of_ch Ch.string
let unit = of_ch Ch.unit

let array ?n f = of_ch (Ch.array ?n (to_ch f))
let enum ?n f = of_ch (Ch.enum ?n (to_ch f))
let hpair f = of_ch (Ch.hpair (to_ch f))
let htriplet f = of_ch (Ch.htriplet (to_ch f))
let line f = of_ch (Ch.line (to_ch f))
let list ?n f = of_ch (Ch.list ?n (to_ch f))
let pair f g = of_ch (Ch.pair (to_ch f) (to_ch g))
let triplet f g h = of_ch (Ch.triplet (to_ch f) (to_ch g) (to_ch h))
