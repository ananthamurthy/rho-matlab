function mySeq = generateRandomSeq(numElements)
for position = 1:numElements
    randomChoice = rand(1);
    if  randomChoice <= 0.25
        mySeq(position) = 'A';
    elseif randomChoice <= 0.50
        mySeq(position) = 'T';
    elseif randomChoice <= 0.75
        mySeq(position) = 'G';
    else
        mySeq(position) = 'C';
    end
end