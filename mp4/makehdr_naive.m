function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
    [height, width, channels, length] = size(ldrs);
    hdr = zeros(height, width, channels);
    %Create naive HDR here
    for i = 1 : length
        hdr = hdr + ldrs(:, :, :, i) ./ exposures(i);
    end
    hdr = hdr ./ length;
    
end
