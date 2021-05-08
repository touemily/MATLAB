format longg
matrixA = load("A.txt");
matrixB = load("B.txt");
sizeofA = size(matrixA);
sizeofB = size(matrixB);

if sizeofB(2) == sizeofA(2)
    inverseA = inv(matrixA);
    solutionmatrix = inverseA * matrixB';
    sizeofsolution = size(solutionmatrix);
    for i = 1:sizeofsolution(1)
        round(solutionmatrix(i), 5, 'significant')
    end
end


