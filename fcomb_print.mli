type 'a printer = out_channel -> 'a -> unit


val big_int : Big_int.big_int printer

val bit : bool printer

val bool : bool printer

val char : char printer

val float : float printer

val int : int printer

val num : Num.num printer

val string : string printer

val unit : unit printer


val array : ?first:string -> ?sep:string -> ?last:string ->
  'a printer -> 'a array printer

val hpair : ?first:string -> ?sep:string -> ?last:string ->
  'a printer -> ('a * 'a) printer

val htriplet : ?first:string -> ?sep:string -> ?last:string ->
  'a printer -> ('a * 'a * 'a) printer

val line : 'a printer -> 'a printer

val list : ?first:string -> ?sep:string -> ?last:string ->
  'a printer -> 'a list printer

val pair : ?first:string -> ?sep:string -> ?last:string ->
  'a printer -> 'b printer -> ('a * 'b) printer

val triplet : ?first:string -> ?sep:string -> ?last:string ->
  'a printer -> 'b printer -> 'c printer -> ('a * 'b * 'c) printer
