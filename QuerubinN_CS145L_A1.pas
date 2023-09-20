Program CashierNZCQ;
uses crt, sysutils;

{----------------------------------------------------------------------------------------------------------------------------------}
{global declarations}
type
    Item = record
        code: integer;
        desc: string;
        price: real;
    end;
    RealArray = array of real;
{----------------------------------------------------------------------------------------------------------------------------------}
(*Constants*)
const
    NTRANMSG = #9'Do you want another transaction? <y/n>';
    CTRANMSG = #9'Total Amount Due:'#9;
    CerrTRANMSG = #9'Insufficient Cash!';

    ctypes : RealArray = (1000,500,100,50,20,10,5,1,0.25,0.10,0.05,0.01);

    Items : array of Item = (
                                (code: 101; desc: 'Tooti Frooti Rat Patootie'; price: 3.50),
                                (code: 201; desc: 'Uncle Jim''s Organic Eggs'; price: 5.50),
                                (code: 202; desc: 'Mysterious Pink Jerky'; price: 23.45),
                                (code: 102; desc: 'Massive Chocolate Crumpet'; price: 1.5),
                                (code: 301; desc: 'Romaine Lettuce'; price: 11.25)
                            );
    (*
    frtable = ''#201#205#205#205#205#205#205#205#205#205#205#205#205#205#205#205#205#203#205#205#205#205#205#205#205#205#205#205#205#205#205#205#205#205#203#205#205#205#205#205#205#205#187;*)
{----------------------------------------------------------------------------------------------------------------------------------}
(*Procedures*)

{Decimal Formatting}
procedure rform(x : real);
begin
    write(x:12:2);
end;
{Procedure for table generation }
procedure stable(x : integer);
var
    i : integer;
begin
    writeln(#9,#9,'Groceries');
    writeln('Item Code',#9, #9, 'Price', #9,'Description',#9);
    for i := 0 to x do
    begin
        if (i = x) then
            begin
                writeln('Input 0 to exit');
            end
        else
            begin
                write(Items[i].code,#9);
                rform(Items[i].price);
                write(#9, Items[i].desc,#9);
                writeln();
            end;
    {if conditional for last row}
    {else conditional for everything in between}
    end;

end;
{----------------------------------------------------------------------------------------------------------------------------------}
(*Functions*)
{input validation for int numbers}
function inpval(otype : integer): integer;
var
    x : integer;
    input : string;
begin
    repeat
        readln(input);
        Val(input,otype,x);
        if (x <> 0) then writeln('Invalid Input. Please input numbers');
    until x = 0;

    inpval := otype
end;
{input validation for real numbers}
function inpval(otype : real): real;
var
    x : integer;
    input : string;
begin
    repeat
        readln(input);
        Val(input,otype,x);
        if (x <> 0) then writeln('Invalid Input. Please input numbers');
    until x = 0;

    inpval := otype
end;

{Modulo for real numbers}
function fmod(x, y : real): real;
var
    carry : real;
begin
    if (x < 0) then carry := -x
    else
        carry := x;

    if (y < 0) then y := -y;

    while (carry >= y) do carry := carry - y;

    if (x < 0) then fmod := -carry
    else
        fmod := carry;
end;
{function that returns a real value after processing purchase orders}
function strans():real;
var
    choice, i, index : integer;
    flag : boolean;
    total : real;
begin
    stable(length(Items));
    total := 0;
    repeat
        flag := false;
        writeln('Input Item Code(Input 0 for checkout): ');
        choice := inpval(choice);
        for i := 0 to length(Items)-1 do
        begin
            if((choice = Items[i].code) or (choice = 0)) then
            begin
                flag := true;
                index := i;
            end;
        end;

        if (flag = false) then
            writeln('Invalid Code Entered')
        else if(choice = 0) then
        begin
            strans := total;
            exit();
        end
        else
        begin
            writeln(#9,#9,'Purchasing:');
            write(#9, Items[index].desc, #9);
            rform(Items[index].price);
            writeln();
            repeat
                if (i < 0) then writeln('Please input positive numbers');
                writeln('How many of this item would you like to buy? Input 0 to cancel your request');
                i := inpval(i);
            until (i > -1);

            if (i > 0) then total := total + (i * Items[index].price);
            write(#9,#9,'Buying ', i, ' ', Items[index].desc);
            writeln();
            write(#9,#9,'Subtotal: ');
            rform(total);
            writeln();
        end;

    until choice = 0;
end;

{Handles Cash Transaction Loop}
function ctrans(charge : real):real;
var
    pay: real;
begin
    write(CTRANMSG);
    rform(charge);
    writeln();
    repeat
        writeln('Input cash:');
        pay := inpval(pay);

        if(pay < charge) then writeln('Insufficient cash');
    until (pay >= charge);
    ctrans := pay - charge;
    write('Payment Accepted. Change from payment: ');
    rform(ctrans);
    writeln();
end;

{Handles Change Breakdown}
procedure cbreak(c : real);
var
    i : integer;
begin
    writeln(#9,#9,'Change Breakdown');
    for i := 0 to length(ctypes)-1 do
    begin
        if (c >= ctypes[i]) then
        begin
            rform(ctypes[i]);
            write(': '#9);
            write(#9,#9,(c/ctypes[i]):0:0);

            c := fmod(c,ctypes[i]);
            write(#9);
            rform(c);
            writeln();
        end;
    end;
end;

{Handles Next Transaction Loop}
function ntrans(): boolean;
var
    input : string;
begin
    while true do
    begin
        readln(input);
        case (input) of
            'y', 'n' : break;
        else
            writeln('Input is not y or n. Input new character')
        end;
    end;
    case (input) of
        'y' : ntrans := false;
        'n' : ntrans := true;
    end;
end;

{----------------------------------------------------------------------------------------------------------------------------------}
(*Main Block*)
{main program}
begin
    while true do
    begin
    {Next Transcation Loop}
        {Selection Loop}
        {Cash Loop}
        {rform(ctrans(strans()));}
        cbreak(ctrans(strans()));
        {Change Breakdown}

        {Next transaction choice}
        writeln(ntranmsg);
        if (ntrans() = true) then
            exit();
    end;
end.
