%//
ldr_folder_path = 'src_img\ldr_img\';
ldr_size = 512;
ldr_files = dir(ldr_folder_path);
[length, d] = size(ldr_files);
count = 0;
for i = 1 : length
    file_name = ldr_files(i).name;
    if file_name(1) == "."
        continue;
    end
    file_path = [ldr_folder_path '' file_name];
    count = count + 1;
    
    ldr = im2double(imread(file_path));
    ldr = imresize(ldr, [ldr_size, ldr_size], 'bilinear');
    ldrs(:, :, :, count) = ldr;
    
    info = imfinfo(file_path);
    info_dc = info.DigitalCamera;
    exposures(count) = info_dc.ExposureTime;
end


hdr_naive = makehdr_naive(ldrs, exposures);
hdr_naive_tonemapped = tonemap(hdr_naive);
figure(666), imshow(hdr_naive_tonemapped), title('Naive HDR');

hdr_naive_weighted = makehdr_naive_weighted(ldrs, exposures);
hdr_naive_weighted_tonemapped = tonemap(hdr_naive_weighted);
figure(667), imshow(hdr_naive_weighted_tonemapped), title('Weighted Naive HDR');

% disp(sqrt(sum((hdr_naive_wuo_tonemapped(:) - hdr_naive_tonemapped(:)) .^ 2)));
