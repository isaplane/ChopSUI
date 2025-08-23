find_rects_in_expression :: (expression: Code) -> [..] *Code_Declaration
{
    rect_decls: [..] *Code_Declaration;
    root, expressions := compiler_get_nodes(expression);

    for expressions
    {
        if it.kind != .IDENT continue;

        decl := (cast(*Code_Ident) it).resolved_declaration;
        if !decl continue;

        if get_type(decl.type) == Rect array_add_if_unique(*rect_decls, decl);
    }

    return rect_decls;
}

write_node_rect_strings :: (amount: Code, node: *Node, left: *Node, right: *Node)
{
    root_expr, expressions := compiler_get_nodes(amount);

    rect_lit_str := sprint("Chop.Rect.{%, %, %, %}",
                            node.data.x_str,
                            node.data.y_str,
                            node.data.w_str,
                            node.data.h_str
    );

    builder: String_Builder;
    print_expression(*builder, root_expr); 
    expr_string := builder_to_string(*builder);

    if node.data.direction ==
    {
        case .LEFT;
            left.data.w_str = expr_string;

            left.data.x_str = node.data.x_str;
            left.data.y_str = node.data.y_str;
            left.data.h_str = node.data.h_str;

            right.data.w_str = sprint("% - (%)", node.data.w_str, expr_string);
            right.data.x_str = sprint("% + %", node.data.x_str, expr_string);

            right.data.y_str = node.data.y_str;
            right.data.h_str = node.data.h_str;

        case .RIGHT;
            left.data.w_str = expr_string;
            left.data.x_str = sprint("Chop.get_xmax(%) + 1 - %", rect_lit_str, expr_string);

            left.data.y_str = node.data.y_str;
            left.data.h_str = node.data.h_str;

            right.data.w_str = sprint("% - (%)", node.data.w_str, expr_string);

            right.data.x_str = node.data.x_str;
            right.data.y_str = node.data.y_str;
            right.data.h_str = node.data.h_str;

        case .TOP;
            left.data.h_str = expr_string;

            left.data.x_str = node.data.x_str;
            left.data.y_str = node.data.y_str;
            left.data.w_str = node.data.w_str;

            right.data.h_str = sprint("% - (%)", node.data.h_str, expr_string);
            right.data.y_str = sprint("% + %", node.data.y_str, expr_string);

            right.data.x_str = node.data.x_str;
            right.data.w_str = node.data.w_str;

        case .BOTTOM;
            left.data.h_str = expr_string;
            left.data.y_str = sprint("Chop.get_ymax(%) + 1 - %", rect_lit_str, expr_string);

            left.data.x_str = node.data.x_str;
            left.data.w_str = node.data.w_str;

            right.data.h_str = sprint("% - (%)", node.data.h_str, expr_string);

            right.data.x_str = node.data.x_str;
            right.data.y_str = node.data.y_str;
            right.data.w_str = node.data.w_str;
    }
}

bake_layout :: ($layout_proc: Code) -> path: string
{
    proc_node := compiler_get_nodes(layout_proc);
    proc_ident := cast(*Code_Ident) proc_node;
    proc_header := proc_ident.resolved_declaration.expression.(*Code_Procedure_Header);

    assert(proc_header.arguments.count == 1);
    proc_data_type := proc_header.arguments[0].type_inst.result;
    print("Proc: %\n", proc_ident.name);
    print("Proc data type: %\n", get_type(proc_data_type));

    proc_location := make_location(proc_ident.resolved_declaration);
    w_name := tprint("% bake", proc_ident.name);

    w := compiler_create_workspace(w_name);

    parent_options := get_build_options();
    options := get_build_options(w);
    options.output_type = .NO_OUTPUT;
    options.import_path = parent_options.import_path;
    set_build_options(options, w);

    compiler_begin_intercept(w);

    add_build_file(proc_location.fully_pathed_filename, w);
    add_build_string(tprint(bake_layout_build_str, get_type(proc_data_type), proc_ident.name), w);

    builder: String_Builder;
    while true
    {
        message := compiler_wait_for_message();
        if message.workspace != w continue;
        if message.kind ==
        {
            case .TYPECHECKED;
            {
                tc := cast(*Message_Typechecked) message;
                layout_proc_bodies := ASTist.find_procedure_decl_by_name_from_message(tc, proc_ident.name);

                if layout_proc_bodies.count == 0 continue;
                assert(layout_proc_bodies.count == 1); // Shouldn't be any overloaded layout procs
                layout_proc_body := layout_proc_bodies[0];

                if ASTist.proc_has_been_modified(layout_proc_body) continue;
                print("Found layout proc: %\n", layout_proc_body.header.name);
                results := ASTist.find_procedure_calls_by_name(layout_proc_body, "chop");
                print("Found % simple chop calls in %\n", results.simple_declarations.count, layout_proc_body.header.name);
                print("Found % compound chop calls in %\n", results.compound_declarations.count, layout_proc_body.header.name);
                print("Found % assignment chop calls in %\n", results.assignments.count, layout_proc_body.header.name);
                print("Found % chop calls without any lvalues in %\n", results.calls.count, layout_proc_body.header.name);

                handle_simple_chop_decls  (results.simple_declarations);
                handle_compound_chop_decls(results.compound_declarations);
                handle_assignment_chop_calls(results.assignments);
                // Note that I can ignore plain chop calls without lvalues, because the default ident values will be empty strings anyways.

                compiler_modify_procedure(w, layout_proc_body);
            }

            case .COMPLETE; break;
        }
    }

    compiler_end_intercept(w);

    return tprint(".build/bake_%.jai", proc_ident.name);
}

bake_rect_struct_decl :: (rect: Rect, struct_name: string, bsp: *Tree) -> string
{
    // get path to node from tree (based on exact shape match)
    xc, yc := get_center(rect);
    path: [..] *Node;
    node := BSP.find_leaf_containing_point(bsp, xc, yc, node_contains_point, *path);

    if !compare_rect(rect, node.data.rect)
    {
        for path
        {
            node = it;
            if compare_rect(rect, node.data.rect) break;
        }
    }

    // insert strings to here string and sprint
    return sprint(struct_decl_template,
                      struct_name,
                      node.data.x_str,
                      node.data.y_str,
                      node.data.w_str,
                      node.data.h_str);    
}

init_baked_rect :: (ui_data: $U/UI_Data, rect: $R) -> R #expand
{
    return #insert #run tprint("init_%(ui_data, rect);\n", R);
}

#scope_file

handle_simple_chop_decls :: (decls: [] *Code_Declaration)
{
    for decl: decls
    {
        call := decl.expression.(*Code_Procedure_Call);
        name := ASTist.get_lvalue_from_simple_declaration(decl).name;
        print("Found name: %\n", name);

        new_call := ASTist.insert_string_array_literal_as_argument(call, ..string.[name, ""]);
        call.* = new_call;
    }
}

handle_compound_chop_decls :: (decls: [] *Code_Compound_Declaration)
{
    for decl: decls
    {
        call := decl.declaration_properties.expression.(*Code_Procedure_Call);
        idents := ASTist.get_lvalues_from_compound_declaration(decl);
        names := Array_Helpers.map(idents, x => x.name);
        print("Found names: %\n", names);

        new_call := ASTist.insert_string_array_literal_as_argument(call, ..names);
        call.* = new_call;
    }
}

handle_assignment_chop_calls :: (assignments: [] *Code_Binary_Operator)
{
    for assignment: assignments
    {
        call := assignment.right.(*Code_Procedure_Call);
        idents := ASTist.get_lvalues_from_assignment(assignment);
        names := Array_Helpers.map(idents, x => x.name);
        print("Found names: %\n", names);
        if names.count == 1 array_add(*names, "");

        new_call := ASTist.insert_string_array_literal_as_argument(call, ..names);
        call.* = new_call;
    }
}

bake_layout_build_str :: #string HERE
BSP :: #import "BSP";
Chop :: #import "ChopSUI"(IS_BAKING = true);
#run
{
    layout_data: %;
    context.bsp = Chop.init_bsp(layout_data.root);
    %(*layout_data);
}
HERE

struct_decl_template :: #string HERE
% :: ()
{
    x: int = %;
    y: int = %;
    w: int = %;
    h: int = %;
}
HERE

BSP :: #import "BSP";
File_Helpers  :: #import "File_Helpers";
Array_Helpers :: #import "Array_Helpers";
ASTist        :: #import "ASTist";

#import "Compiler";
