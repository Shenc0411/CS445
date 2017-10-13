function [im_out] = poissonBlend(im_source, im_mask, im_background)
    [height, width, num_channels] = size(im_background);
    im_out = ~im_mask .* im_background;
    for channel = 1 : num_channels
        e = 0;
        A = sparse(height * width, height * width);
        b = zeros(height * width, 1);
        im2var = zeros(height, width);
        im2var(1 : height * width) = 1 : height * width;
        for x = 1 : width
            for y = 1 : height
                if im_mask(y, x, channel) == 0
                    e = e + 1;
                end
            end
        end
        A = A(1 : e, :);
        b = b(1 : e);
    end
end