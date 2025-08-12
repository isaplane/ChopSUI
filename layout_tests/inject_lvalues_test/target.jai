foo :: ()
{
    print("%\n", SUCCESS_MESSAGE);
}

main :: ()
{
    print("Hello from the target program!\n");
    foo();
}

#placeholder SUCCESS_MESSAGE;

#import "Basic";
#import "Compiler";
