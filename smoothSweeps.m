function SmoothSweeps = smoothSweeps(AllSweeps,Config)



if strcmp(Config.SmoothingMethod,'grouped') == 1
    
    SmoothFactor = Config.SmoothingFactor;
    
    SmoothSweeps = zeros(floor(size(AllSweeps,1)/SmoothFactor),size(AllSweeps,2));
    
    for n=1:size(SmoothSweeps,1)
        firstInGroup = (n*SmoothFactor)-(SmoothFactor-1);
        lastInGroup = firstInGroup+(SmoothFactor-1);
        groupedSweeps = AllSweeps(firstInGroup:lastInGroup,:);
        SmoothSweeps(n,:) = mean(groupedSweeps,1);
        
    end
        
elseif strcmp(Config.SmoothingMethod,'running') == 1
    
    % Subtract 1 from the smoothfactor for easier indexing
    SmoothFactor = Config.SmoothingFactor-1;
    
    SmoothSweeps = zeros(size(AllSweeps,1)-SmoothFactor,size(AllSweeps,2));
    
    for n=1:size(SmoothSweeps,1)
        
        groupedSweeps = AllSweeps(n:n+SmoothFactor,:);
        SmoothSweeps(n,:) = mean(groupedSweeps,1);
        
    end

else
    disp('Smoothing method not recognized');
end


end



















