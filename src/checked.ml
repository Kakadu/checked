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

type ('a, 'b) t = Ok of 'a | Fail of 'b list

module Viewer (A : View.Viewable) (B : View.Viewable) =
  struct
    
    type x = (A.t, B.t) t
    type t = x

    open Printf 

    let toString = function
      | Ok x      -> sprintf "(Ok %s)" (A.toString x)
      | Fail msgs -> sprintf "(Fail [%s])" (let module M = View.List (B) in M.toString msgs)

  end

let unit x = Ok x

let bind x f = 
  match x with
  | Ok   x -> f x
  | Fail y -> Fail y

let map f value = 
  match value with
  | Ok   x -> Ok (f x)
  | Fail x -> Fail x

let ( !! ) = unit

let ( -?->> ) = bind
let ( -?-> ) x y = map y x

let array values =     
  let msgs, values, f = 
    Array.fold_left 
      (fun (msgs, acc, f) value ->
	match value with
	| Ok   x   -> msgs, x :: acc, f
	| Fail msg -> msg @ msgs, acc, false
      )
      ([], [], true)
      values
  in
  if f then Ok (Array.of_list (List.rev values)) else Fail (List.rev msgs)

let ( ?|| ) = array

let list values =
  let msgs, values, f = 
    List.fold_left 
      (fun (msgs, acc, f) value ->
	match value with
	| Ok   x   -> msgs, x :: acc, f
	| Fail msg -> msg @ msgs, acc, false
      )
      ([], [], true)
      values
  in
  if f then Ok (List.rev values) else Fail (List.rev msgs)

let ( ?| ) = list

let tuple = function
| Ok   x, Ok   y -> Ok (x, y)
| Fail x, Fail y -> Fail (x @ y)
| Fail x, _ | _, Fail x -> Fail x

let option = function
| None -> Ok None
| Some x -> x -?-> (fun t -> Some t)

let yieldWith f = function
| Ok x -> x
| Fail y -> f y

let yield x c = yieldWith (fun _ -> x) c

let uncheck c = yieldWith (fun _ -> invalid_arg "**uncheck**") c
