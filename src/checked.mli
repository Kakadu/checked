(**************************************************************************
 *  Copyright (C) 2005-2009
 *  Dmitri Boulytchev (db@tepkom.ru), St.Petersburg State University
 *  Universitetskii pr., 28, St.Petersburg, 198504, RUSSIA    
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
 *
 *  See the GNU Lesser General Public License version 2.1 for more details
 *  (enclosed in the file COPYING).
 **************************************************************************)

(** Exception monad for error checking. *)

(** Monadic type: 'a stands for good value, 'b --- for exception reason. *)
type ('a, 'b) t = 
     | Ok   of 'a      (** Ok, the value is attached *)
     | Fail of 'b list (** Something terrible happened, the reason attached *) 

(** Visualization functor. *)
module Viewer (A : View.Viewable) (B : View.Viewable) : View.Viewable with type t = (A.t, B.t) t

(** Unit: [unit x] returns [Ok x]. *)
val unit : 'a -> ('a, 'b) t

(** Conventional monadic [bind]. Example:  [bind (map (fun x -> x+1) (Ok 2)) (fun y -> Ok (y+3))] 
    returns [Ok 6].
 *)
val bind : ('a, 'c) t -> ('a -> ('b, 'c) t) -> ('b, 'c) t

(** If [x] is [Ok s], then [map f x] returns [Ok (f s)], otherwise [x] is returned.
    Example: [map (fun x -> x+1) (Ok 2)] returns [Ok 3], [map (fun x -> x+1) (Fail ["overflow"])] 
    returns [Fail ["overflow"]].
 *)
val map : ('a -> 'b) -> ('a, 'c) t -> ('b, 'c) t

(** Prefix synonym for [unit]. *)
val ( !! ) : 'a -> ('a, 'b) t

(** Infix synonym for [bind]. *)
val ( -?->> ) : ('a, 'c) t -> ('a -> ('b, 'c) t) -> ('b, 'c) t

(** Infix synonym for [map]. Note: the order of parameters is inverted. *)
val ( -?-> ) : ('a, 'c) t -> ('a -> 'b) -> ('b, 'c) t

(** Carry checked condition out of the list. [list [Ok x; Ok y; Ok y]] is [Ok[x; y; z]] 
    while [list [Fail a; Ok b; Fail c]] is [Fail (a @ c)]. 
 *)
val list : ('a, 'b) t list -> ('a list, 'b) t

(** Carry checked condition out of the array. See [list] for details. *)
val array : ('a, 'b) t array -> ('a array, 'b) t

(** Carry checked condition out of the option. *)
val option : ('a, 'b) t option -> ('a option, 'b) t

(** Carry checked condition out of the tuple. *)
val tuple : ('a, 'b) t * ('c, 'b) t -> ('a * 'c, 'b) t

(** [yieldWith f c] returns [x] when [c] is [Ok x] and [f y] if [c] is [Fail y]. *)
val yieldWith : ('b list -> 'a) -> ('a, 'b) t -> 'a

(** [yield x c] is a shortcut for [yieldWith (fun _ -> x) c]. *)
val yield : 'a -> ('a, 'b) t -> 'a

(** [uncheck c] is a shortcut for [yieldWith (fun _ -> invalid_arg "***uncheck***") c]. *)
val uncheck : ('a, 'b) t -> 'a

(** Prefix synonym for [list]. *)
val ( ?| ) : ('a, 'b) t list -> ('a list, 'b) t

(** Prefix synonym for [array]. *)
val ( ?|| ) : ('a, 'b) t array -> ('a array, 'b) t
