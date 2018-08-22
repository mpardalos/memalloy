(*
MIT License

Copyright (c) 2018 by John Wickerson.

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

(** Representation of a solution found by Alloy *)

open! Format
open! General_purpose

(** Either a single execution, or a pair of executions linked by some mapping relation *)
type t =
  | Single of Exec.t
  | Double of Exec.t * Exec.t * Evt.t Rel.t

(** [hash_soln oc soln] prints to [oc] a string that represents the set of all solutions that are isomorphic to [soln]. This is useful for discarding duplicate solutions generated by Alloy *)
let hash_soln oc = function
  | Single x -> fprintf oc "Single(%a)" Exec.hash_exec x
  | Double (x,y,pi) -> fprintf oc "Double(%a)" Exec.hash_double_exec (x,y,pi)
           
