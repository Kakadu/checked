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

let map f value = 
    match value with
    | Ok   x -> Ok (f x)
    | Fail x -> Fail x

let join f value =
    match value with
    | Ok   x -> f x
    | Fail x -> Fail x

let (@>)  = map
let (@@>) = join

let mapList values =
    let msgs, values = List.fold_left (fun (msgs, acc) value ->
       match value with
       | Ok   x   -> msgs, x :: acc
       | Fail msg -> msg @ msgs, acc
      )
      ([], [])
      values
    in
    match msgs with
    | [] -> Ok (List.rev values)
    | _  -> Fail (List.rev msgs)
      
let mapArray values =     
    let msgs, values = Array.fold_left (fun (msgs, acc) value ->
       match value with
       | Ok   x   -> msgs, x :: acc
       | Fail msg -> msg @ msgs, acc
      )
      ([], [])
      values
    in
    match msgs with
    | [] -> Ok (Array.of_list (List.rev values))
    | _  -> Fail (List.rev msgs)
    
