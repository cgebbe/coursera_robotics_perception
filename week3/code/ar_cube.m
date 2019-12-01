function [proj_points, t, R] = ar_cube(H,render_points,K)
%% ar_cube
% Estimate your position and orientation with respect to a set of 4 points on the ground
% Inputs:
%    H - the computed homography from the corners in the image
%    render_points - size (N x 3) matrix of world points to project
%    K - size (3 x 3) calibration matrix for the camera
% Outputs: 
%    proj_points - size (N x 2) matrix of the projected points in pixel
%      coordinates
%    t - size (3 x 1) vector of the translation of the transformation
%    R - size (3 x 3) matrix of the rotation of the transformation
% Written by Stephen Phillips for the Coursera Robotics:Perception course

% YOUR CODE HERE: Extract the pose from the homography

% enforce H_33 > 0, as written in assignment
if H(3,3)<=0
    H = H.* (-1); 
end
t = H(:,3) / norm(H(:,1));

% construct R_primitive
R_primitive = zeros(3,3);
R_primitive(:,1) = H(:,1);
R_primitive(:,2) = H(:,2);
R_primitive(:,3) = cross(H(:,1),H(:,2));

% construct R with perpendicular directions
[U,S,V] = svd(R_primitive);
s_diag = [1,1,det(U*transpose(V))];
S_new = diag(s_diag);
R = U *S_new * transpose(V);
P = zeros(3,4);
P(1:3,1:3) = R;
P(:,4) = t;

% YOUR CODE HERE: Project the points using the pose
num_points = size(render_points,1);
proj_points  = ones(num_points,2);
for i=1:num_points
    X = ones(4,1);
    X(1:3,1) = render_points(i,:);
    x = K * P * X;
    x_uv = [x(1)/x(3), x(2)/x(3)];
    proj_points(i,:) = x_uv;
end

breakpoint_line = 0;

end
