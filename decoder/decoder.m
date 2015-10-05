%% decoder: function description
function [sucess , dists] = decoder(evenFrames, oddFrames, H,W,downsampleFactor,nEvenFrames,nOddFrames)
    evenFrames = read_yuv(evenFrames, W*downsampleFactor, H*downsampleFactor, [1:1:nEvenFrames]);
    evenFrames = sucess;

