function fit = CalcObjs(trainData, trainLabel, testData, testLabel, X)
%% Calculate Objective Values

	X = X > 0;

	m = size(X, 1);
	fit = zeros(m, 2);
	for i = 1 : m
		fit(i, :) = KNN(trainData, trainLabel, testData, testLabel, X(i, :));
	end
	
end

function fit = KNN(trainData, trainLabel, testData, testLabel, X)

    if sum(X) == 0
        fit = [1, size(trainData, 2)];
        return;
    end
    Prelabel = zeros(size(testLabel, 1), 1);
    Mdl = fitcknn(trainData(:, X), trainLabel,'NumNeighbors', 5);
    Prelabel(:, 1) = predict(Mdl, testData(:, X));
    acc = length(find(Prelabel(:, 1) == testLabel)) / size(testLabel, 1);
    err = 1 - acc;
    fit = [err, sum(X)];

end