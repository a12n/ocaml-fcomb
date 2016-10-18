type 'a t = in_channel -> 'a

exception Error

let scan_aux ch fmt =
  try Scanf.bscanf (Scanf.Scanning.from_channel ch) fmt (fun v -> v)
  with (Scanf.Scan_failure _) -> raise Error
     | End_of_file -> raise Error

let string ch =
  match scan_aux ch " %s" with
  | "" -> raise Error
  | str -> str

let bool ch = scan_aux ch " %B"
let char ch = scan_aux ch " %c"
let float ch = scan_aux ch " %f"
let int ch = scan_aux ch " %i"
let unit _ch = ()

let bit ch = int ch <> 0

let big_int ch = Big_int.big_int_of_string (string ch)
let num ch = Num.num_of_string (string ch)

val array : ?first:string -> ?sep:string -> ?last:string -> ?n:int -> 'a t -> 'a array t
val hpair : ?first:string -> ?sep:string -> ?last:string -> 'a t -> ('a * 'a) t
val htriplet : ?first:string -> ?sep:string -> ?last:string -> 'a t -> ('a * 'a * 'a) t
val line : 'a t -> 'a t
val list : ?first:string -> ?sep:string -> ?last:string -> ?n:int -> 'a t -> 'a list t
val pair : ?first:string -> ?sep:string -> ?last:string -> 'a t -> 'b t -> ('a * 'b) t
val triplet : ?first:string -> ?sep:string -> ?last:string -> 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
