function [im_out] = mixedBlend(im_source, im_mask, im_background)
    [height, width, num_channels] = size(im_background);
    im_out = ~im_mask .* im_background;
    
    for channel = 1 : num_channels
        e = 0;
        A = sparse(height * width * 8, height * width);
        b = zeros(height * width, 1);
        im2var = zeros(height, width);
        im2var(1 : height * width) = 1 : height * width;
        for x = 1 : width
            for y = 1 : height
                if im_mask(y, x) ~= 0
                    if(y < height)
                        d = im_source(y, x, channel) - im_source(y + 1, x, channel);
                        t_grad = im_background(y, x, channel) - im_background(y + 1, x, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y + 1, x) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y + 1, x)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y + 1, x, channel);
                        end
                    end
                    if(x < width)
                        d = im_source(y, x, channel) - im_source(y, x + 1, channel);
                        t_grad = im_background(y, x, channel) - im_background(y, x + 1, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y, x + 1) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y, x + 1)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y, x + 1, channel);
                        end
                    end
                    if(y > 1)
                        d = im_source(y, x, channel) - im_source(y - 1, x, channel);
                        t_grad = im_background(y, x, channel) - im_background(y - 1, x, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y - 1, x) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y - 1, x)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y - 1, x, channel);
                        end
                    end
                    if(x > 1)
                        d = im_source(y, x, channel) - im_source(y, x - 1, channel);
                        t_grad = im_background(y, x, channel) - im_background(y, x - 1, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y, x - 1) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y, x - 1)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y, x - 1, channel);
                        end
                    end
                    if(x > 1 && y > 1)
                        d = im_source(y, x, channel) - im_source(y - 1, x - 1, channel);
                        t_grad = im_background(y, x, channel) - im_background(y - 1, x - 1, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y - 1, x - 1) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y - 1, x - 1)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y - 1, x - 1, channel);
                        end
                    end
                    if(x > 1 && y < height)
                        d = im_source(y, x, channel) - im_source(y + 1, x - 1, channel);
                        t_grad = im_background(y, x, channel) - im_background(y + 1, x - 1, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y + 1, x - 1) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y + 1, x - 1)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y + 1, x - 1, channel);
                        end
                    end
                    if(x < width && y > 1)
                        d = im_source(y, x, channel) - im_source(y - 1, x + 1, channel);
                        t_grad = im_background(y, x, channel) - im_background(y - 1, x + 1, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y - 1, x + 1) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y - 1, x + 1)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y - 1, x + 1, channel);
                        end
                    end
                    if(x < width && y < height)
                        d = im_source(y, x, channel) - im_source(y + 1, x + 1, channel);
                        t_grad = im_background(y, x, channel) - im_background(y + 1, x + 1, channel);
                        if abs(t_grad) > abs(d)
                            d = t_grad;
                        end
                        if(im_mask(y + 1, x + 1) ~= 0)
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            A(e, im2var(y + 1, x + 1)) = -1;
                            b(e) = d;
                        else
                            e = e + 1;
                            A(e, im2var(y, x)) = 1;
                            b(e) = d + im_background(y + 1, x + 1, channel);
                        end
                    end
                end
            end
        end
        
        A = A(1 : e, :);
        b = b(1 : e);
        v = A \ b;
        
        for x = 1 : width
            for y = 1 : height
                if im_mask(y, x) ~= 0
                    im_out(y, x, channel) = v(im2var(y, x));
                end
            end
        end
        
    end
end