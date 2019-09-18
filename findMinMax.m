
%   This function finds the x-values of the early and late component as
%   well as the local maximum between them.

function [earlyComp_x,lateComp_x,localMax_x] = findMinMax(SingleSweep,Config)

if strcmp(Config.MinimumDetection{1},'auto') == 1
    
    window = Config.MinimumDetection{2};
    
    %   Find local minimums (early+late comp)
    [~,Pmin] = islocalmin(SingleSweep(window(1):window(2)));
    %   [localMin,Pmin] = islocalmin(SingleSweep);
    Pmin = Pmin .* SingleSweep(window(1):window(2));
    plot(Pmin);

    %   Find 3 most significant minimums
    Pmin1 = min(Pmin);
    Pmin2 = min(Pmin(Pmin>Pmin1));
    Pmin3 = min(Pmin(Pmin>Pmin2));

    %   Use 3rd as a cutoff
    Pmin_cutoff = Pmin3;

    %   Tag minimums more signinficant than the 3rd
    localMin_real = logical(Pmin>Pmin_cutoff);

    %   Find indices of local minimums
    localMinimum = find(localMin_real);

    %   Fixes issue with 2 datapoints at a minimum having the same exact
    %   value
    localMinimum = [localMinimum(1) localMinimum(end)];

    % Find local maximum (peak between early and late comp)

    [~,Pmax] = islocalmax(SingleSweep);
    Pmax_between = Pmax(localMinimum(1):localMinimum(2));

    Pmax1 = max(Pmax_between);
    Pmax2 = max(Pmax(Pmax<Pmax1));
    Pmax_cutoff = Pmax2;

    localMax_real = logical(Pmax>Pmax_cutoff);

    localMaximum = find(localMax_real);

    %   Fixes issue with 2 datapoints at a maximum having the same exact
    %   value or findng a maximum outside of the early and late component
    plot(SingleSweep);
    localMaximum = localMaximum(localMaximum>localMinimum(1) & localMaximum<localMinimum(2));
    localMaximum = localMaximum(1);

    %   Outputs:
    earlyComp_x = localMinimum(1)+(window(1)-1);
    lateComp_x = localMinimum(2)+(window(1)-1);
    localMax_x = localMaximum +(window(1)-1);

elseif strcmp(Config.MinimumDetection{1},'window') == 1
    
    earlyWindow = Config.MinimumDetection{2};
    lateWindow = Config.MinimumDetection{3};
    
    %   Find global minimum within window
    withinEarlyWindow = SingleSweep(earlyWindow(1):earlyWindow(2));
    [~,I] = min(withinEarlyWindow);

    earlyComp_x = I + ( earlyWindow(1)-1 );

    withinLateWindow = SingleSweep(lateWindow(1):lateWindow(2));
    [~,I] = min(withinLateWindow);

    lateComp_x = I + ( lateWindow(1)-1 );

    betweenEarlyLate = SingleSweep(earlyComp_x:lateComp_x);
    [~,I] = max(betweenEarlyLate);

    localMax_x = I + ( earlyComp_x - 1 );
    
elseif strcmp(Config.MinimumDetection{1},'interactive') == 1
    
    earlyWindow = Config.MinimumDetection{2};
    lateWindow = Config.MinimumDetection{3};
    localMaxWindow = Config.MinimumDetection{4};


    %   Find global minimum within window
    withinEarlyWindow = SingleSweep(earlyWindow(1):earlyWindow(2));
    [~,I] = min(withinEarlyWindow);

    earlyComp_x = I + ( earlyWindow(1)-1 );

    withinLateWindow = SingleSweep(lateWindow(1):lateWindow(2));
    [~,I] = min(withinLateWindow);

    lateComp_x = I + ( lateWindow(1)-1 );

    withinLocalMaxWindow = SingleSweep(localMaxWindow(1):localMaxWindow(2));
    [~,I] = max(withinLocalMaxWindow);

    localMax_x = I + ( localMaxWindow(1) - 1 );

end


end

