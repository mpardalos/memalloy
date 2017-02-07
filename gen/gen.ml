(*
MIT License

Copyright (c) 2017 by John Wickerson and Tyler Sorensen.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

open Format
open General_purpose
  
(*********************************)
(* Processing command-line input *)
(*********************************)

type output_type = Dot | Als
	       
let get_args () =
  let xml_path : string list ref = ref [] in
  let out_path : string list ref = ref [] in
  let output_dot = ref false in
  let output_als = ref false in
  let speclist = [
      ("-Tdot", Arg.Set output_dot, "Produce .dot output");
      ("-Tals", Arg.Set output_als, "Produce .als constraints");
      ("-o", Arg.String (set_list_ref out_path),
       "Output file (mandatory)");
    ] in
  let usage_msg =
    "Processing executions and generating litmus tests.\nUsage: `gen [options] <xml_file.xml>`.\nOptions available:"
  in
  Arg.parse speclist (set_list_ref xml_path) usage_msg;
  let bad_arg () =
    Arg.usage speclist usage_msg;
    raise (Arg.Bad "Missing or too many arguments.")
  in
  let xml_path = get_only_element bad_arg !xml_path in
  let out_path = get_only_element bad_arg !out_path in
  let out_type = match !output_dot, !output_als with
    | true, false -> Dot
    | false, true -> Als
    | _ -> bad_arg ()
  in
  xml_path, out_path, out_type

let check_args (xml_path, out_path, out_type) =
  assert (Filename.check_suffix xml_path ".xml")
		  
let main () =
  let xml_path, out_path, out_type = get_args () in
  check_args (xml_path, out_path, out_type);
  let (_, exec) = Xml_input.parse_file xml_path in
  let oc = formatter_of_out_channel (open_out out_path) in
  match out_type with
  | Dot ->
     assert (Filename.check_suffix out_path ".dot");
     fprintf oc "%a\n" Graphviz.dot_of_execution exec
  | Als ->
     assert (Filename.check_suffix out_path ".als");
     fprintf oc "%a\n" Alsbackend.als_of_execution exec
  (*let litmus = Mk_litmus.litmus_of_execution exec in
  printf "%a\n" Litmus.pp litmus;*)
    
let _ = main ()     
