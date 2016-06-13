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

options.seed = 12345;
try
    state = rng( options.seed );
catch err
    state = rand( 'seed', options.seed ); %#ok<RAND>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    pattern = '../demo3D30/demo3DDiffeoSynth_uniform.m_img1';
    copyfile( pattern );
catch err
    warning('Unable to copy files. Exiting demo');
    getReport(err)
    return
end

folder = './demo3DDiffeoSynth_uniform.m_img1';
answer = answer && helper_function( folder );
end

function answer = helper_function( folder )
outputDirectory = pwd;
options = [];
options.targetDirectory = folder;
options.prefix = 'synthesizedImages';
options.numberOfSynthesizedImages = 1;
options.compression = 'lzw';
options.microscope = 'none';
options.sampling.method = 'disc';
options.verbose = true;
options.debug = true;
options.synthesis = 'all';

%make sure objects don't overlap.
options.rendAtStd = 1;
options.objstd = 1.1;
options.overlapsubsize = 1;
options.output.tifimages = 1;
%output the SBML-spatial files
options.output.SBML = 1;

options.model.resolution = [0.3920,0.3920,0.4000];
options.resolution.cell = [0.3920,0.3920,0.4000];
load( [ folder filesep 'temp' filesep 'image1.mat' ] );
options.instance.nucleus = img;
options.instance.resolution= [0.3920,0.3920,0.4000];
clear img

load( [ folder filesep 'temp' filesep 'image2.mat' ] );
options.instance.cell = img;
clear img

%trim image
img2d = squeeze(sum(options.instance.cell,3));
xrange = find(sum(img2d,1)>0);
yrange = find(sum(img2d,2)>0);
zrange = find(sum(sum(options.instance.cell,1),2));

options.instance.cell = options.instance.cell(min(yrange):max(yrange), ...
    min(xrange):max(xrange),min(zrange):max(zrange));
options.instance.nucleus = options.instance.nucleus(min(yrange):max(yrange), ...
    min(xrange):max(xrange),min(zrange):max(zrange));

answer = slml2img( {'../../../models/3D/tfr.mat'}, options );
end

exit;" > script.m

echo "Running the following script in Matlab"
cat script.m

ln -s $CELLORGANIZER $(pwd)/cellorganizer
$MATLAB -nodesktop -nosplash -r "script;"