function [patch] = choose_sample(sample, im_cost, tol, patchsize)
    small_cost_value = 1;
    minc = min(min(im_cost));
    minc = max(minc, small_cost_value);
    [y, x] = find(im_cost < minc * (1 + tol));
    random_index = randi(length(y));
    random_y = y(random_index);
    random_x = x(random_index);
    patch = sample(random_y : random_y + patchsize - 1, random_x : random_x + patchsize - 1, :);
end