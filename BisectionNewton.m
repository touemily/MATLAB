prompt = 'What is the input resistance?';
R = input(prompt);

function1= (5.775*(10^-7)*(T^2))-(3.9083*(10^-3)*T)+((R/100)-1);
function2=(5.775*(10^-7)*(T^2))-(3.9083*(10^-3)*T)+(4.183*(10^-12)*(T-100)*(T^3))+((R/100)-1);

%decide which function to use
if R>100
    BisectionMethod(1,0,850,function1);
    
else 
    BisectionMethod(1,-200,0, function2);
    
end
if R>100
    NewtonMethod(1,425,function1);
    
else 
    NewtonMethod(1,-100, function2);
    
end

%Bisection Method
function BisectionMethod(BisectionIterations,lower,higher, func)
    
    %evaluate at lowest and highest value of range
    firstvalue=subs(func,lower);
    secondvalue=subs(func,higher);
    
    previousvalue=lower;
    
    %find midpoint
    T=(lower+higher)/2;
    
    newvalue=subs(func,T);
    BisectionRelativeError = abs((T-previousvalue)/abs(T))*100;
    
    %decide whether to continue with the next iteration
    if(0.05>=BisectionRelativeError)  
        fprintf('The temperature obtained by The Bisection Method is %f C.\r', T)
        fprintf('The number of required iterations for The Bisection Method is %i.\r', BisectionIterations)
        fprintf('The absolute relative approximate error for The Bisection Method is %f%%.', BisectionRelativeError)
    
    elseif 0>(newvalue*secondvalue)
        BisectionIterations = 1+ BisectionIterations;
        BisectionMethod(BisectionIterations,T,higher, func);
        
    elseif 0>(newvalue*firstvalue)
        BisectionIterations = 1 +BisectionIterations ;
        BisectionMethod(BisectionIterations,lower,T, func);

    end
    
end

%Newton Raphson Method
function NewtonMethod(NewtonIterations,initial, func)

    previousvalue = initial;

    differential = diff(func);
    
    F=subs(func, previousvalue);
    
    %differential with previous value substituted in the function
    DF=subs(differential, previousvalue);
    
    T = double(previousvalue - double(F/DF));
    
    %calculate the error
    NewtonRelativeError = abs((T-previousvalue)/abs(T))*100;
    
    %decide whether to continue with the next iteration
    if( 0.05>= NewtonRelativeError)
        fprintf('\rThe temperature obtained by The Newton Raphson Method is %f C.\r', T)
        fprintf('The number of required iterations for The Newton Raphson Method is %i.\r', NewtonIterations)
        fprintf('The absolute relative approximate error for The Newton Raphson Method is %f%%.', NewtonRelativeError)
    else
        NewtonIterations =1+NewtonIterations;
        NewtonMethod(NewtonIterations, T, func);
    end
    
end