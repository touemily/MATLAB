clear
%get data from file
data = load('test_1.txt');
%prompt
prompt = input('Select whether you want to perform Derivative (press oneValue) or Integration (press twoValue):');
if prompt ==1
    derivative();
elseif prompt ==2
    integral();
end

function derivative()
    data = load('test_1.txt');
    oneValue =1;
    twoValue =2;
    %prompt
    point_p = input('Enter the point, p you want to perform the derivative:');
    
    %point is not in data set
    setxaxis = data(:,oneValue);
    setyaxis = data(:,twoValue);
    maximumpoint = max(setxaxis);
    minimumpoint = min(setxaxis);
    if (maximumpoint <= point_p)
        disp('Point is not from data set');
    elseif (minimumpoint >=point_p )
        disp('Point is not from data set');
    
    %found in data set
    elseif(oneValue == ismember(point_p,setxaxis))
        %index of point_p
        a = find(setxaxis== point_p);
        
        subtraction1=data(a, oneValue)- data(a-oneValue, oneValue);
        subtraction2 =data(a+oneValue, oneValue)- data(a, oneValue);
        
        %spacing between the points is even
        if(subtraction1 ==subtraction2)   
            minxdifference =data(a, oneValue)- data(a-oneValue, oneValue);
            firsty=data(a-oneValue, twoValue);
            secondy=data(a+oneValue, twoValue);
            beforedivision1 = secondy-firsty;
            beforedivision2= minxdifference+minxdifference;
            letterd=beforedivision1/beforedivision2;
            disp(['Derivative:',num2str(letterd)]); 
        %if spacing between the points is not even
        else 
            %first use polynomial regression to estimate the function
            [aofX,sidey,squareofr, measure_d] =fitpoly(data);
            xdifference1 = diff(setxaxis);
            minxdifference = min(xdifference1);
            diff1=point_p-minxdifference;
            add1=point_p+minxdifference;
            firsty=putinto(diff1,aofX,measure_d); 
            secondy=putinto(add1,aofX,measure_d);
            
            %then perform Derivative using CDD method with h = minimum of Δx from the data point
            beforedivision3 = secondy-firsty;
            beforedivision4= minxdifference+minxdifference;
            letterd=beforedivision3/beforedivision4;
            derivativeresult =num2str(letterd);
            degree = num2str(measure_d);
            disp(['Derivative:',derivativeresult]);
            display(['Degree:',degree ]);
            
            %coefficients
            counter = oneValue;
            add2 = measure_d+oneValue;
            while add2>= counter
                counterdis = num2str(counter-oneValue);
                value1 = num2str(aofX(counter,oneValue));
                display(['a',counterdis,': ',value1 ]);
                counter = counter+oneValue;
            end
            
            %graph
            plot(setxaxis, setyaxis,  setxaxis, sidey);
            maxxaxis =max(setxaxis);
            maxyaxis= max(setyaxis);
            axisxvst = maxxaxis*0.2;
            axisyvst = maxyaxis*0.7;
            textsen = sprintf('R^2 = %f',squareofr);
            text(axisxvst,axisyvst,textsen,'FontSize', 12);
        end
        
    %the point is not from the data
    else
        %polynomial regression
        [aofX,sidey,squareofr, measure_d] = fitpoly(data);
        xdifference1 = diff(setxaxis);
        minxdifference = min(xdifference1);
        firsty=putinto(point_p-minxdifference,aofX,measure_d);
        secondy=putinto(point_p+minxdifference,aofX,measure_d);
        
        %then perform Derivative using CDD method with h = minimum ofΔx from the data point
        beforedivision5 = secondy-firsty;
        beforedivision6= minxdifference+minxdifference;
        letterd=beforedivision5/beforedivision6;
        derivativeresult =num2str(letterd);
        degree = num2str(measure_d);
        disp(['Derivative:',derivativeresult]);
        display(['Degree:',degree ]);

        %coefficients
        counter = oneValue;
        add2 = measure_d+oneValue;
            while add2>= counter
                counterdis = num2str(counter-oneValue);
                value1 = num2str(aofX(counter,oneValue));
                display(['a',counterdis,': ',value1 ]);
                counter = counter+oneValue;
            end
            
        %graph
        plot(setxaxis, setyaxis,  setxaxis, sidey);
        maxxaxis =max(setxaxis);
        maxyaxis= max(setyaxis);
        axisxvst = maxxaxis*0.2;
        axisyvst = maxyaxis*0.7;
        textsen = sprintf('R^2 = %f',squareofr);
        text(axisxvst,axisyvst, textsen, 'FontSize', 12);
    end
end

function integral()
    data = load('test_1.txt');
    zeroValue =0;
    oneValue =1;
    twoValue =2;
    firstlimit = input('p1:');
    secondlimit = input('p2:');
    setyaxis = data(:,twoValue);
    setxaxis = data(:,oneValue);
    flag = zeroValue;
    %Ask for the integration limit; p1, p2 where p2 > p1
    if(firstlimit>=secondlimit)
        flag = oneValue;
        disp('Condition has to be p2 > p1');
    end                                                  
    
    letterN = input('n:');
    
    if(zeroValue>=letterN)
        flag = oneValue;
        disp('Incorrect n');
    end
    
    if(flag == zeroValue)
        %p1 or p2 is out of the range of the original dataset, display a
        %message specifying the error (without calculating the integral)
        if(secondlimit > max(setxaxis))
             disp('Error: p1 or p2 is out of the range');
        elseif(firstlimit < min(setxaxis))
            disp('Error: p1 or p2 is out of the range');
        %within the range of the original data 
        elseif(oneValue== ismember(firstlimit, setxaxis) && oneValue==ismember(secondlimit, setxaxis))

            %position of point
            positionOne = find(setxaxis== firstlimit);
            positionTwo = find(setxaxis== secondlimit);
            letterh1= secondlimit-firstlimit;
            letterH = letterh1/letterN;
            counter = zeroValue;
            flagfind = zeroValue;

            %any of the values of the new data set do not belong to the original data set
            while(letterN>counter)
                pointp1=counter*letterH;
                point_p = firstlimit+pointp1;
                if(zeroValue==ismember(point_p, setxaxis))
                    flagfind=oneValue;
                    break;
                end
                counter= oneValue+counter;
            end
            
            firstdata=data(positionOne:positionTwo, oneValue);
            checkSpacing = diff(firstdata);
            max1=max(checkSpacing);
            min1=min(checkSpacing);
            if(min1~=max1)
                evenSpacing =zeroValue; 
            else
                evenSpacing =oneValue;
            end

            %the limits are from the data set
            if((evenSpacing == oneValue) && (flagfind == zeroValue))
                positioni =oneValue;
                tSum =zeroValue;
                while (letterN> positioni)
                    tindex=find(setxaxis== firstlimit+positioni*letterH);
                    tSum = tSum+data(tindex,twoValue);
                    positioni=positioni+oneValue;
                end
                calculate=(letterH/twoValue)*(data(positionOne,twoValue)+twoValue*tSum+data(positionTwo,twoValue));
                disp(['Integral is ',num2str(calculate)]);
                
            %regression
            else
                [aofX,sidey,squareofr, measure_d] = fitpoly(data);
              
                positioni = oneValue;
                tSum = zeroValue;

                %partial sum btw p1 and p2
                while (positioni < letterN)
                    tSum = tSum+putinto(firstlimit+positioni*letterH,aofX,measure_d);
                    positioni=positioni+oneValue;
                end
                
                %calculate integral and display
                calculate=(letterH/twoValue)*(putinto(firstlimit,aofX,measure_d)+twoValue*tSum+putinto(secondlimit,aofX,measure_d));
                disp(['Integral is ',num2str(calculate)]);

                %graph
                plot(setxaxis, setyaxis,  setxaxis, sidey);
                maxxaxis =max(setxaxis);
                maxyaxis= max(setyaxis);
                axisxvst = maxxaxis*0.2;
                axisyvst = maxyaxis*0.7;
                textsen = sprintf('R^2 = %f',squareofr);
                text(axisxvst,axisyvst,textsen,'FontSize', 12);
            end

        %p1 or p2 not found in data set
        else
                letterH = (secondlimit - firstlimit)/letterN;
                [aofX,sidey,squareofr, measure_d] = fitpoly(data);

                positioni = oneValue;
                tSum = zeroValue;

                while (positioni < letterN)
                    tSum = tSum+putinto(firstlimit+positioni*letterH,aofX,measure_d);
                    positioni=positioni+oneValue;
                end
                
                %equation for integral
                calc1=letterH/twoValue;
                calc2=putinto(firstlimit,aofX,measure_d);
                calc3=putinto(secondlimit,aofX,measure_d);
                calculate =calc1*(calc2+(twoValue*tSum)+calc3);
                result = num2str(calculate);
                disp(['Integral:',result]);
                
                %graph
                plot(setxaxis, setyaxis,  setxaxis, sidey);
                maxxaxis =max(setxaxis);
                maxyaxis= max(setyaxis);
                axisxvst = maxxaxis*0.2;
                axisyvst = maxyaxis*0.7;
                textsen = sprintf('R^2 = %f',squareofr);
                text(axisxvst,axisyvst,textsen,'FontSize', 12);
        end
    end
end

function [aofX,sideY,squareofR,measuredegree] =fitpoly(data)
    oneValue =1;
    twoValue =2;
    zeroValue =0;
    squareofR=twoValue;
    squareofRprev=oneValue;
    measuredegree=zeroValue;
    value1 =0.01;
    value2=squareofR-squareofRprev;
    while(value1<abs(value2))
        measuredegree=measuredegree+oneValue;
        squareofRprev=squareofR;
        value3=length(data);
        value4=measuredegree+oneValue;
        exponentX = zeros(value3, value4);
        verti = oneValue;
        
        value5= measuredegree*twoValue;
        while value5>=verti
            hori = oneValue;
            value6=length(data);
            while value6>=hori
                value7=data(hori,oneValue);
                exponentX(hori,verti) = power(value7, verti);
                hori = hori+oneValue;
            end
            verti = verti+oneValue;
        end

        leftofX = zeros(measuredegree+oneValue, measuredegree+oneValue);
        offset = -oneValue;
        vertiCol = oneValue;
        value8=measuredegree+oneValue;
        while value8>=vertiCol
            horirow = oneValue;

            if (horirow == oneValue) && (vertiCol == oneValue)
                leftofX(horirow,vertiCol) = value3;
                horirow = horirow + oneValue;
                value8=measuredegree+oneValue;
                while value8>=horirow
                      value10=horirow-oneValue;
                      value9=dexponentX(:,value10);
                      leftofX(horirow, vertiCol) = sum(value9);
                      horirow = horirow + oneValue;
                end

            else
                value8=measuredegree+oneValue;
                while value8>=horirow
                    value10=horirow+offset;
                    value9=dexponentX(:,value10);
                    leftofX(horirow, vertiCol) = sum(value9);
                    horirow = horirow + oneValue; 
                end
            end
            vertiCol = vertiCol + oneValue; 
            offset = offset + oneValue;
        end
        value11=measuredegree+oneValue;
        rightofX = zeros(value11, oneValue);
        horirow = oneValue;
        while value11>=horirow
            value12=data(:,oneValue);
            value13=power(value12,horirow-oneValue);
            value14=data(:, twoValue);
            rightofX(horirow,oneValue) = sum(value13.*value14); 
            horirow = horirow+oneValue;
        end

        aofX =leftofX\rightofX;
        sideY = zeroValue;
        letter_d = oneValue;
        value23= measuredegree+oneValue;
        while value23>=letter_d
            value24=aofX(letter_d,oneValue);
            value25=data(:,oneValue);
            value26=letter_d-oneValue;
            sideY = value24*power(value25,value26)+sideY;
            letter_d = letter_d +oneValue;
        end
    value28=data(:,twoValue);
    sizeofdata=length(data);
    lineontop=sum(value28)/sizeofdata;
    preSt= sideY - lineontop;
    tofS=sum(preSt.^2);
    preSr=data(:,twoValue)-sideY;
    rofS=sum(preSr.^2);
    value27=tofS-rofS;
    squareofR=value27/tofS;
    end
end
function result=putinto(data,aofX,measuredegree)
    oneValue =1;
    twoValue =2;
    zeroValue =0;
    countpos=oneValue;
    result=zeroValue;
    calc21=measuredegree+oneValue;
    while(calc21>=countpos)
        calc22=aofX(countpos, oneValue);
        calc23=countpos - oneValue;
        calc24=power(data,calc23);
        result = result +calc22*calc24;
        countpos=countpos+oneValue;
    end
end

