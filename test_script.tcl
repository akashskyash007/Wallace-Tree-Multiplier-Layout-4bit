#Script to perform functional verification of the designed layout

#Initialization
stepsize 100;
h vdd;
l vss;
w res0 res1 res2 res3 res4 res5 res6 res7;
vector multiplicand a3 a2 a1 a0;
vector multiplier b3 b2 b1 b0;
vector layout_product res7 res6 res5 res4 res3 res2 res1 res0;

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

#Proc to convert binary to decimal
proc convert_binary_to_decimal {input_binary size_arg} {
	set res 0;
	for {set iter 0} {$iter < $size_arg} {incr iter} {
		set res [expr {$res + 2 ** $iter * [lindex $input_binary [expr {$size_arg - $iter - 1}]]}];
	}
	return $res;
}

#Proc to convert decimal to binary
proc convert_decimal_to_binary {input_decimal res_size} {
	set binary_rev_list "";
	set res "";
	set size 0;
	while {$input_decimal > 0} {
		lappend binary_rev_list [expr {$input_decimal % 2}];
		incr size;
		set input_decimal [expr {$input_decimal / 2}];
	}
	for {set iter 1} {$iter <= [expr {$res_size - $size}]} {incr iter} {
		lappend res 0;
	}
	for {set iter [expr {$size - 1}]} {$iter >= 0} {set iter [expr {$iter - 1}]} {
		lappend res [lindex $binary_rev_list $iter];
	}
	return $res;
}

#Proc to generate all possible products
proc test_multiplier {input_vector_arr size_arg} {
	puts "Multiplicand\t\tMultiplier\t\tProduct\t\tResult from Layout";
	foreach inp1 $input_vector_arr {
		set layout_arg_1 "";
		for {set iter 0} {$iter < $size_arg} {incr iter} {
			set layout_arg_1 "$layout_arg_1[lindex $inp1 $iter]";
		}
		foreach inp2 $input_vector_arr {
			set inp1_dec [convert_binary_to_decimal $inp1 $size_arg];
			set inp2_dec [convert_binary_to_decimal $inp2 $size_arg];
			set product [expr {$inp1_dec * $inp2_dec}];
			set product_bin [convert_decimal_to_binary $product [expr {$size_arg * 2}]];
			set layout_arg_2 "";
			for {set iter 0} {$iter < $size_arg} {incr iter} {
				set layout_arg_2 "$layout_arg_2[lindex $inp2 $iter]";
			}
			setvector multiplicand $layout_arg_1;
			setvector multiplier $layout_arg_2;
			set temp [s];
			set layout_result [d layout_product];
			puts "$inp1\t\t\t\t$inp2\t\t\t\t$product_bin\t\t\t\t$layout_result";
		}
	}
}

set vector_length 4;
set input_vector_arr [generate_all_binary_vectors $vector_length];
test_multiplier $input_vector_arr $vector_length; 
