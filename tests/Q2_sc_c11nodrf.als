open ../models_als/sc[E] as M1 // the SC model
open ../models_als/c11_nodrf[E] as M2

sig E {}

pred gp [X : Exec_C] {

  withoutinit[X]
    
  // no atomic that aren't memory_order_seq_cst   
  A[none,X] in sc[none,X]

  // the execution is race-free in C11
  M2/dead[none,X]

  // The execution is not SC
  not (M1/consistent[none,X])

  // The execution is allowed by C11
  M2/consistent[none,X]
       
  // Prefer solutions without RMWs
  no_RMWs[none,X] 

}

run gp for 1 Exec, 4 E expect 1
// <2s, babillion, glucose
// finds store buffering violation (same as Batty et al. POPL 2011)

run gp for 1 Exec, 3 E expect 0
