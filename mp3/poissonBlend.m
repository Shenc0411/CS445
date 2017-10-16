function [im_out] = poissonBlend(im_source, im_mask, im_background)
    [height, width, num_channels] = size(im_background);
    im_out = ~im_mask .* im_background;
    
    for channel = 1 : num_channels
        e = 0;
        c = 0;
        A_j = zeros(height * width * 20, 1);
        A_i = zeros(height * width * 20, 1);
        A_v = zeros(height * width * 20, 1);
        b = zeros(height * width, 1);
        im2var = zeros(height, width);
        im2var(1 : height * width) = 1 : height * width;
        for x = 1 : width
            for y = 1 : height
                if im_mask(y, x) ~= 0
                    if(y < height)
                        if(im_mask(y + 1, x) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y + 1, x)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y + 1, x);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y + 1, x, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y + 1, x, channel) + im_background(y + 1, x, channel);
                        end
                    end
                    if(x < width)
                        if(im_mask(y, x + 1) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y, x + 1)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x + 1);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y, x + 1, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y, x + 1, channel) + im_background(y, x + 1, channel);
                        end
                    end
                    if(y > 1)
                        if(im_mask(y - 1, x) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y - 1, x)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y - 1, x);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y - 1, x, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y - 1, x, channel) + im_background(y - 1, x, channel);
                        end
                    end
                    if(x > 1)
                        if(im_mask(y, x - 1) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y, x - 1)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x - 1);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y, x - 1, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y, x - 1, channel) + im_background(y, x - 1, channel);
                        end
                    end
                    if(x > 1 && y > 1)
                        if(im_mask(y - 1, x - 1) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y - 1, x - 1)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y - 1, x - 1);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y - 1, x - 1, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y - 1, x - 1, channel) + im_background(y - 1, x - 1, channel);
                        end
                    end
                    if(x > 1 && y < height)
                        if(im_mask(y + 1, x - 1) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y + 1, x - 1)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y + 1, x - 1);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y + 1, x - 1, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y + 1, x - 1, channel) + im_background(y + 1, x - 1, channel);
                        end
                    end
                    if(x < width && y > 1)
                        if(im_mask(y - 1, x + 1) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y - 1, x + 1)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y - 1, x + 1);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y - 1, x + 1, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y - 1, x + 1, channel) + im_background(y - 1, x + 1, channel);
                        end
                    end
                    if(x < width && y < height)
                        if(im_mask(y + 1, x + 1) ~= 0)
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            %A(e, im2var(y + 1, x + 1)) = -1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y + 1, x + 1);
                            A_v(c) = -1;
                            b(e) = im_source(y, x, channel) - im_source(y + 1, x + 1, channel);
                        else
                            e = e + 1;
                            %A(e, im2var(y, x)) = 1;
                            c = c + 1;
                            A_j(c) = e;
                            A_i(c) = im2var(y, x);
                            A_v(c) = 1;
                            b(e) = im_source(y, x, channel) - im_source(y + 1, x + 1, channel) + im_background(y + 1, x + 1, channel);
                        end
                    end
                end
            end
        end
        
        A_j = A_j(1 : c);
        A_i = A_i(1 : c);
        A_v = A_v(1 : c);
        A = sparse(A_j, A_i, A_v);
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