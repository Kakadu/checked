open List
open Checked
open Printf 

let _ =
    let buffer = Buffer.create 1024 in
    let module IntCheck = Checked.Viewer (View.Integer)(View.String) in

    let x = Ok 1 in
    let y = Ok 2 in

    let z = ensure x, y in !! (x+y) end in

    Buffer.add_string buffer (sprintf "z=%s\n" (IntCheck.toString z));
    
    let x = Ok [1] in
    let y = Ok [2] in

    let z = ensure (x as [x]), (y as [y]) in !! (x+y) end in

    Buffer.add_string buffer (sprintf "z=%s\n" (IntCheck.toString z));

    printf "%s" (Buffer.contents buffer) 
