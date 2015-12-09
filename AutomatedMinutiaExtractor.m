for i = 1:100
    for j = 1:8
        input = strcat('FingerprintImages/',int2str(i),'_',int2str(j),'.tif');
        Minutiae = getMinutiae(input);
        output =  strcat('FingerprintMinutia/',int2str(i),'_',int2str(j),'.txt');
        save(output,'Minutiae','-ASCII');
    end
end