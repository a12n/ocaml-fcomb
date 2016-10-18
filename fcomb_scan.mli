open Batteries


type 'a scanner = IO.input -> 'a


exception Error


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
