function [im_out] = toy_reconstruct(im)
    [height, width, num_channels] = size(im);
    im_out = size(im);
    im2var = zeros(height, width);
    im2var(1 : height * width) = 1 : height * width;
    e = 0;
    
    %declare A as a spare matrix to improve time complexity
    A = sparse(height*width * 2 + 1, height*width);
    b = zeros(height*width * 2 + 1, 1);
    
    for x  = 1 : width
        for y = 1 : height
            %objective 1
            if(x ~= width)
                e = e + 1;
                A(e, im2var(y, x + 1)) = 1;
                A(e, im2var(y, x)) = -1;
                b(e) = im(y, x + 1) - im(y, x);
            end
            %objective 2
            if(y ~= height)
                e = e + 1;
                A(e, im2var(y + 1, x)) = 1;
                A(e, im2var(y, x)) = -1;
                b(e) = im(y + 1, x) - im(y, x);
            end
        end
    end
    %objective 3
    e = e + 1;
    A(e, 1) = 1;
    b(e) = im(1, 1);
    
    A = A(1 : e, :);
    b = b(1 : e);
    
    v = A \ b;
    
    for x = 1 : width
        for y = 1 : height
            im_out(y, x) = v(im2var(y, x));
        end
    end
end