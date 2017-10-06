function [im_out] = quilt_random(sample, outsize, patchsize)
    sample = im2single(sample);
    
    [input_height, input_width, num_channels] = size(sample);
    output_height = outsize(1);
    output_width = outsize(2);
    half_size = floor(patchsize / 2);
    y_range = [half_size + 1, input_height - patchsize];
    x_range = [half_size + 1, input_width - patchsize];
    
    im_out = zeros(output_height, output_width, num_channels);
    
    for i = 1 : patchsize : output_height - patchsize + 1
        for j = 1 : patchsize : output_width - patchsize + 1
            im_out(i : i + patchsize - 1, j : j + patchsize - 1, :) = find_random_patch(sample, patchsize, x_range, y_range);
        end
    end
    
    
end