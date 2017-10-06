function [im_out] = quilt_simple(sample, outsize, patchsize, overlap, tol)

    sample = im2double(sample);
    
    [input_height, input_width, num_channels] = size(sample);
    output_height = outsize(1);
    output_width = outsize(2);
    
    non_overlap = patchsize - overlap;
    half_size = floor(patchsize / 2);
    y_range = [half_size + 1, input_height - half_size];
    x_range = [half_size + 1, input_width - half_size];
    
    im_out = zeros(output_height, output_width, num_channels);
    
    im_out(1 : patchsize, 1 :patchsize, :) = find_random_patch(sample, patchsize, x_range, y_range);
    
    mask = zeros(patchsize, patchsize, num_channels);
    mask(1 : overlap, :, :) = 1;
    
    for i = non_overlap : non_overlap : output_height - patchsize
        template = im_out(i : i + patchsize - 1, 1 : 1 + patchsize - 1, :);
        im_cost = ssd_patch(sample, mask, template, x_range, y_range);
        patch = choose_sample(sample, im_cost, tol, patchsize);
        im_out(i : i + patchsize - 1, 1 : 1 + patchsize - 1, :) = patch;
    end
    
    mask = zeros(patchsize, patchsize, num_channels);
    mask(:, 1 : overlap, :) = 1;
    
    for j = non_overlap : non_overlap : output_width - patchsize
        template = im_out(1 : 1 + patchsize - 1, j : j + patchsize - 1, :);
        im_cost = ssd_patch(sample, mask, template, x_range, y_range);
        patch = choose_sample(sample, im_cost, tol, patchsize);
        im_out(1 : 1 + patchsize - 1, j : j + patchsize - 1, :) = patch;
    end
    
    mask = zeros(patchsize, patchsize, num_channels);
    mask(1 : overlap, :, :) = 1;
    mask(:, 1 : overlap, :) = 1;
    
    for i = non_overlap : non_overlap : output_height - patchsize
        for j = non_overlap : non_overlap : output_width - patchsize
            template = im_out(i : i + patchsize - 1, j : j + patchsize - 1, :);
            im_cost = ssd_patch(sample, mask, template, x_range, y_range);
            patch = choose_sample(sample, im_cost, tol, patchsize);
            im_out(i : i + patchsize - 1, j : j + patchsize - 1, :) = patch;
        end
    end
    
    
end