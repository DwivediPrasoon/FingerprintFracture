ShapeCount=24;
VertexCount=3;

Database = cell(5,2);
for i = 1:5
	path = strcat('MidtermFiles/0',int2str(i),'0',int2str(j),'.txt');
	Database{i,1}=brokenEnroll(load(path),ShapeCount,VertexCount);
end


for f1 = 1:5
	for f2 = 1:5
        
    end
end