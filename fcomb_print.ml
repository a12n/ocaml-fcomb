open Batteries

type ('a, 'b) printer = ('a, 'b) IO.printer

let char = IO.write
let string = IO.nwrite

let big_int = Big_int.print
let bit ch b = char ch (if b then '1' else '0')
let bool = Bool.print
let float = Float.print
let int = Int.print
let num = Num.print
let unit _ch () = ()

let iter_aux sep f ch i v = if i > 0 then string ch sep; f ch v

let array ?(first="") ?(sep=" ") ?(last="") =
  Array.print ~first ~sep ~last

let enum ?(first="") ?(sep=" ") ?(last="") =
  Enum.print ~first ~sep ~last

let line f ch a = f ch a; char ch '\n'

let list ?(first="") ?(sep=" ") ?(last="") =
  List.print ~first ~sep ~last

let pair ?(first="") ?(sep=" ") ?(last="") =
  Tuple.Tuple2.print ~first ~sep ~last

let triplet ?(first="") ?(sep=" ") ?(last="") =
  Tuple.Tuple3.print ~first ~sep ~last

let hpair ?first ?sep ?last f = pair ?first ?sep ?last f f

let htriplet ?first ?sep ?last f = triplet ?first ?sep ?last f f f
