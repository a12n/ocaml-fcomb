open Batteries


type ('a, 'b) printer = ('a, 'b) IO.printer


val big_int : (Big_int.big_int, 'a) printer

val bit : (bool, 'a) printer

val bool : (bool, 'a) printer

val char : (char, 'a) printer

val float : (float, 'a) printer

val int : (int, 'a) printer

val num : (Num.num, 'a) printer

val string : (string, 'a) printer

val unit : (unit, 'a) printer


val array : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('a array, 'b) printer

val enum : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('a Enum.t, 'b) printer

val hpair : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('a * 'a, 'b) printer

val htriplet : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('a * 'a * 'a, 'b) printer

val line : ('a, 'b) printer -> ('a, 'b) printer

val list : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('a list, 'b) printer

val pair : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('c, 'b) printer -> ('a * 'c, 'b) printer

val triplet : ?first:string -> ?sep:string -> ?last:string ->
  ('a, 'b) printer -> ('c, 'b) printer -> ('d, 'b) printer ->
  ('a * 'c * 'd, 'b) printer
