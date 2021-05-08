%example equations
%(x^3) - (10*x) + y - z + 3;
%(y^3) + (10*y) - (2*x) - (2*z) - 5;
%x + y - (10*z) + (2*sin(z)) + 5;

%example initial condition
%X = [1, 1, 1];

%example variables
%W = [x, y, z]; 

syms x 
syms y 
syms z

num = input('How many equations are there?');
for b = 1:num
    A(b) = input('Enter one of the equations you have not entered');
end
for c = 1:num
    W(c) = input('Enter one of the variables you have not entered');
end
for d = 1:num
    X(1:d) = input('Enter one of the values of the inital condition one by one IN ORDER');
end

Iterations = 0;

NewtonRaphson(X, A, W, 0);

function NewtonRaphson(original, matrix, variables, Iterations)

    %vectors 
    RelativeError(1,1:3) = 0;
    S = zeros(3,1);
    
    flag = false;
    
    Jacob = jacobian(matrix, variables); 
    
    X = original;
    
    %check if the first iteration is being performd
    while (false == flag)
       if( 0 ~= Iterations) 
          previous = S;
          
       else
        previous = X;
        Iterations = Iterations + 1;
        
      end
      
      % Substitute values in function
      F = subs(matrix, variables, previous);
      
      %Jacobian with values substituted in
      G = subs(Jacob, variables, previous);
      
      %call the function from simulation 1
      S = previous - GaussianElimination(G, F);
      
      %Calculate absolute relative approximate error for each variable
      for j = 1:3
        RelativeError(j) = (abs((S(j)- previous(j))/abs(S(j)))*100);
        
      end
      
      %Check if error exceed 0.1% and whether to continue
      if(0.1 > max(RelativeError))
        flag = true;
        
      end
      Iterations = Iterations + 1;
      
    end
    fprintf('x = %f \n', S(1));
    fprintf('y = %f \n', S(2));
    fprintf('z = %f \n', S(3));
    fprintf('Iterations needed is %i \n', Iterations);
    fprintf('The final error is %f%% \n', max(RelativeError));
    
end

function Solution = GaussianElimination(Am, Bm)

    matrixA = Am;
    matrixB = Bm;
    sizeofA = size(matrixA);
    numRow = sizeofA(1);

    %forward elimination
    biggestValue = matrixA(1, 1);
    row = 0;
    
    for a = 1:numRow-1
        for b = a:numRow
            if abs(biggestValue) < abs(matrixA(b, a))
                biggestValue = matrixA(b, a);
                row = b;
            end
        end
        if row >0
            version1rowa = matrixA(a, :);
            matrixA(a, :) = matrixA(row, :);
            matrixA(row, :) = version1rowa;
            
            version1element = matrixB(a);
            matrixB(a) = matrixB(row);
            matrixB(row) = version1element;

        end
        
        for c =(a+1):numRow
            matrixA(c,:) = matrixA(c,:)-matrixA(a,:)*(matrixA(c,a)/matrixA(a,a));
           
            matrixB(c) = matrixB(c)-matrixA(a)*(matrixA(c,a)/matrixA(a,a));
            
        end
        row = 0;
        
    end

    %backward substitution
    solutionmatrix(numRow,:)= matrixB(numRow)/matrixA(numRow, numRow);
    
    for d = numRow-1:-1:1
        solutionmatrix(d,:) = (matrixB(d)-matrixA(d, d+1:numRow)*solutionmatrix(d+1:numRow, :))/matrixA(d, d);
        
    end
    
    %output
    A = round(solutionmatrix(1), 5, 'significant');
    B = round(solutionmatrix(2), 5, 'significant');
    C = round(solutionmatrix(3), 5, 'significant');
    Solution = [A, B, C];
end