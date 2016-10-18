type 'a printer = out_channel -> 'a -> unit

let char = output_char
let string = output_string

let big_int out n = string out (Big_int.string_of_big_int n)
let bit out b = char out (if b then '1' else '0')
let bool out b = string out (string_of_bool b)
let float out x = string out (string_of_float x)
let int out n = string out (string_of_int n)
let num out q = string out (Num.string_of_num q)
let unit _out () = ()

let iter_aux sep f out i v = if i > 0 then string out sep; f out v

let array ?(first="") ?(sep=" ") ?(last="") f out arr =
  string out first;
  Array.iteri (iter_aux sep f out) arr;
  string out last

let line f out a = f out a; char out '\n'

let list ?(first="") ?(sep=" ") ?(last="") f out list =
  string out first;
  List.iteri (iter_aux sep f out) list;
  string out last

let pair ?(first="") ?(sep=" ") ?(last="") f g out (a, b) =
  string out first;
  f out a; string out sep; g out b;
  string out last

let triplet ?(first="") ?(sep=" ") ?(last="") f g h out (a, b, c) =
  string out first;
  f out a; string out sep; g out b; string out sep; h out c;
  string out last

let hpair ?first ?sep ?last f = pair ?first ?sep ?last f f
let htriplet ?first ?sep ?last f = triplet ?first ?sep ?last f f f
