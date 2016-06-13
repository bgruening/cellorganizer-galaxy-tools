#!/usr/bin/env bash

export PATH=$PATH:$(dirname $0)
CELLORGANIZER=/pylon1/mc4s8dp/icaoberg/galaxy/cellorganizer

WORKING_DIRECTORY=`pwd`

MATLAB=/opt/packages/matlab/R2016a/bin/matlab

SEED=$1
COMPRESSION=$2

echo "
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT MODIFY THIS BLOCK
answer = false;
current_path = which(mfilename);
[current_path, filename, extension] = fileparts( current_path );
cd(current_path);

options.seed = 100;
try
    state = rng( options.seed );
catch err
    state = rand( 'seed', options.seed ); %#ok<RAND>
end

options.targetDirectory = pwd;
options.numberOfSynthesizedImages = 1;
options.prefix = 'synthesizedImages';
options.numberOfSynthesizedImages = 1;
options.image.compression = 'lzw';
options.microscope = 'none';
options.sampling.method = 'disc';
options.verbose = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEEL FREE TO MODIFY THE VARIABLES IN THIS BLOCK
list_of_models = {'../../../models/3D/lamp2.mat'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist( [pwd filesep 'synthesizedImages/cell1/cell.tif'], 'file' )
    answer = slml2img( list_of_models, options );
else
    disp('Image exists on disk. Skipping synthesis.');
end

disp('Loading image to workspace');
img = tif2img( [pwd filesep 'synthesizedImages/cell1/cell.tif'] );

disp('Making projection');
img = im2projection( img );

disp('Saving projection');
imwrite( img, 'projection.png' );

exit;" > script.m

echo "Running the following script in Matlab"
cat script.m

echo $WORKING_DIRECTORY
ln -s $CELLORGANIZER $(pwd)/cellorganizer
$MATLAB -nodesktop -nosplash -r "script;"

echo "Compressing results"
zip -rv examples.zip examples
rm -rfv examples
