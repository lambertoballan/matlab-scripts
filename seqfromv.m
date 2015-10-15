function [tproc] = seqfromv(vname, outdir, maxf)
% e.g. seqfromv('example.mov','frames')
%
% same functionality can be obtained with ffmpeg:
% ffmpeg -i example.mov -an -f image2 "frames/%08d.jpg"

v = VideoReader(vname);
nframes = v.NumberOfFrames;

if ~exist('outdir','var')
    [~,outdir,~] = fileparts(vname);
    outdir = strcat(outdir,'_seq');
end

if ~exist(outdir,'dir')
    mkdir(outdir);
end

if ~exist('maxf','var')
    maxf = nframes;
end

ts = tic;
%for j=1:maxf
parfor j=1:maxf
    
    curr_frame = read(v,j);    
    filename = [sprintf('%08d',j) '.jpg'];
    imwrite(curr_frame,fullfile(outdir,filename));    
    fprintf('Frame %d of %d\n', j, maxf);
end
tproc = toc(ts);

end