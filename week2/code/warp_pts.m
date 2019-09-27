function [ warped_pts ] = warp_pts( video_pts, logo_pts, sample_pts)
% warp_pts computes the homography that warps the points inside
% video_pts to those inside logo_pts. It then uses this
% homography to warp the points in sample_pts to points in the logo
% image
% Inputs:
%     video_pts: a 4x2 matrix of (x,y) coordinates of corners in the
%         video frame
%     logo_pts: a 4x2 matrix of (x,y) coordinates of corners in
%         the logo image
%     sample_pts: a nx2 matrix of (x,y) coordinates of points in the video
%         video that need to be warped to corresponding points in the
%         logo image
% Outputs:
%     warped_pts: a nx2 matrix of (x,y) coordinates of points obtained
%         after warping the sample_pts
% Written for the University of Pennsylvania's Robotics:Perception course

% Complete est_homography first!
[ H ] = est_homography(video_pts, logo_pts);

% intialize result matrix
warped_pts = sample_pts.*0;
num_points = size(sample_pts)(1);
for ii_point = 1:num_points
  src_xy = sample_pts(ii_point,:);
  src = [src_xy(1); src_xy(2); 1];
  dst = H * src;
  dst_xy = [dst(1)/dst(3), dst(2)/dst(3)];
  warped_pts(ii_point,:) = dst_xy;
end

