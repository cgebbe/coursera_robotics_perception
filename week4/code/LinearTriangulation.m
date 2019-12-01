function X = LinearTriangulation(K, C1, R1, C2, R2, x1, x2)
%% LinearTriangulation
% Find 3D positions of the point correspondences using the relative
% position of one camera from another
% Inputs:
%     C1 - size (3 x 1) translation of the first camera pose
%     R1 - size (3 x 3) rotation of the first camera pose
%     C2 - size (3 x 1) translation of the second camera
%     R2 - size (3 x 3) rotation of the second camera pose
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Outputs: 
%     X - size (N x 3) matrix whos rows represent the 3D triangulated
%       points

% Calculate projection matrices
t1 = -R1*C1;
t2 = -R2*C2;
P1 = K*[R1 t1];
P2 = K*[R2 t2];

% determine 3D points using triangulation
num_points = size(x1, 1);
X = zeros(num_points, 3);
for i=1:num_points
    
    % construct A
    x1_hom = [x1(i,1) x1(i,2) 1];
    x2_hom = [x2(i,1) x2(i,2) 1];
    x1_cross =  Vec2Skew(x1_hom);
    x2_cross =  Vec2Skew(x2_hom);
    A = [x1_cross*P1; x2_cross*P2];
    
    % solve for x = lambda * [X Y Z 1]
    [U,S,V] = svd(A);
    x = V(:, end);
    X(i,:) = x(1:3) / x(4);
end