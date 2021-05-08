format longg
matrixA = load("A.txt");
matrixB = load("B.txt");
sizeofA = size(matrixA);
numRow = sizeofA(1);

%forward elimination
biggestValue = matrixA(1, 1);
row = 0;
for a = 1:numRow-1
    for b = a:numRow
        if biggestValue < matrixA(b, a)
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
for i = 1:sizeofA(1)
        round(solutionmatrix(i), 5, 'significant')
end