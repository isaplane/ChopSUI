get_proc_location_test :: ()
{
    location := #location(get_layout_proc_location);
    Verifai.are_equal(Source_Code_Location, type_of(location));
    Verifai.are_equal(location.fully_pathed_filename, "/home/egret/projects/jai/module_dev/ChopSUI/tests/bake_layout_tests/layout.jai");
} @Test

simple_decl_test :: ()
{
    build_filename := Chop.bake_layout(test_layout_simple_decl);
    Verifai.are_equal(".build/bake_test_layout_simple_decl.jai", build_filename);
} @Test

compound_decl_test :: ()
{
    build_filename := Chop.bake_layout(test_layout_compound_decl);
    Verifai.are_equal(".build/bake_test_layout_compound_decl.jai", build_filename);
} @Test

assignment_test :: ()
{
    build_filename := Chop.bake_layout(test_layout_assignments);
    Verifai.are_equal(".build/bake_test_layout_assignments.jai", build_filename);
} @Test

calls_test :: ()
{
    build_filename := Chop.bake_layout(test_layout_calls);
    Verifai.are_equal(".build/bake_test_layout_calls.jai", build_filename);
} @Test

#scope_file
#import "Basic";

Verifai :: #import "Verifai"; 
Chop    :: #import "ChopSUI";
BSP     :: #import "BSP";
