ShapeCount=50;
VertexCount=2;
Samples=20;

Database = cell(Samples,1);
disp('enrolling');
for i = 1:Samples
    path = strcat('FingerprintMinutia/',int2str(i),'_1.txt');
    Database{i,1}=brokenEnroll(load(path),ShapeCount,VertexCount);
    disp(floor(i*100/Samples))
end

Score = zeros(50,50);
for i = 1:Samples
    for j = 1:Samples
	path = strcat('FingerprintMinutia/',int2str(i),'_2.txt');
	Subject = load(path);
	Score(i,j) = brokenScore(Subject, Database{i,1}, 12)/double(size(Subject,1));
    end
    floor(i*100/Samples)
end

Score
