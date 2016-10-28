function []=export_to_cmpmvs(pose_all, path_all, K, output_folder)


if~exist('output_folder', 'var')
    fmain='C:\cmpmvs\canon.nvm.cmp\00\';
else
    fmain=output_folder;
end;


im=imread(path_all(1).path);
[row, col, h]=size(im);
s=0.5;%min(0.5*res/dim_min,1);
strcat('dirName=',fmain)

G=char('[global]', ...
strcat('dirName=',fmain, 'data/'),...    %'dirName="C:\\cmpmvs\\canon.nvm.cmp\\00\\data\\"',...
'prefix=""',...
'imgExt="jpg"',...
strcat('ncams=', num2str(size(pose_all,3))),...
strcat('width=', num2str(col)),...
strcat('height=', num2str(row)),...
strcat('scale=', num2str(1/s)),...
'workDirName="_tmp"',...
'doPrepareData=TRUE',...
'doPrematchSifts=TRUE',...
'doPlaneSweepingSGM=TRUE',...
'doFuse=TRUE',...
'nTimesSimplify=10',...
'\n',...
'[uvatlas]',...
'texSide=4096',...
'scale=1',...
'\n',...
'[prematching]',...
'minAngle=3.0',...
'\n',...
'[grow]',...
'minNumOfConsistentCams=6',...
'\n',...
'[filter]',...
'minNumOfConsistentCams=2',...
'\n',...
'[hallucinationsFiltering]',...
'useSkyPrior=FALSE',...
'doLeaveLargestFullSegmentOnly=FALSE',...
'doRemoveHugeTriangles=TRUE',...
'\n',...
'[largeScale]',...
'doGenerateAndReconstructSpaceMaxPts=TRUE',...
'doGenerateSpace=TRUE',...
'planMaxPts=3000000',...
'\n',...
'[generateVideoFrames]',...
'nintermed=20',...
'\n',...
'[DEM]',...
'demW=8000',...
'demH=8000',...
'\n',...
'#EOF',...
'\n');




T_big=[     1     0     0     0
     0    -1     0     0
     0     0    -1     0
     0     0     0     1];





for i=1:size(pose_all,3)
    im=imread(path_all(i).path);
    imwrite(im, strcat(fmain, 'data\' ,num2str(i, '%0.5d'), '.jpg'));
    
end;


 

fp=fopen(strcat(fmain, 'list.txt'), 'W');

for i=1:size(pose_all,3)
    fprintf(fp, 'visualize\\');
    fprintf(fp, num2str(i, '%0.5d'));
    fprintf(fp, '.jpg');
    fprintf(fp, '\n');

end;
fclose all;



for i=1:size(pose_all,3)
    fp=fopen(strcat(fmain, 'data\', num2str(i, '%0.5d'), '_P.txt'), 'W');

    P=K*pose_all(:,:,i)*T_big;
    for k=1:3
        fprintf(fp, ' %.8f %.8f %.8f %.8f\n', P(k,:));
    end;
    fclose(fp);
    

end;

fp=fopen(strcat(fmain, 'mvs', '.ini'), 'W');

for i=1:size(G,1)
    fprintf(fp, G(i,:));  
    fprintf(fp, '\n');    

end;
fclose(fp);
