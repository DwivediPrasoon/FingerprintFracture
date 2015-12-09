function [frr,far] = getRates(genuines,imposters,threshold)
	found = find(sort(genuines)>threshold);
	if size(found)(1)>0
		 frr=1-found(1)/size(genuines)(1);
	else
		frr=0;
	end 
	found = find(sort(impostors)>threshold);
	if size(found)(1)>0
		far=found(1)/size(impostors)(1);
	else
		frr=0;
	end
end
