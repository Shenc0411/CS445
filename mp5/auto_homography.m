function H=auto_homography(Ia,Ib)
% Computes a homography that maps points from Ia to Ib
%
% Input: Ia and Ib are images
% Output: H is the homography
%
% Note: to use H in maketform, use maketform('projective', H')

% Computes correspondences and matches
[fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;
matches = vl_ubcmatch(da,db) ;

numMatches = size(matches,2) ;

% Xa and Xb are 3xN matrices that contain homogeneous coordinates for the N
% matching points for each image
Xa = fa(1:2,matches(1,:)) ; Xa(3,:) = 1 ;
Xb = fb(1:2,matches(2,:)) ; Xb(3,:) = 1 ;


%% RANSAC

niter = 1000;
best_score = 0;

for t = 1:niter
    % estimate homograpyh
    subset = vl_colsubset(1:numMatches, 4) ;
    pts1 = Xa(:, subset);
    pts2 = Xb(:, subset);
    H_t = computeHomography(pts1, pts2); % edit helper code below
    
    % score homography
    Xb_ = H_t * Xa ; % project points from first image to second using H
    du = Xb_(1,:)./Xb_(3,:) - Xb(1,:)./Xb(3,:) ;
    dv = Xb_(2,:)./Xb_(3,:) - Xb(2,:)./Xb(3,:) ;
    ok_t = sqrt(du.*du + dv.*dv) < 1;  % you may need to play with this threshold
    score_t = sum(ok_t) ;
    
    if score_t > best_score
        best_score = score_t;
        H = H_t;
    end
end

disp(num2str(best_score))

% Optionally, you may want to re-estimate H based on inliers


%%
function H = computeHomography(pts1, pts2)
% Compute homography that maps from pts1 to pts2 using least squares solver
% 
% Input: pts1 and pts2 are 3xN matrices for N points in homogeneous
% coordinates. 
%
% Output: H is a 3x3 matrix, such that pts2~=H*pts1