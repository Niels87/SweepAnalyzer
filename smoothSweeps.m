function SmoothSweeps = smoothSweeps(AllSweeps,Config)

SmoothFactor = Config.SmoothingFactor;

SmoothSweeps = zeros(round(size(AllSweeps,1)/SmoothFactor),size(AllSweeps,2));

for n=1:size(SmoothSweeps,2)
    
    if (size(AllSweeps,1)-n*SmoothFactor) >= SmoothFactor
        groupedSweeps = AllSweeps(1+(n-1)*SmoothFactor:SmoothFactor+(n-1)*SmoothFactor,:);
        SmoothSweeps(n,:) = mean(groupedSweeps,1);
    end

end