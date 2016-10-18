type 'a t = out_channel -> 'a -> unit

val big_int : Big_int.big_int t
val bit : bool t
val bool : bool t
val char : char t
val float : float t
val int : int t
val num : Num.num t
val string : string t
val unit : unit t

val array : ?first:string -> ?sep:string -> ?last:string -> 'a t -> 'a array t
val hpair : ?first:string -> ?sep:string -> ?last:string -> 'a t -> ('a * 'a) t
val htriplet : ?first:string -> ?sep:string -> ?last:string -> 'a t -> ('a * 'a * 'a) t
val line : 'a t -> 'a t
val list : ?first:string -> ?sep:string -> ?last:string -> 'a t -> 'a list t
val pair : ?first:string -> ?sep:string -> ?last:string -> 'a t -> 'b t -> ('a * 'b) t
val triplet : ?first:string -> ?sep:string -> ?last:string -> 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
