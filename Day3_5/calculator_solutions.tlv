\m4_TLV_version 1d: tl-x.org
\SV

   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/bd1f186fde018ff9e3fd80597b7397a1c862cf15/tlv_lib/calculator_shell_lib.tlv'])
   
   //https://myth3.makerchip.com/sandbox/0XDfnhQOQ/0BghPjx
   
\SV
   
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   
\TLV
   |calc
      @0
         $reset = *reset;
         $valid = $reset ? 0 : (>>1$valid + 1);
         $valid_or_reset = $valid || $reset;
      
      ?$valid_or_reset
         @1
            $val1[31:0] = >>2$out;
            $val2[31:0] = $rand2[3:0];

            $sum[31:0] = $val1 + $val2;
            $diff[31:0] = $val1 - $val2;
            $prod[31:0] = $val1 * $val2;
            $quot[31:0] = $val1 / $val2;


         @2
            $out[31:0] = $reset ? 32'b0 :
                         ($op[2:0] == 3'b000) ? $sum :
                         ($op[2:0] == 3'b001) ? $diff :
                         ($op[2:0] == 3'b010) ? $prod :
                         ($op[2:0] == 3'b011) ? $quot :
                         ($op[2:0] == 3'b100) ? >>2$mem :
                         32'b0;
            
            $mem[31:0] = $reset ? 0 :
                         ($op[2:0] == 3'b100) ? >>2$mem :
                         ($op[2:0] == 3'b101) ? >>2$out :
                         >>2$out;

         

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
