# 4-bit Ripple-Carry Adder

Half adder → full adder → four-stage ripple-carry adder. The imported Vivado source contains the implementation; the nearby course-template folder is empty.

Only the completed 4-bit path is showcased. CLA_4 / CLA_8 are empty templates, and RCA_8 contains a missing-extension include, so they are excluded. No carry-lookahead performance claim is made.

`RCA_4.v` includes `FA.v`, which includes `HA.v`; compile the root file with `rtl/` as the include path rather than compiling every included file twice.
