layout :: ()
{
    beep, boop := chop(.LEFT, 10 + 20);
    hip, hop := chop(.RIGHT, 34 + 65);
}

print_in_layout :: ()
{
    print("Hello from the layout file!\n");
}

#run layout();

#import "test_module";
#import "Basic";
#import "Compiler";
