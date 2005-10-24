open List
open Checked
open Printf 

let _ =
    let buffer = Buffer.create 1024 in
    let module IntCheck = Checked.Viewer (View.Integer)(View.String) in
    Buffer.add_string buffer "Testing map function:\n"; 
    let _ = REPR (1) in
    let s, v = REPR (map (fun x -> x+1) (Ok 2)) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

             (* (IntCheck.toString (map (fun x -> x+1) (Ok 2))));*)
    Buffer.add_string buffer (sprintf "map (fun x -> x+1) (Fail []) = %s\n" 
          (IntCheck.toString (map (fun x -> x+1) (Fail []))));

    Buffer.add_string buffer "Testing (@>) operation:\n";
    Buffer.add_string buffer (sprintf "(fun x -> x+1) @> (Ok 2) = %s\n" 
          (IntCheck.toString ((fun x -> x+1) @> (Ok 2))));
    Buffer.add_string buffer (sprintf "(fun x -> x+1) @> (Fail []) = %s\n" 
          (IntCheck.toString ((fun x -> x+1) @> (Fail []))));

    Buffer.add_string buffer "Testing join function:\n";
    Buffer.add_string buffer (sprintf "join (fun x -> Ok (x+1)) (Ok 2) = %s\n" 
          (IntCheck.toString (join (fun x -> Ok (x+1)) (Ok 2))));
    Buffer.add_string buffer (sprintf "join (fun x -> Ok (x+1)) (Fail []) = %s\n" 
          (IntCheck.toString (join (fun x -> Ok (x+1)) (Fail []))));
    Buffer.add_string buffer (sprintf "join (fun x -> Fail[]) (Ok 2) = %s\n" 
          (IntCheck.toString (join (fun x -> Fail[]) (Ok 2))));
    Buffer.add_string buffer (sprintf "join (fun x -> Fail[]) (Fail []) = %s\n" 
          (IntCheck.toString (join (fun x -> Fail[]) (Fail []))));

    Buffer.add_string buffer "Testing (@@>) function:\n";
    Buffer.add_string buffer (sprintf "(fun x -> Ok (x+1)) @@> (Ok 2) = %s\n" 
          (IntCheck.toString ((fun x -> Ok (x+1)) @@> (Ok 2))));
    Buffer.add_string buffer (sprintf "(fun x -> Ok (x+1)) @@> (Fail []) = %s\n" 
          (IntCheck.toString ((fun x -> Ok (x+1)) @@> (Fail []))));
    Buffer.add_string buffer (sprintf "(fun x -> Fail[]) @@> (Ok 2) = %s\n" 
          (IntCheck.toString ((fun x -> Fail[]) @@> (Ok 2))));
    Buffer.add_string buffer (sprintf "(fun x -> Fail[]) @@> (Fail []) = %s\n" 
          (IntCheck.toString ((fun x -> Fail[]) @@> (Fail []))));

    Buffer.add_string buffer "Chain @> test:\n";
    Buffer.add_string buffer (sprintf "(fun x -> x+1) @> (fun x -> x+2) @> (Ok 3) = %s\n" 
          (IntCheck.toString ((fun x -> x+1) @> (fun x -> x+2) @> (Ok 3))));
    Buffer.add_string buffer (sprintf "(fun x -> x+1) @> (fun x -> x+2) @> (Fail []) = %s\n" 
          (IntCheck.toString ((fun x -> x+1) @> (fun x -> x+2) @> (Fail []))));

    Buffer.add_string buffer "Chain @>/@@> test:\n";
    Buffer.add_string buffer (sprintf "(fun x -> x+1) @> (fun x -> Ok (x+2)) @>> (Ok 3) = %s\n" 
          (IntCheck.toString ((fun x -> x+1) @> (fun x -> Ok (x+2)) @@> (Ok 3))));
    Buffer.add_string buffer (sprintf "(fun x -> x+1) @> (fun x -> Ok (x+2)) @>> (Fail []) = %s\n" 
          (IntCheck.toString ((fun x -> x+1) @> (fun x -> Ok (x+2)) @@> (Fail []))));

    let module IntListCheck = Checked.Viewer 
       (
         struct 

           type t = int list

           let toString = let module M = View.List (View.Integer) in M.toString

         end
       ) (View.String)
    in
    Buffer.add_string buffer "Testing mapList function:\n";
    Buffer.add_string buffer (sprintf "mapList [Ok 1; Ok 2; Ok 3] = %s\n"
          (IntListCheck.toString (mapList [Ok 1; Ok 2; Ok 3]))); 
    Buffer.add_string buffer (sprintf "mapList [Ok 1; Fail []; Ok 3] = %s\n"
          (IntListCheck.toString (mapList [Ok 1; Fail []; Ok 3]))); 
    Buffer.add_string buffer 
          (sprintf "mapList [Ok 1; Fail [\"t1\"]; Ok 3; Fail [\"t1\"]] = %s\n"
             (IntListCheck.toString 
                 (mapList [Ok 1; Fail ["t1"]; Ok 3; Fail ["t2"]])
          )); 

    let module IntArrayCheck = Checked.Viewer 
       (
         struct 

           type t = int array

           let toString = let module M = View.Array (View.Integer) in M.toString

         end
       ) (View.String)
    in

    Buffer.add_string buffer "Testing mapArray function:\n";
    Buffer.add_string buffer (sprintf "mapArray [|Ok 1; Ok 2; Ok 3|] = %s\n"
          (IntArrayCheck.toString (mapArray [|Ok 1; Ok 2; Ok 3|]))); 
    Buffer.add_string buffer (sprintf "mapArray [|Ok 1; Fail []; Ok 3|] = %s\n"
          (IntArrayCheck.toString (mapArray [|Ok 1; Fail []; Ok 3|])));
    Buffer.add_string buffer 
          (sprintf "mapArray [|Ok 1; Fail [\"t1\"]; Ok 3; Fail [\"t2\"]|] = %s\n"
          (IntArrayCheck.toString (mapArray [|Ok 1; Fail ["t1"]; Ok 3; Fail ["t2"]|])));

    printf "%s" (Buffer.contents buffer)
