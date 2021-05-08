clear

%prompt
prompt = input("Select the function to fit your data:\n1. Polynomial: y = a0 + a1x + ... + amx^m\n2. Exponential: y = ae^(bx)\n3. Saturation: y = (ax)/(b+x)\nEnter the number:");
properfunction = prompt;
data = load('test2.txt');

%POLYNOMIAL
if (1 == properfunction)
    %prompt
    choicedegree = input("Enter the degree of the polynomial:");
    coefficient = 1;
    widthxaxis = length(data);
    data1 = data(:,coefficient);
    data2 = data(:, 2);
    
    %powers of x
    PowersofX = zeros(widthxaxis, choicedegree+coefficient);
    for A = 1:(2 * choicedegree)
        for b = 1:widthxaxis
            exponent = A;
            base = data(b,coefficient);
            PowersofX(b,A) = power(base, exponent);
        end
    end
    
    %left
    LeftSideX = zeros(choicedegree + coefficient, choicedegree + coefficient);
    balance = -1;
    for verticalCol = 1:(coefficient+choicedegree)
        horizontalRow = 1;
        
        %Other col
        if (1~= verticalCol)
            for row = 1: (1+choicedegree)
                rowindex = horizontalRow+balance;
                powersrowafterOffset = PowersofX(:,rowindex);
                adding = sum(powersrowafterOffset);
                LeftSideX(horizontalRow,verticalCol) = adding;
                horizontalRow = horizontalRow + coefficient;
            end
            
        %1st col
        else
            LeftSideX(horizontalRow,verticalCol) = widthxaxis;
            horizontalRow = 2;      
            while ((choicedegree + coefficient) >=horizontalRow)
                  rowindex = horizontalRow-coefficient;
                  powersoftherow = PowersofX(:,rowindex);
                  adding = sum(powersoftherow);
                  LeftSideX(horizontalRow, verticalCol) = adding;
                  horizontalRow = horizontalRow + coefficient;
            end
        end
        balance = coefficient+balance;
    end
    
    %right
    RightSideX = zeros(choicedegree + coefficient, coefficient);

    for row = 1:(1+choicedegree)
        rowindex= row- coefficient;
        powersofrow = power(data1,rowindex);
        multiplied = powersofrow .* data2;
        RightSideX(row,coefficient) = sum(multiplied); 
    end
    
    %coefficient
    
    allcoeff = LeftSideX\RightSideX;
    y = 0;
 
    for A = 1: (1+choicedegree)
        rowindex = A-1;
        powersofrow = power(data1,rowindex);
        multiplied = allcoeff(A,coefficient)*powersofrow;
        y = multiplied + y;      
    end
    
    %r squared
    data3 = data2;
    ywithlineontop1 = sum(data3);
    ywithlineontop2 = ywithlineontop1/widthxaxis;
    St1one = y - ywithlineontop2;
    squareofSt1 = St1one.^2;
    St2 = sum(squareofSt1);
    Sr1one = data3 - y;
    squareofSr1 = Sr1one .^2;
    firstSr = sum(squareofSr1);
    subtraction = St2 - firstSr;
    rsquared = subtraction/St2;
    
    %warning
    if (St2==0)
        disp("Warning for division by 0")
    end
    if(0== length(data))
        disp("Warning for division by 0")
    end
    
    %plot
    figure;
    plot(data1, data2,  data1, y);
    xlabel('x');
    ylabel('y');
    data4 = data(:,coefficient);
    data5 = data(:,2);
    dataXt = max(data4);
    xofT = 0.1* dataXt;
    dataYt = max(data5);
    yofT = 0.8 *dataYt;
    if (choicedegree ==1)
        gravstr = sprintf('Polynomial, Y = %f + %fx,\nR^2 = %f', allcoeff(coefficient,coefficient), allcoeff(2,coefficient),rsquared);
    elseif (choicedegree ==2)
        gravstr = sprintf('Polynomial, Y = %f + %fx + %fx^2,\nR^2 = %f', allcoeff(coefficient,coefficient), allcoeff(2,coefficient), allcoeff(3,coefficient),rsquared);
    elseif (choicedegree == 3)
        gravstr = sprintf('Polynomial, Y = %f + %fx + %fx^2 + %fx^3,\nR^2 = %f', allcoeff(coefficient,coefficient), allcoeff(2,coefficient), allcoeff(3,coefficient),allcoeff(4,coefficient) ,rsquared);
    else
        gravstr = sprintf('R^2 = %f',rsquared);
    end
    legend(gravstr);
    text(xofT ,yofT , gravstr, 'FontSize', 10 ,'Color', 'm');
end

%EXPONENTIAL
if (2 ==properfunction)
    widthxaxis = length(data);
    coefficient = 1;
    
    %find negative values
    data1=data(:,2);
    positivevalues1= 0< data1;
    positive = data(positivevalues1 , :); 
    lenxaxis = length(positive);
    secondcolumnofpositive = positive(:,2);
    firstcolofpositve = positive(:,1);

    %warning for negative value
    if(widthxaxis == lenxaxis)
    else
        disp('Invalid natural logarithm');
    end
    
    %natural log
    NaturalLogofY = log(secondcolumnofpositive);
    XafterNaturalLog =[firstcolofpositve NaturalLogofY];
    data3 = XafterNaturalLog(: , coefficient);
    data4 = XafterNaturalLog(:, 2);
    
    n = length(XafterNaturalLog);
    firstX = data3 ;
    secondX= data4;
    multiply = firstX .* secondX;
    sX = sum(multiply);
    sX3= sum(secondX);
    sX2= sum(firstX);
    firstXsquared = firstX .^2;
    sX2squared= sum(firstXsquared);
    firstparta1 = (n *sX) - (sX2 *sX3);
    secondparta1 = (n* sX2squared) - (sX2*sX2);
    Aone = firstparta1/secondparta1;
    x1withlineontop = sX2/n;
    x2withlineontop = sX3/n;
    A0= Aone *x1withlineontop;
    Azero = x2withlineontop - A0;
    positivevalues1= 0<data1 ;
    positive = data(positivevalues1 , :); 
    A = exp(Azero);
    %y with coefficients
    y = A * exp(Aone * firstX);
    
    
    %r squared
    sumofpositivecol = sum(secondcolumnofpositive);
    xnewwithlineontop = sumofpositivecol/lenxaxis;
    St1one= secondcolumnofpositive - xnewwithlineontop;
    St1square = St1one.*St1one;
    St2 =sum(St1square);
    Sr1one= secondcolumnofpositive - y;
    Sr1square = Sr1one .*Sr1one;
    firstSr= sum(Sr1square);
    rsquare1= St2-firstSr;
    rsquare= rsquare1/St2;
    
    %plot
    figure;
    plot(firstX, secondcolumnofpositive, firstX, y);
    xlabel('x');
    ylabel('y');
    dataXt =max(firstX);
    dataYt =max(secondcolumnofpositive);
    xofT =0.1 *dataXt;
    yofT =0.8* dataYt ;
    equation = sprintf('y = %fe^{%fx}\nR^2 = %f', A , Aone ,rsquare);
    text(xofT ,yofT , equation,  'Color', 'm','FontSize', 11);
end

%SATURATION
if (3 ==properfunction)
    %declaration
    newdata =data(:,:);

    lennew = length(newdata);
    coefficient = 1;
    datacol1= newdata(:,coefficient);
    datacol2 = newdata(:,2);
    
    %divide 1 by x and y
    xdivide =[1./datacol1 1./datacol2];
    lenxaxis = length(xdivide);
    
    %variables
    xOne = xdivide(:,coefficient);
    xTwo= xdivide(:,2);
    multiply1 = xOne .* xTwo;
    sofX= sum(multiply1);
    sofX1 = sum(xOne);
    sofX2 = sum(xTwo);
    multiply2 = xOne .^2;
    sofX1squared = sum(multiply2);
    a1part1 = (lenxaxis * sofX) - (sofX1 * sofX2);
    a1part2 = (lenxaxis * sofX1squared) - (sofX1*sofX1);
    aOne = a1part1/a1part2;
    x1withline = sofX1/lenxaxis;
    x2withline = sofX2/lenxaxis;
    aZero1 = aOne * x1withline;
    aZero = x2withline - aZero1;    
    a = coefficient/aZero;
    
    Xonenew=datacol1;
  
    
    Y=(a*Xonenew)/(aOne+Xonenew);
    
    %r squared
    horinewline = sum(datacol2)/lennew;
    StOne = datacol2 - horinewline;
    Stsquare = StOne.^2;
    Soft = sum(Stsquare);
    SrOne = datacol2-Y;
    Srsquare = SrOne .^2;
    firstSr = sum(Srsquare);
    rsquare=(Soft-firstSr)/Soft;

    %plot
    figure;
    plot(Xonenew, datacol2, Xonenew, Y);
    xlabel('x');
    ylabel('y');
    dataxT= max(xOne);
    datayT = max(datacol2);
    xofT = 0.1* dataxT;
    yofT = 0.8* datayT;
    equation = sprintf('y = (%fx)/(%f+x)\nR^2 = %f', a, aOne,rsquare(1));
    legend(equation);
    text(xofT,yofT, equation, 'FontSize', 12);
end