%//
ldr1 = im2double(imread('src_img/dark.jpg'));
ldr2 = im2double(imread('src_img/normal.jpg'));
ldr3 = im2double(imread('src_img/bright.jpg'));

ldr1 = imresize(ldr1, [512, 512], 'bilinear');
ldr2 = imresize(ldr2, [512, 512], 'bilinear');
ldr3 = imresize(ldr3, [512, 512], 'bilinear');

%Naive LDR merging
info_ldr1 = imfinfo('src_img/dark.jpg');
info_ldr1_dc = info_ldr1.DigitalCamera;
info_ldr2 = imfinfo('src_img/normal.jpg');
info_ldr2_dc = info_ldr2.DigitalCamera;
info_ldr3 = imfinfo('src_img/bright.jpg');
info_ldr3_dc = info_ldr3.DigitalCamera;

ldrs = cat(4, ldr1, ldr2, ldr3);
exp = [info_ldr1_dc.ExposureTime, info_ldr2_dc.ExposureTime, info_ldr3_dc.ExposureTime];

hdr_naive = makehdr_naive(ldrs, exp);
figure(666), imshow(tonemap(hdr_naive));

hdr_naive_wuo = makehdr_naive_wuo(ldrs, exp);
figure(667), imshow(tonemap(hdr_naive_wuo));

sum(hdr_naive_wuo(:) - hdr_naive(:))
