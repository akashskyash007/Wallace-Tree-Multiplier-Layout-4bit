#Script to generate results for all possible input combinations

#Initialization
stepsize 100;
h vdd;
l vss;
w res0 res1 res2 res3 res4 res5 res6 res7;
vector multiplicand a3 a2 a1 a0;
vector multiplier b3 b2 b1 b0;
vector layout_product res7 res6 res5 res4 res3 res2 res1 res0;
logfile layout_products.txt;

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

#Proc to generate all possible products
proc test_multiplier {input_vector_arr size_arg} {
	foreach inp1 $input_vector_arr {
		set layout_arg_1 "";
		for {set iter 0} {$iter < $size_arg} {incr iter} {
			set layout_arg_1 "$layout_arg_1[lindex $inp1 $iter]";
		}
		foreach inp2 $input_vector_arr {
			set layout_arg_2 "";
			for {set iter 0} {$iter < $size_arg} {incr iter} {
				set layout_arg_2 "$layout_arg_2[lindex $inp2 $iter]";
			}
			setvector multiplicand $layout_arg_1;
			setvector multiplier $layout_arg_2;
			s;
		}
	}
}

set vector_length 4;
set input_vector_arr [generate_all_binary_vectors $vector_length];
test_multiplier $input_vector_arr $vector_length;
