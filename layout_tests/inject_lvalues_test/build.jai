EXE_NAME :: "target";

// This represents the user's normal build script.
// We need to insert the macro somewhere in the build process that will run the layout proc at compile time,
// using the compile-time overload of chop.

build :: ()
{
    set_build_options_dc(.{do_output=false});

    w := compiler_create_workspace("Target Program");

    options := get_build_options(w);
    options.output_executable_name = EXE_NAME;
    options.output_path = "bin";
    set_build_options(options, w);

    layout_file := TEST.bake_it("layout");

    compiler_begin_intercept(w);

    add_build_file("target.jai", w);
    add_build_file(layout_file, w);

    message_loop(w);

    compiler_end_intercept(w);
}

// We won't require the user to modify their build loop to accomodate the UI.
// This is just a dummy.
message_loop :: (w: Workspace)
{
    while true
    {
        message := compiler_wait_for_message();
        if message.kind ==
        {
            case .COMPLETE;
                print("Message loop complete from main build!\n");
                break;
        }
    }
}

#import "Basic";
#import "Compiler";
TEST :: #import "test_module";

#run build();

