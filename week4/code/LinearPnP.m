function [C, R] = LinearPnP(X, x, K)
%% LinearPnP
% Getting pose from 2D-3D correspondences
% Inputs:
%     X - size (N x 3) matrix of 3D points
%     x - size (N x 2) matrix of 2D points whose rows correspond with X
%     K - size (3 x 3) camera calibration (intrinsics) matrix
% Outputs:
%     C - size (3 x 1) pose transation
%     R - size (3 x 1) pose rotation
%
% IMPORTANT NOTE: While theoretically you can use the x directly when solving
% for the P = [R t] matrix then use the K matrix to correct the error, this is
% more numerically unstable, and thus it is better to calibrate the x values
% before the computation of P then extract R and t directly

% use K inverse at the beginning to avoid numerical issues
num_points = size(x,1);
x_hom = [x ones(num_points,1)];
x_hom_c = transpose(K \ transpose(x_hom));

% construct A
num_points = size(x,1);
A = zeros(3*num_points, 12);
for i=1:num_points
    % prepare vectors
    X_hom = [X(i,1) X(i,2) X(i,3) 1];
    Z = [0 0 0 0];
    
    % calc matrix
    x_cross = Vec2Skew(x_hom_c(i,:));
    X_eye = [X_hom Z Z; Z X_hom Z; Z Z X_hom];
    A(3*i-2:3*i, :) = x_cross * X_eye;
end

% solve for x = [p11 p12 p13 p14, p21 ... p34]
[U,S,V] = svd(A);
x = V(:,end);
% x = [11 12 13 14 21 22 23 24 31 32 33 34];
P_pre = transpose(reshape(x, 4, 3));

% cleanup R,t
R_pre = P_pre(:, 1:3);
t_pre = P_pre(:, 4);
[U,S,V] = svd(R_pre);
if det(U*transpose(V)) > 0
    R = U * transpose(V);
    t = t_pre / S(1,1);
else
    R = -U * transpose(V);
    t = -t_pre / S(1,1);
end

% calc C
C = -transpose(R)*t;




