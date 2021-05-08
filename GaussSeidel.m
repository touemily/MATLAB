format longg
matrixA = load("A.txt");
matrixB = load("B.txt");
sizeofA = size(matrixA);
numRow = sizeofA(1);

accuracy = 2;

for i = 1:numRow
        initialsolutionmatrix(numRow, :) = 0;
end

numIteration = 0;

for a = 1:numRow
    for b = 1: numIteration+1
        %calculate using formula
        solutionmatrix(b) = (matrixB(b)/matrixA(b, b)) - (matrixA(b, [1:b-1, b+1 :numIteration])*initialsolutionmatrix([1:b-1, b+1 :numIteration]))/matrixA(b, b);
        %round and save previous value
        initialsolutionmatrix(b) = round(solutionmatrix(b), 5, 'significant');
    end
    
    %calculate the Absolute Relative Approximate Error
    if max(abs((solutionmatrix-initialsolutionmatrix)/solutionmatrix)) < accuracy
        break
    end
    numIteration = numIteration + 1;
    
end

%output
fprintf('The required number of iterations for this accuracy is %d', numIteration)
for i = 1:sizeofA(1)
        round(solutionmatrix(i), 5, 'significant')
end


