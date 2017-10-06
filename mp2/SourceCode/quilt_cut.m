function [im_out] = quilt_cut(sample, outsize, patchsize, overlap, tol)

    sample = im2single(sample);
    
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
        
        horizontal_original = template(1 : overlap, 1 : patchsize, :);
        horizontal_overlap = patch(1 : overlap, 1 : patchsize, :);
        horizontal_errpath = sum((horizontal_overlap - horizontal_original) .^ 2, 3);
        horizontal_seam_mask = cut(horizontal_errpath);
        
        horizontal_mask = ones(patchsize, patchsize);
        horizontal_mask(1 : overlap, :) = horizontal_seam_mask;
        
        patch(:, :, 1) = horizontal_mask .* patch(:, :, 1) + (~horizontal_mask) .* template(:, :, 1);
        patch(:, :, 2) = horizontal_mask .* patch(:, :, 2) + (~horizontal_mask) .* template(:, :, 2);
        patch(:, :, 3) = horizontal_mask .* patch(:, :, 3) + (~horizontal_mask) .* template(:, :, 3);
        
        im_out(i : i + patchsize - 1, 1 : 1 + patchsize - 1, :) = patch;
    end
    
    mask = zeros(patchsize, patchsize, num_channels);
    mask(:, 1 : overlap, :) = 1;
    
%     figure();
    
    for j = non_overlap : non_overlap : output_width - patchsize
        
        template = im_out(1 : 1 + patchsize - 1, j : j + patchsize - 1, :);
        im_cost = ssd_patch(sample, mask, template, x_range, y_range);
        patch = choose_sample(sample, im_cost, tol, patchsize);
        
        vertical_original = template(1 : patchsize, 1 : overlap, :);
        vertical_overlap = patch(1 : patchsize, 1 : overlap, :);
        vertical_errpath = transpose(sum((vertical_overlap - vertical_original) .^ 2, 3));
        vertical_seam_mask = transpose(cut(vertical_errpath));
        
        vertical_mask = ones(patchsize, patchsize);
        vertical_mask(:, 1 :overlap) = vertical_seam_mask;
        
%         subplot(1, 3, 1);
%         imshow(vertical_original);
%         subplot(1, 3, 2);
%         imshow(vertical_overlap);
%         subplot(1, 3, 3);
%         imagesc(vertical_mask);
%         suptitle('Minimum-cut Mask');
        
        
        patch(:, :, 1) = vertical_mask .* patch(:, :, 1) + (~vertical_mask) .* template(:, :, 1);
        patch(:, :, 2) = vertical_mask .* patch(:, :, 2) + (~vertical_mask) .* template(:, :, 2);
        patch(:, :, 3) = vertical_mask .* patch(:, :, 3) + (~vertical_mask) .* template(:, :, 3);
        
        im_out(1 : 1 + patchsize - 1, j : j + patchsize - 1, :) = patch;
    end
    
    figure();
    
    mask = zeros(patchsize, patchsize, num_channels);
    mask(1 : overlap, :, :) = 1;
    mask(:, 1 : overlap, :) = 1;
    
    for i = non_overlap : non_overlap : output_height - patchsize
        for j = non_overlap : non_overlap : output_width - patchsize
            
            template = im_out(i : i + patchsize - 1, j : j + patchsize - 1, :);
            im_cost = ssd_patch(sample, mask, template, x_range, y_range);
            imagesc(im_cost);
            title('SSD Cost Image');
            patch = choose_sample(sample, im_cost, tol, patchsize);
            
            horizontal_original = template(1 : overlap, 1 : patchsize, :);
            horizontal_overlap = patch(1 : overlap, 1 : patchsize, :);
            horizontal_errpath = sum((horizontal_overlap - horizontal_original) .^ 2, 3);
            horizontal_seam_mask = cut(horizontal_errpath);

            horizontal_mask = ones(patchsize, patchsize);
            horizontal_mask(1 : overlap, :) = horizontal_seam_mask;
            
            vertical_original = template(1 : patchsize, 1 : overlap, :);
            vertical_overlap = patch(1 : patchsize, 1 : overlap, :);
            vertical_errpath = transpose(sum((vertical_overlap - vertical_original) .^ 2, 3));
            vertical_seam_mask = transpose(cut(vertical_errpath));
            
            vertical_mask = ones(patchsize, patchsize);
            vertical_mask(:, 1 :overlap) = vertical_seam_mask;
            
            combined_mask = horizontal_mask & vertical_mask;
            
            
            patch(:, :, 1) = combined_mask .* patch(:, :, 1) + (~combined_mask) .* template(:, :, 1);
            patch(:, :, 2) = combined_mask .* patch(:, :, 2) + (~combined_mask) .* template(:, :, 2);
            patch(:, :, 3) = combined_mask .* patch(:, :, 3) + (~combined_mask) .* template(:, :, 3);
            
            
            im_out(i : i + patchsize - 1, j : j + patchsize - 1, :) = patch;
        end
    end
    
    
end