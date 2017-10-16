function [im_out] = color2gray(im_source)
    im_gray = im2double(rgb2gray(im_source));
    [height, width] = size(im_gray);
    im_out = zeros(height, width);
    
    im2var = zeros(height, width);
    im2var(1 : height * width) = 1 : height * width;
    A_j = zeros(height * width * 20, 1);
    A_i = zeros(height * width * 20, 1);
    A_v = zeros(height * width * 20, 1);
    b = zeros(height * width * 9, 1);
    e = 0;
    c = 0;
    
    for x = 1 : width
        for y = 1 : height
            e = e + 1;
            c = c + 1;
            A_j(c) = e;
            A_i(c) = im2var(y, x);
            A_v(c) = 1;
            b(e) = im_gray(y, x);
            if(y < height)
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
                for channel = 1 : 3
                    b(e) = b(e) + im_source(y, x, channel) - im_source(y + 1, x, channel);
                end
                b(e) = b(e) / 3;
            end
            if(x < width)
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
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y, x + 1, channel);
                end
                b(e) = b(e) / 3;
            end
            if(y > 1)
                e = e + 1;
                %A(e, im2var(y, x)) = 1;
                c = c + 1;
                A_j(c) = e;
                A_i(c) = im2var(y, x);
                A_v(c) = 1;
                %A(e, im2var(y - 1, x)) = -1;
                c = c + 1;
                A_j(c) = e;
                A_i(c) = im2var(y, x);
                A_v(c) = -1;
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y - 1, x, channel);
                end
                b(e) = b(e) / 3;
            end
            if(x > 1)
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
                A_v(c) = 1;
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y, x - 1, channel);
                end
                b(e) = b(e) / 3;
            end
            if(x > 1 && y > 1)
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
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y - 1, x - 1, channel);
                end
                b(e) = b(e) / 3;
            end
            if(x > 1 && y < height)
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
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y + 1, x - 1, channel);
                end
                b(e) = b(e) / 3;
            end
            if(x < width && y > 1)
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
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y - 1, x + 1, channel);
                end
                b(e) = b(e) / 3;
            end
            if(x < width && y < height)
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
                for channel = 1 : 3
                    b(e) = im_source(y, x, channel) - im_source(y + 1, x + 1, channel);
                end
                b(e) = b(e) / 3;
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
            im_out(y, x) = v(im2var(y, x));
        end
    end
    
end