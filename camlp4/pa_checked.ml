(*
 * Pa_checked: a camlp4 extension for Checked module.
 * Copyright (C) 2006
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

(** Pa_checked --- a camlp4 syntax extension to work with Checked exception
    monad. 
*)


(**/**)

#load "pa_extend.cmo";
#load "q_MLast.cmo";

open Pcaml;

EXTEND
  GLOBAL: expr patt;

  expr: LEVEL "top" [
    [ "ensure"; items=LIST1 item SEP ","; "in"; body=expr; "end" -> 
         List.fold_right 
             (fun (e, p) b ->
                let pwel = [(p, None, b)] in
                let pfun = <:expr< fun [$list:pwel$] >> in
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
