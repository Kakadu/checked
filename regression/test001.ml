open List
open Checked
open Printf 

let _ =
    let buffer = Buffer.create 1024 in
    let module IntCheck = Checked.Viewer (View.Integer)(View.String) in

    Buffer.add_string buffer "Testing unit function:\n";

    let s, v = REPR (unit 1) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Testing ( !! ) operation:\n";

    let s, v = REPR (!! 1) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Testing map function:\n"; 

    let s, v = REPR (map (fun x -> x+1) (Ok 2)) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR (map (fun x -> x+1) (Fail [])) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Testing ( -?-> ) operation:\n";

    let s, v = REPR ((Ok 2) -?-> (fun x -> x+1)) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR ((Fail []) -?-> (fun x -> x+1)) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Testing bind function:\n";

    let s, v = REPR (bind (Ok 2) (fun x -> Ok (x+1))) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR (bind (Fail []) (fun x -> Ok (x+1))) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR (bind (Ok 2) (fun x -> Fail[])) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR (bind (Fail []) (fun x -> Fail[])) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Testing ( -?->> ) operation:\n";

    let s, v = REPR ((Ok 2) -?->> (fun x -> Ok (x+1))) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR ((Fail []) -?->> (fun x -> Ok (x+1))) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR ((Ok 2) -?->> (fun x -> Fail[])) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR ((Fail []) -?->> (fun x -> Fail[])) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Chain ( -?-> ) test:\n";

    let s, v = REPR ((Ok 3) -?-> (fun x -> x+2) -?-> (fun x -> x+1)) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR ((Fail []) -?-> (fun x -> x+2) -?-> (fun x -> x+1)) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    Buffer.add_string buffer "Chain -?->/-?->> test:\n";

    let s, v = REPR ((Ok 3) -?-> (fun x -> x+1) -?->> (fun x -> Ok (x+2))) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let s, v = REPR ((Fail []) -?-> (fun x -> x+1) -?->> (fun x -> Ok (x+2))) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntCheck.toString v));

    let module IntListCheck = Checked.Viewer 
	(
         struct 
	   
           type t = int list

           let toString = let module M = View.List (View.Integer) in M.toString
	     
         end
	) 
	(View.String)
    in

    Buffer.add_string buffer "Testing list function:\n";

    let s, v = REPR (list [Ok 1; Ok 2; Ok 3]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntListCheck.toString v)); 

    let s, v = REPR (list [Ok 1; Fail []; Ok 3]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntListCheck.toString v)); 

    let s, v = REPR (list [Ok 1; Fail ["t1"]; Ok 3; Fail ["t2"]]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntListCheck.toString v)); 

    Buffer.add_string buffer "Testing ( ?| ) operation:\n";

    let s, v = REPR (?| [Ok 1; Ok 2; Ok 3]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntListCheck.toString v)); 

    let s, v = REPR (?| [Ok 1; Fail []; Ok 3]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntListCheck.toString v)); 

    let s, v = REPR (?| [Ok 1; Fail ["t1"]; Ok 3; Fail ["t2"]]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntListCheck.toString v)); 

    let module IntArrayCheck = Checked.Viewer 
	(
         struct 

           type t = int array

           let toString = let module M = View.Array (View.Integer) in M.toString

         end
	) 
	(View.String)
    in

    Buffer.add_string buffer "Testing array function:\n";

    let s, v = REPR (array [|Ok 1; Ok 2; Ok 3|]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntArrayCheck.toString v)); 

    let s, v = REPR (array [|Ok 1; Fail []; Ok 3|]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntArrayCheck.toString v));

    let s, v = REPR (array [|Ok 1; Fail ["t1"]; Ok 3; Fail ["t2"]|]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntArrayCheck.toString v));

    Buffer.add_string buffer "Testing ( ?|| ) operation:\n";

    let s, v = REPR (?|| [|Ok 1; Ok 2; Ok 3|]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntArrayCheck.toString v)); 

    let s, v = REPR (?|| [|Ok 1; Fail []; Ok 3|]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntArrayCheck.toString v));

    let s, v = REPR (?|| [|Ok 1; Fail ["t1"]; Ok 3; Fail ["t2"]|]) in
    Buffer.add_string buffer (sprintf "%s = %s\n" s (IntArrayCheck.toString v));

    printf "%s" (Buffer.contents buffer) 
