ShapeCount=24;
VertexCount=3;

Database = cell(5,1);
for i = 1:5
    path = strcat('FingerprintFiles/0',int2str(i),'01.txt');
    Database{i,1}=brokenEnroll(load(path),ShapeCount,VertexCount);
end

Score = zeros(5,5);
for i = 1:5
    for j = 1:5
	path = strcat('FingerprintFiles/0',int2str(j),'02.txt');
	Subject = load(path);
	Score(i,j) = brokenScore(Subject, Database{i,1}, 12)/double(size(Subject,1));
    end
end

Score
