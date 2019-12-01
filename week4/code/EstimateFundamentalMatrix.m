function F = EstimateFundamentalMatrix(x1, x2)
%% EstimateFundamentalMatrix
% Estimate the fundamental matrix from two image point correspondences 
% Inputs:
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Output:
%    F - size (3 x 3) fundamental matrix with rank 2

num_points = size(x1,1);

% construct matrix A
A = zeros(num_points, 9);
for i=1:num_points
    u1 = x1(i,1);
    v1 = x1(i,2);
    u2 = x2(i,1);
    v2 = x2(i,2);
    %A(i,:) = [u2*u1 u2*v1 u2 v2*u1 v2*v1 v2 u1 v1 1];
    A(i,:) = [u1*u2 u1*v2 u1 v1*u2 v1*v2 v1 u2 v2 1];
end

% solve Ax = 0, where x=[f11 f12 f13 f21 f22 f23 f31 f32 f33]
[U,S,V] = svd(A);
x = V(:,end); % last column of V
% x = [11 12 13 21 22 23 31 32 33];
F_pre = transpose(reshape(x,3,3));

% ensure that rank(F)=2
[U,S,V] = svd(F_pre);
S_new = S;
S_new(3,3)=0;
F = U * S_new * transpose(V);

