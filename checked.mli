(**************************************************************************
 *  Copyright (C) 2005
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
 *  (enclosed in the file LGPL).
 **************************************************************************)

(** Exception monad for errors checking *)

(** Monadic type: 'a stands for good value, 'b --- for exception reason *)
type ('a, 'b) t = 
     | Ok   of 'a      (** Ok, the value is attached *)
     | Fail of 'b list (** Something terrible happened, the reason attached *) 

(** Visualization functor *)
module Viewer (A : View.Viewable) (B : View.Viewable) : View.Viewable with type t = (A.t, B.t) t

(** If [x] is [Ok s], then [map f x] returns [Ok (f s)], otherwise [x] is returned.
    Example: [map (fun x -> x+1) (Ok 2)] returns [Ok 3], [map (fun x -> x+1) (Fail ["overflow"])] 
    returns [Fail ["overflow"]] *)
val map  : ('a -> 'b) -> ('a, 'c) t -> ('b, 'c) t

(** The same with the exception that [f] itself returns checked value. Example:
    [join (fun y -> y+3) (map (fun x -> x+1) (Ok 2))] returns [Ok 6] *)
val join : ('a -> ('b, 'c) t) -> ('a, 'c) t -> ('b, 'c) t

(** Infix synonim fom [map] *)
val (@>)  : ('a -> 'b) -> ('a, 'c) t -> ('b, 'c) t

(** Infix synonim for join *)
val (@@>) : ('a -> ('b, 'c) t) -> ('a, 'c) t -> ('b, 'c) t

(** Carry checked condition out of the list. [mapList [Ok x; Ok y; Ok y]] is [Ok[x; y; z]] 
while [mapList [Fail a; Ok b; Fail c]] is [Fail (a @ c)] *)
val mapList : ('a, 'b) t list -> ('a list, 'b) t

(** Carry checked condition out of the array. See [mapList] for details *)
val mapArray : ('a, 'b) t array -> ('a array, 'b) t
