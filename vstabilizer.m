function [nframes,tproc] = vstabilizer(vname, outdir, maxf)
% Input: a video (opt: stop computation after maxf frames)
% Output: a directory of aligned images (w.r.t. the first frame)
% 
% The alignment between each pair of images is done using Piotr Dollar's toolbox:
% http://vision.ucsd.edu/~pdollar/toolbox/ (tested version 3.40)

v = VideoReader(vname);
nframes = v.NumberOfFrames;
rate = 1;
tproc = 0;

if ~exist('outdir','var')
    [~,outdir,~] = fileparts(vname);   
end

if ~exist(outdir,'dir')
    mkdir(outdir);
end
    
if ~exist('maxf','var')
    maxf = nframes;
end    

% read first frame
old_frame = read(v,1);
old_grayscale = rgb2gray(old_frame);

fstart = 1 + rate;
%for j=fstart:rate:maxf
parfor j=fstart:maxf
    
    ts = tic;
    %f = readFrame(v);
    curr_frame = read(v,j);
    curr_grayscale = rgb2gray(curr_frame);
    
    % define greyscale images
    Iref = double(old_grayscale)/255;    
    I = double(curr_grayscale)/255;
    
    % update old_frame
    %old_grayscale = curr_grayscale;
    
    % align images    
    prmAlign = {'outThr',.1,'resample',.1,'type',1:8,'show'};
    [H,Ip] = imagesAlign(I,Iref,prmAlign{:},0);
    filename = [sprintf('%08d',j) '.jpg'];
    
    % color output
    Ip = imtransform2(curr_img, H);
   
    % write file
    imwrite(Ip,fullfile(outdir,filename));       
    fprintf('Frame %d of %d (%1.2f s)\n', j, maxf, toc(ts));
    tproc = tproc + toc(ts);
end

end