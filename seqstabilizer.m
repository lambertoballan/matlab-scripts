function [tproc] = seqstabilizer(imdir, fs, outdir)
% Input: a directory contining a sequence of images (opt: id num. of the reference image)
% Output: a directory of aligned images (w.r.t. the reference image)
% 
% The alignment between each pair of images is done using Piotr Dollar's toolbox:
% http://vision.ucsd.edu/~pdollar/toolbox/ (tested version 3.40)

tproc = 0;

if ~exist('fs','var')
    fs = 1;
end

if ~exist('outdir','var')
    outdir = strcat(imdir,'-a');
end

if ~exist(outdir,'dir')
    mkdir(outdir);
end

% list image names
imageNames = dir(fullfile(imdir,'*.jpg'));
imageNames = {imageNames.name}';

% reference image (first or select ref frame)
old_img = imread(fullfile(imdir,imageNames{fs}));
Iref = double(rgb2gray(old_img))/255;

%for ii = 1:length(imageNames)
parfor ii = 1:length(imageNames)
   
    if (ii~=fs)   
        % current image 
        ts = tic;  
        curr_img = imread(fullfile(imdir,imageNames{ii}));
        I = double(rgb2gray(curr_img))/255;
   
        % align images    
        prmAlign = {'outThr',.1,'resample',.1,'type',1:8,'show'};
        [H,Ip] = imagesAlign(I,Iref,prmAlign{:},0);
        
        % do not break the ids list
        if ii<fs
            filename = [sprintf('%08d',ii) '.jpg'];
        else
            filename = [sprintf('%08d',ii-1) '.jpg'];
        end
        
        % color output
        Ip = imtransform2(curr_img, H);
    
        % write file
        imwrite(Ip,fullfile(outdir,filename));   
        fprintf('Frame %d of %d (%1.2f s)\n', ii, length(imageNames), toc(ts));
        tproc = tproc + toc(ts);
    end
end

end