Direction :: enum { LEFT; RIGHT; TOP; BOTTOM;}

chop :: (direction: Direction, $amount: Code) -> int, int #expand
{
    value := #insert amount;
    print("Chopped % for % amount at runtime.\n", direction, value);
}

chop :: (direction: Direction, $amount: Code, lvalues: .. string) -> int, int #compile_time #expand
{
    value := #insert amount;

    if lvalues.count > 0 && lvalues[0] == "beep"
    {
        print("Chopped % for % amount at compile time.\n", direction, value);
        print("Stored in %.\n", lvalues);

        ok := write_entire_file(".build/success_string.jai", tprint(SUCCESS_MESSAGE, lvalues[0], lvalues[1]));
        print("wrote file ok? %\n", ok);
    }

    else
    {
        print("Found the compile-time chop, but no lvalues provided!\n");
    }
}

bake_it :: (proc: Code) -> string
{
    print("cwd: %\n", get_working_directory());
    w := compiler_create_workspace("Layout macro");

    parent_options := get_build_options();
    options := get_build_options(w);
    options.output_type = .NO_OUTPUT;
    options.import_path = parent_options.import_path;
    set_build_options(options, w);

    compiler_begin_intercept(w);

    add_build_string(BUILD_STRING, w);

    // This would need to be passed in for a real case?
    add_build_file("../layout.jai", w);

    message_loop(w);

    compiler_end_intercept(w);

    return ".build/success_string.jai";
}

message_loop :: (w: Workspace)
{

    builder: String_Builder;
    while true
    {
        message := compiler_wait_for_message();
        if message.workspace != w continue;

        if message.kind ==
        {
            case .TYPECHECKED;
                typechecked := cast(*Message_Typechecked) message;    
                for body: typechecked.procedure_bodies
                {
                    if body.expression.header.name != "layout" continue;
                    print("Found layout proc!\n");

                    layout_body := body.expression;
                    if layout_body.body_flags & .ALREADY_MODIFIED continue;

                    assert(layout_body.block != null);

                    for stmt_node: layout_body.block.statements
                    {
                        stmt := cast(*Code_Compound_Declaration) stmt_node;
                        decl := stmt.declaration_properties.expression;  // This holds the rhs of the proc call (kind: PROCEDURE CALL)
                        print_expression(*builder, decl);
                        print("Declaration (%): %\n", decl.kind, builder_to_string(*builder));

                        call := cast(*Code_Procedure_Call) decl;
                        header := cast(*Code_Procedure_Header) call.resolved_procedure_expression;
                        if header.name != "chop" continue;

                        new_args: [..] Code_Argument;
                        array_add(*new_args, .. call.arguments_unsorted);
                        args := stmt.comma_separated_assignment.arguments; // This holds the lhs of the proc call!
                        for args 
                        {
                            print_expression(*builder, it.node);
                            print("%\n", builder_to_string(*builder));
                            ident := cast(*Code_Ident) it.node;
                            ident_lit := make_string_literal(ident.name);
                            array_add(*new_args, .{expression = ident_lit});
                        }

                        for new_args
                        {
                            print_expression(*builder, it.expression);
                            print("Arg, index %: %\n", it_index, builder_to_string(*builder));
                        }

                        new_call := New(Code_Procedure_Call);
                        new_call.base = call.base;
                        new_call.base.kind = .PROCEDURE_CALL;
                        new_call.procedure_expression = call.procedure_expression;
                        new_call.arguments_unsorted = new_args;

                        stmt.declaration_properties.expression = new_call;

                        // print_expression(*builder, stmt);
                        // print("Statement (%): %\n", stmt.kind, builder_to_string(*builder));
                    }

                    compiler_modify_procedure(w, layout_body);
                }

            case .COMPLETE;
                print("Message loop complete from test_module!\n");
                break;
        }
    }
}

BUILD_STRING :: #string HERE
#import "Basic";
#run print("\nHello from the layout workspace!\n\n");
HERE

SUCCESS_MESSAGE :: #string HERE
SUCCESS_MESSAGE :: "Success!!! Found % and % as lvalues!\n";
HERE

#import "Program_Print";
#import "Compiler";
#import "Basic";
#import "File";
