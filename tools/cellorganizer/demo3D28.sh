#!/usr/bin/env bash

export PATH=$PATH:$(dirname $0)
CELLORGANIZER=/pylon1/mc4s8dp/icaoberg/galaxy/cellorganizer

WORKING_DIRECTORY=`pwd`

MATLAB=/opt/packages/matlab/R2016a/bin/matlab

SEED=$1
COMPRESSION=$2
RESOLUTION1=$3
RESOLUTION2=$4
RESOLUTION3=$5

echo "
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT MODIFY THIS BLOCK
answer = true;
current_path = which(mfilename);
[current_path, filename, extension] = fileparts( current_path );
cd(current_path);

options.seed = 3;
try
    state = rng(options.seed);
catch
    state = RandStream.create('mt19937ar','seed',options.seed);
    RandStream.setDefaultStream(state);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEEL FREE TO MODIFY THE VARIABLES IN THIS BLOCK
%step0: set the input parameters described in the header
%step0.1 use existing raw or synthetic frameworks: in this demo we are going
%to use an image from the Murphy Lab 3D HeLa collection that you can download
%along with CellOrganizer.
filename = '../../../images/HeLa/3D/processed/LAM_cell10_ch0_t1.tif';
param.instance.nucleus = tif2img( filename );

%step0.2: set the resolution of the latter images
param.instance.resolution = [0.049, 0.049, 0.2000];

%step0.3: use a valid CellOrganizer model that contains a protein model. in
%this model we are going to use the 3D HeLa nucleoli model distributed in
%this version of CellOrganizer
model_file_path = '../../../models/3D/nuc.mat';

%these are optional parameters that you are welcome to modify as needed
%location where CellOrganizer will save the images to
param.targetDirectory = pwd;

%output folder name
param.prefix = 'synthesized_images';

%number of images to synthesize
param.numberOfSynthesizedImages = 1;

%save images as TIF files
param.output.tifimages = true;

%compression for TIF output
param.compression = 'lzw';

%do not apply point-spread-function
param.microscope = 'none';

%render Gaussian objects as discs
param.sampling.method = 'disc';

%only synthesize the framework, i.e. a nucleus and a cell
param.synthesis = 'all';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%main call to CellOrganizer
answer = slml2img( {model_file_path},  param );

exit;" > script.m

echo "Running the following script in Matlab"
cat script.m

echo $WORKING_DIRECTORY
ln -s $CELLORGANIZER $(pwd)/cellorganizer
$MATLAB -nodesktop -nosplash -r "script;"

echo "Compressing results"
zip -rv examples.zip examples
rm -rfv examples