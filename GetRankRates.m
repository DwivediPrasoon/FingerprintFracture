function [ RankRates ] = GetRankRates( Scores )
%GETRANKRATES Summary of this function goes here
%   Detailed explanation goes here
	 MinRanks = zeros(2*size(Scores,1));
	 for i=1:size(Scores,1)*2
		 Page = 1+floor((i-1)/size(Scores,1));
		 Col = mod(i-1,size(Scores,1))+1;
		 Row = Scores(:,Col,Page);
		 [Sorted,Matches] = sort(Scores(:,Col,Page));
		 MinRanks(i)=find(Matches==Col,1);
	 end
	 %we now have a list of all the ranks
	 MinRanks = sort(MinRanks);
	 RankRates = ones(size(Scores,1));
	 for i=1:max(MinRanks)-1
	     RankRates(i) = find(MinRanks>i,1)/size(MinRanks,1);
	 end
end

