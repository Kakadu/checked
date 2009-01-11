(*
 * Pa_checked: a camlp4/camlp5 extension for Checked module.
 * Copyright (C) 2006-2009
 * Dmitri Boulytchev, St.Petersburg State University
 * 
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License version 2, as published by the Free Software Foundation.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * 
 * See the GNU Library General Public License version 2 for more details
 * (enclosed in the file COPYING).
 *)

(** Pa_checked --- a camlp4/camlp5 syntax extension to work with [Checked] exception
    monad. 

    A new [ensure] construct is added at expression level. The construct 
    allows to bind several checked values in a row. 

    Example:

    [ensure x, y, z in Ok (x+y+z) end]

    is equivalent to

    [x -?->> (fun x -> y -?->> (fun y -> z -?->> (fun z -> Ok (x+y+z))))]

    Note that the body of [ensure] expression has to be of checked type and that
    the [ensure] key values have to be simple identifiers.

    Another flavour of [ensure] construct is introduced to provide
    pattern-matching facility. 

    Example:

    [ensure (x as Some x), (y as Some y) in Ok (x+y) end]

    The surrounding brackets are mandatory for [ensure] key values to distinguish the 
    latter variant of the construct from the former.

    The construct above is equivalent to

    [x -?->> (fun (Some x) -> y -?->> (fun (Some y) -> Ok (x+y)))]
*)

(**/**)

open Camlp4.PreCast
open Syntax

EXTEND Gram
  GLOBAL: expr patt;

  expr: LEVEL "top" [
    [ "ensure"; items=LIST1 item SEP ","; "in"; body=expr; "end" -> 
         List.fold_right 
             (fun (e, p) b ->
                let pfun = <:expr< fun $p$ -> $b$ >> in
                <:expr< Checked.bind $e$ $pfun$ >>
             )
             items
             body
    ]
  ];

  item: [
    [ "("; e=expr; "as"; p=patt; ")" -> (e, p) ] |
    [ i=LIDENT -> (<:expr< $lid:i$ >>, <:patt< $lid:i$ >>) ]
  ];

END;
