Fingerprint0101=load('FingerprintFiles/0101.txt');
Fingerprint0102=load('FingerprintFiles/0102.txt');
Fingerprint0202=load('FingerprintFiles/0202.txt');
NumberOfShapes = 24;
NumberOfVertices = 2;
[MinutiaSets, StraightMinutiaSets] = brokenEnroll(Fingerprint0101,NumberOfShapes,NumberOfVertices,2);

figure('Name','Fingerprint Enrollment','Position', [0,0,1600,400]);
subplot(1,3,1);
plotMinutia(Fingerprint0101,'.k');
title('Minutiae');
%set(gca,'Color',[0 0 0]);

FS = ['*r';'sr';'dr';'+r';'*b';'sb';'db';'+b';'*g';'sg';'dg';'+g';'*m';'sm';'dm';'+m';'*c';'sc';'dc';'+c';'*y';'sy';'dy';'+y'];
subplot(1,3,2);
plotMinutia(Fingerprint0101,'.k');
hold on;
for i=1:size(StraightMinutiaSets,1)
    plotMinutia(StraightMinutiaSets{i},FS(i,:));
    hold on;
end
title('Pairs');
%set(gca,'Color',[0 0 0]);
hold off;

subplot(1,3,3);
for i=1:size(StraightMinutiaSets,1)
    plotMinutia(MinutiaSets{i},FS(i,:),[-512 512 -512 512]);
    hold on;
end
title('Zeroed Pairs');
%set(gca,'Color',[0 0 0]);
hold off;

figure('Name','Sanity','position', [0,0,500,400]);
Score = brokenScore(Fingerprint0101,MinutiaSets,1,1)

figure('Name','SampleMinutiaMatching','position', [0,0,800,400]);
subplot(1,2,1);
hold on;
Score = brokenScore(Fingerprint0102,MinutiaSets,1,1)
plotMinutia(Fingerprint0102,'.k');
title('Genuine');
hold off;

subplot(1,2,2);
hold on;
Score = brokenScore(Fingerprint0202,MinutiaSets,1,1)
plotMinutia(Fingerprint0202,'.k');
title('Imposter');
hold off;