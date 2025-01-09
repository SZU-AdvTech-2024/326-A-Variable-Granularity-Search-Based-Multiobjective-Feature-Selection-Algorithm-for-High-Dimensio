function bestFeatures = PSOFeatureSelection(data, label, swarmSize, maxIterations, c1, c2)

    featNUM = size(data, 2);
    
    % Initialization
    position = rand(swarmSize, numFeatures) > 0.5;  % Initialize particles' positions
    velocity = rand(swarmSize, numFeatures);       % Initialize particles' velocities
    pBestPosition = position;                      % Initialize personal best positions
    pBestFitness = zeros(swarmSize, 1);            % Initialize personal best fitness values
    gBestPosition = zeros(1, numFeatures);         % Initialize global best position
    gBestFitness = inf;                            % Initialize global best fitness value
    
    % Main loop
    for iter = 1:maxIterations
        % Evaluate fitness for each particle
        fitness = EvaluateFitness(data, label, position);
        
        % Update personal best
        updateIndex = fitness < pBestFitness;
        pBestPosition(updateIndex, :) = position(updateIndex, :);
        pBestFitness(updateIndex) = fitness(updateIndex);
        
        % Update global best
        [minFitness, minIndex] = min(pBestFitness);
        if minFitness < gBestFitness
            gBestPosition = pBestPosition(minIndex, :);
            gBestFitness = minFitness;
        end
        
        % Update velocity and position
        r1 = rand(swarmSize, numFeatures);
        r2 = rand(swarmSize, numFeatures);
        velocity = velocity + c1 * r1 .* (pBestPosition - position) + c2 * r2 .* (repmat(gBestPosition, swarmSize, 1) - position);
        position = velocity > 0;
    end
    
    % Best features are represented by '1' in the global best position
    bestFeatures = find(gBestPosition);
end

function fitness = EvaluateFitness(data, label, position)
    % Evaluate fitness based on the selected features (represented by '1' in position)
    selectedFeatures = find(position);
    selectedData = data(:, selectedFeatures);
    
    % Use a classifier or evaluation metric to measure fitness
    % For example, if using k-nearest neighbors classifier:
    knnModel = fitcknn(selectedData, label, 'NumNeighbors', 3);
    accuracy = sum(predict(knnModel, selectedData) == label) / numel(label);
    
    % Fitness is defined as the complement of accuracy to be minimized
    fitness = 1 - accuracy;
end
