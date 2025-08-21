get_proc_location_test :: ()
{
    location := #location(get_layout_proc_location);
    Verifai.are_equal(Source_Code_Location, type_of(location));
    Verifai.are_equal(location.fully_pathed_filename, "/home/egret/projects/jai/module_dev/ChopSUI/tests/bake_layout_tests/layout.jai");
} @Test

get_build_location_from_bake_test :: ()
{
    build_filename := Chop.bake_layout(Test_Layout_1_Data.{}, test_layout_1);
    Verifai.are_equal(".build/bake_layout.jai", build_filename);
} @Test

#scope_file
#import "Basic";

Verifai :: #import "Verifai"; 
Chop    :: #import "ChopSUI";
