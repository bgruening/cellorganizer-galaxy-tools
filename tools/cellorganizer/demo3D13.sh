#!/usr/bin/env bash

export PATH=$PATH:$(dirname $0)
CELLORGANIZER=/pylon1/mc4s8dp/icaoberg/galaxy/cellorganizer

WORKING_DIRECTORY=`pwd`

MATLAB=/opt/packages/matlab/R2016a/bin/matlab

DOWNSAMPLE_FACTOR=$1

echo "
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT MODIFY THIS BLOCK
answer = false;
current_path = which(mfilename);
[current_path, filename, extension] = fileparts( current_path );
cd(current_path);

options.downsample = 5;
options.verbose = true;
options.debug = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEEL FREE TO MODIFY THE VARIABLES IN THIS BLOCK
synthesized_images_directory = '../demo3D01/synthesizedImages/cell1';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist( synthesized_images_directory )
    warning( 'Synthesized images directory does not exist' );
else
    output_folder = [ pwd filesep 'blender' ];
    if ~exist( output_folder )
        mkdir( output_folder );
    end
    
    answer = syn2blender( synthesized_images_directory, ...
        output_folder, options );
end

exit;" > script.m

echo "Running the following script in Matlab"
cat script.m

echo $WORKING_DIRECTORY
ln -s $CELLORGANIZER $(pwd)/cellorganizer
$MATLAB -nodesktop -nosplash -r "script;"

echo "Compressing results"
zip -rv examples.zip examples
rm -rfv examples
