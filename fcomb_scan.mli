open Batteries

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
  val hpair : 'a scanner -> 'b scanner -> ('a * 'b) scanner
  val hquad : 'a scanner -> 'b scanner -> 'c scanner -> 'd scanner -> ('a * 'b * 'c * 'd) scanner
  val htriple : 'a scanner -> 'b scanner -> 'c scanner -> ('a * 'b * 'c) scanner
  val list : ?n:int -> 'a scanner -> 'a list scanner
  val pair : 'a scanner -> ('a * 'a) scanner
  val quad : 'a scanner -> ('a * 'a * 'a * 'a) scanner
  val set : ?n:int -> 'a scanner -> 'a Set.t scanner
  val triple : 'a scanner -> ('a * 'a * 'a) scanner
end

exception Error

(** Scan from a channel. *)
module Ch : sig
  include S with type 'a scanner = IO.input -> 'a
  val line : 'a scanner -> 'a scanner
end

(** Scan from standard input channel. *)
include S with type 'a scanner = unit -> 'a
