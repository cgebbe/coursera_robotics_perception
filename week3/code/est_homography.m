function [ H ] = est_homography(video_pts, logo_pts)
% est_homography estimates the homography to transform each of the
% video_pts into the logo_pts
% Inputs:
%     video_pts: a 4x2 matrix of corner points in the video
%     logo_pts: a 4x2 matrix of logo points that correspond to video_pts
% Outputs:
%     H: a 3x3 homography matrix such that logo_pts ~ H*video_pts
% Written for the University of Pennsylvania's Robotics:Perception course



% === Compute A
[num_points, x]= size(video_pts);
A = zeros(2*num_points,9); % rows = 4x(a_x, a_y) ,cols = 9x h_ij

% Construct a_x and a_y for each point
for ii_point = 1 : num_points
  src = video_pts(ii_point,:);
  dst = logo_pts(ii_point,:);
  a_x = [-src(1), -src(2), -1, 0,0,0, src(1)*dst(1), src(2)*dst(1), dst(1)];
  a_y = [0, 0, 0, -src(1), - src(2), -1, src(1)*dst(2), src(2)*dst(2), dst(2)];
  A(ii_point*2-1,:) = a_x;
  A(ii_point*2,:) = a_y;
end


% === Compute h and H
[U,S,V] = svd(A);
h = V(:,9); % last column of V according to assignment code
H = reshape(h,[3,3]);
H = H'; % need to transpose, otherwise get matrix [11,21,31; ...] instead of [11,12,13; ...]

% === double check that homography is correct
logo_pts_check = logo_pts .* 0;
for ii_point = 1 : num_points
  src_xy = video_pts(ii_point,:);
  src = [src_xy(1); src_xy(2); 1];
  dst = H * src;
  dst_xy = [dst(1)/dst(3), dst(2)/dst(3)];
  logo_pts_check(ii_point,:) = dst_xy;
end

error = logo_pts - logo_pts_check;
disp(error)

line_for_breakpoint = 0;

end

