function [im_out] = poissonBlend(im_source, im_mask, im_background)
    im_foregorund = im_mask .* im_source;
    
    im_out = im_background;
end