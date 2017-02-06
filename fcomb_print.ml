(*${*)
open Batteries
(*$}*)

module type S = sig
  type ('a, 'b) printer

  val big_int : (Big_int.big_int, 'a) printer
  val bit : (bool, 'a) printer
  val bool : (bool, 'a) printer
  val char : (char, 'a) printer
  val float : ?k:int -> (float, 'a) printer
  val int : (int, 'a) printer
  val num : (Num.num, 'a) printer
  val string : (string, 'a) printer
  val unit : (unit, 'a) printer

  val array : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a array, 'b) printer
  val enum : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a Enum.t, 'b) printer
  val hpair : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'c) printer -> ('b, 'c) printer -> ('a * 'b, 'c) printer
  val hquad : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'e) printer -> ('b, 'e) printer -> ('c, 'e) printer -> ('d, 'e) printer ->
    ('a * 'b * 'c * 'd, 'e) printer
  val htriple : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'd) printer -> ('b, 'd) printer -> ('c, 'd) printer ->
    ('a * 'b * 'c, 'd) printer
  val line : ('a, 'b) printer -> ('a, 'b) printer
  val list : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a list, 'b) printer
  val pair : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a * 'a, 'b) printer
  val quad : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a * 'a * 'a * 'a, 'b) printer
  val triple : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a * 'a * 'a, 'b) printer
end

module Ch = struct
  (*$< Ch *)

  type ('a, 'b) printer = ('a, 'b) IO.printer

  let char = IO.write
  let string = IO.nwrite

  let big_int = Big_int.print
  let bit ch b = char ch (if b then '1' else '0')
  let bool = Bool.print
  let float ?k ch =
    match k with
    | None -> Float.print ch
    | Some k ->
      assert (k >= 0 && k < 16);
      let fmt = Scanf.format_from_string
          ("%." ^ (string_of_int k) ^ "f") "%f" in
      Printf.fprintf ch fmt
  (*$= float
    (let ch = IO.output_string () in float ~k:0 ch 1.23456; IO.close_out ch) "1"
    (let ch = IO.output_string () in float ~k:3 ch 1.23456; IO.close_out ch) "1.235"
    (let ch = IO.output_string () in float ~k:4 ch 1.23456; IO.close_out ch) "1.2346"
  *)
  let int = Int.print
  let num = Num.print
  let unit _ch () = ()

  let array ?(first="") ?(sep=" ") ?(last="") =
    Array.print ~first ~sep ~last

  let enum ?(first="") ?(sep=" ") ?(last="") =
    Enum.print ~first ~sep ~last

  let line f ch a = f ch a; char ch '\n'

  let list ?(first="") ?(sep=" ") ?(last="") =
    List.print ~first ~sep ~last

  let hpair ?(first="") ?(sep=" ") ?(last="") =
    Tuple.Tuple2.print ~first ~sep ~last

  let hquad ?(first="") ?(sep=" ") ?(last="") =
    Tuple.Tuple4.print ~first ~sep ~last

  let htriple ?(first="") ?(sep=" ") ?(last="") =
    Tuple.Tuple3.print ~first ~sep ~last

  let pair ?first ?sep ?last f = hpair ?first ?sep ?last f f

  let quad ?first ?sep ?last f = hquad ?first ?sep ?last f f f f

  let triple ?first ?sep ?last f = htriple ?first ?sep ?last f f f

  (*$>*)
end

type ('a, 'b) printer = 'a -> unit

let of_ch f = f IO.stdout
let to_ch f _ch = f

let big_int = of_ch Ch.big_int
let bit = of_ch Ch.bit
let bool = of_ch Ch.bool
let char = of_ch Ch.char
let float ?k = of_ch (Ch.float ?k)
let int = of_ch Ch.int
let num = of_ch Ch.num
let string = of_ch Ch.string
let unit = of_ch Ch.unit

let array ?first ?sep ?last f =
  of_ch (Ch.array ?first ?sep ?last (to_ch f))

let enum ?first ?sep ?last f =
  of_ch (Ch.enum ?first ?sep ?last (to_ch f))

let line f = of_ch (Ch.line (to_ch f))

let list ?first ?sep ?last f =
  of_ch (Ch.list ?first ?sep ?last (to_ch f))

let hpair ?first ?sep ?last f g =
  of_ch (Ch.hpair ?first ?sep ?last (to_ch f) (to_ch g))

let hquad ?first ?sep ?last f g h i =
  of_ch (Ch.hquad ?first ?sep ?last (to_ch f) (to_ch g) (to_ch h) (to_ch i))

let htriple ?first ?sep ?last f g h =
  of_ch (Ch.htriple ?first ?sep ?last (to_ch f) (to_ch g) (to_ch h))

let pair ?first ?sep ?last f = hpair ?first ?sep ?last f f

let quad ?first ?sep ?last f = hquad ?first ?sep ?last f f f f

let triple ?first ?sep ?last f = htriple ?first ?sep ?last f f f
