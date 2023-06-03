#Script to perform functional verification of the designed layout

#Initialization
#stepsize 100;
#h vdd;
#l vss;

#Proc to generate all binary input vectors
proc generate_all_binary_vectors {size_arg} {
	set input_vector_arr ""
	set curr_vector "";
	for {set iter 0} {$iter < $size_arg} {incr iter} {
		lappend curr_vector 0;
	}
	for {set iter_out 1} {$iter_out <= [expr {2 ** $size_arg}]} {incr iter_out} {
		for {set iter_in 0} {$iter_in < $size_arg} {incr iter_in} {
			if {$iter_in == 0} {
				if {$iter_out % 2 == 0} {
					lset curr_vector [expr {$size_arg - $iter_in - 1}] 1;
				} else {
					lset curr_vector [expr {$size_arg - $iter_in - 1}] 0;
				}
			} else {
				if {$iter_out > 1 && ($iter_out - 1) % (2 ** $iter_in) == 0} {
					lset curr_vector [expr {$size_arg - $iter_in - 1}] [expr {!([lindex $curr_vector [expr {$size_arg - $iter_in - 1}]])}];
				}
			}
		}
		lappend input_vector_arr $curr_vector;
	}
	return $input_vector_arr;
}

set vector_length 4;
set input_vector_arr [generate_all_binary_vectors $vector_length];
puts $input_vector_arr;
