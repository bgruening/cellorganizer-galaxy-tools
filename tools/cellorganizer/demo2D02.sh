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

options.seed = 12345;
try
 state = rng( options.seed );
catch err
 state = rand( 'seed', options.seed ); %#ok<RAND>
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%modify the next line to generate more images
options.numberOfSynthesizedImages = 1;

options.targetDirectory = pwd;
options.prefix = 'img';
options.compression = 'lzw';
options.debug = false;
options.verbose = true;
options.display = false;

filename = '../demo2D01/lamp2.mat';
if ~exist( filename )
    error( [ 'File ' filename ' not found. Please run demo2D01 first.' ] )
else
    tic
    slml2img( {filename}, options );
    toc
end

exit;" > script.m

ln -s $CELLORGANIZER $(pwd)/cellorganizer
$MATLAB -nodesktop -nosplash -r "script;"
