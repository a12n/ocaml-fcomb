type 'a scanner = in_channel -> 'a


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


val array : ?first:string -> ?sep:string -> ?last:string -> ?n:int ->
  'a scanner -> 'a array scanner

val hpair : ?first:string -> ?sep:string -> ?last:string ->
  'a scanner -> ('a * 'a) scanner

val htriplet : ?first:string -> ?sep:string -> ?last:string ->
  'a scanner -> ('a * 'a * 'a) scanner

val line : 'a scanner -> 'a scanner

val list : ?first:string -> ?sep:string -> ?last:string -> ?n:int ->
  'a scanner -> 'a list scanner

val pair : ?first:string -> ?sep:string -> ?last:string ->
  'a scanner -> 'b scanner -> ('a * 'b) scanner

val triplet : ?first:string -> ?sep:string -> ?last:string ->
  'a scanner -> 'b scanner -> 'c scanner -> ('a * 'b * 'c) scanner
