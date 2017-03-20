open Batteries

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
  val set : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a Set.t, 'b) printer
  val triple : ?first:string -> ?sep:string -> ?last:string ->
    ('a, 'b) printer -> ('a * 'a * 'a, 'b) printer
end

(** Print to a channel. *)
module Ch : S with type ('a, 'b) printer = ('a, 'b) IO.printer

(** Print to standard output channel. *)
include S with type ('a, 'b) printer = 'a -> unit
