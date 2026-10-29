# Run from any directory: vivado -mode batch -source scripts/create_project.tcl -tclargs projects/snake
set root [file normalize [file join [file dirname [info script]] ..]]
set tops [dict create \
    projects/vending-machine top \
    projects/whack-a-mole mole \
    projects/snake top \
    labs/07-led-marquee Marquee \
    labs/08-rgb-breathing Rainbow_Breathing_LED \
    labs/09-button-counter MC_TOP
]
if {[llength $argv] != 1 || ![dict exists $tops [lindex $argv 0]]} {
    error "Choose one of: [dict keys $tops]"
}
set design [lindex $argv 0]
set folder [file join $root $design]
set name [file tail $design]
create_project $name [file join $root build $name] -part xc7z020clg400-1
set src [concat [glob -nocomplain [file join $folder rtl *.v]] [glob -nocomplain [file join $folder rtl *.sv]]]
if {$design eq "labs/09-button-counter"} {
    # The top file textually includes the other RTL files.
    set src [list [file join $folder rtl MC_TOP.v]]
}
add_files -norecurse $src
set_property include_dirs [list [file join $folder rtl]] [get_filesets sources_1]
set_property top [dict get $tops $design] [get_filesets sources_1]
add_files -fileset constrs_1 [file join $folder constraints board.xdc]
# Testbench snapshots need the compatibility review described in docs/VERIFICATION.md.
# Keep them outside the active simulation set until their interfaces are reconciled.
update_compile_order -fileset sources_1
puts "Created $design. Review docs/VERIFICATION.md before synthesis or simulation."
