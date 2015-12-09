function [] = plotThings(Scores)
	 Alower = tril(Scores,-1);
	 Aupper = triu(Scores, 1);
	 Impostors = reshape(Alower(:,1:end-1) + Aupper(:,2:end),  1,  []);
	 Genuines = diag(Scores);
	 plotROC(Genuines, Impostors, 20);
	 plotCMC(Scores);
	 figure('name','Historgam: Genuine(L) vs Imposter(R)');
     G=histogram(Genuines,20);
     G.FaceColor=[0 0 1];
     hold on;
	 H=histogram(Impostors,20);
     H.FaceColor=[1 0 0];
     title('Historgam: Genuine/Imposter');
     EER = getEER(Impostors,Genuines)
end

function [] = plotROC(Genuines, Impostors, Resolution)
    FARs = 0:1/Resolution:1;
    
    GARs = ones(size(FARs));
    for i=1:size(FARs,1)
        GARs(i) = 1-far2frr(Genuines, Impostors, FARs(i));
    end
    
	figure('name','ROC');
	plot(FARs,GARs,'r-');
    xlabel('FAR');
    ylabel('GAR');
    axis([0 inf 0 1])
    title('ROC');
end

function [] = plotCMC(Scores)
	 MinRanks = zeros(size(Scores,1));
	 for i=1:size(Scores,1)
		 Page = 1+floor((i-1)/size(Scores,1));
		 Col = mod(i-1,size(Scores,1))+1;
		 [~,Matches] = sort(Scores(:,Col,Page));
		 MinRanks(i)=find(Matches==Col,1);
	 end
	 %we now have a list of all the ranks
	 MinRanks = sort(MinRanks);
	 RankRates = ones(size(Scores,1));
	 for i=1:max(MinRanks)-1
	     RankRates(i) = find(MinRanks>i,1)/size(MinRanks,1);
	 end
	 figure('name','CMC');
	 plot(1:size(Scores,1),RankRates,'-r');
     title('CMC');
end

function [frr] = getFRR(genuines,threshold)
	found = find(sort(genuines)>threshold);
	if  ~isempty(found) && size(found,1)>0
		frr=found(1)/size(genuines,1);
	else
		frr=0;
	end 
end

function [far] = getFAR(impostors,threshold)
	found = find(sort(impostors)>threshold);
	if ~isempty(found) && size(found,1)>0
		far=found(1)/size(impostors,1);
	else
		far=0;
	end
end

function [frr] = far2frr(genuines,impostors,far)
	 impostors = sort(impostors);
     if (far==0)
		 threshold=min(impostors);
	 else
		 threshold=impostors(floor((size(impostors,1)-1)*far)+1);
     end
	 frr=getFRR(genuines,threshold);
end

function [error_rate,threshold] = getEER(impostors, genuines)
	threshold=genuines(size(genuines,1))/2;
	bisect=threshold/2;
	error_rate=getFRR(genuines,threshold);
	while bisect>=1
		frr=getFRR(genuines,threshold);
		far=getFAR(impostors,threshold);
		if frr>far
			threshold=threshold+bisect;
		else
			threshold=threshold+bisect;
		end
	       error_rate=frr;
	       bisect=bisect/2;
	end
end

function [dp] = dPrime(impostors,genuines)
	m0 = mean(impostors);
	m1 = mean(genuines);
	s0 = std(impostors);
	s1 = std(genuines);
	dp = sqrt(2)*abs(m1-m0)/sqrt(s0^2+s1^2);
end
