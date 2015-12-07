ShapeCount=24;
VertexCount=3;

Database = cell(5,1);
for i = 1:5
	path = strcat('MidtermFiles/0',int2str(i),'01.txt');
	Database{i,1}=brokenEnroll(load(path),ShapeCount,VertexCount,i);
end

