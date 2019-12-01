function X = Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)
%% Nonlinear_Triangulation
% Refining the poses of the cameras to get a better estimate of the points
% 3D position
% Inputs: 
%     K - size (3 x 3) camera calibration (intrinsics) matrix
%     x
% Outputs: 
%     X - size (N x 3) matrix of refined point 3D locations 

num_points = size(x1,1);
X = zeros(num_points,3);
for i=1:num_points
    fprintf(['(' num2str(i) '/' num2str(num_points) ') - nonlinear triangulation \n'])
    X(i,:) = Single_Point_Nonlinear_Triangulation(...
        K, C1, R1, C2, R2, C3, R3, ...
        x1(i,:), x2(i,:), x3(i,:),...
        X0(i,:)...
        );
end

end


function X = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)
% init X and set 3x1 shape
X = X0';

num_steps = 10;
for i=1:num_steps
    % calc b and f_x
    b = [x1 x2 x3]';
    x1_proj_hom = K*R1*(X-C1);
    x2_proj_hom = K*R2*(X-C2);
    x3_proj_hom = K*R3*(X-C3);
    x1_proj = x1_proj_hom(1:2,:) / x1_proj_hom(3,:);
    x2_proj = x2_proj_hom(1:2,:) / x2_proj_hom(3,:);
    x3_proj = x3_proj_hom(1:2,:) / x3_proj_hom(3,:);
    f_x = [x1_proj' x2_proj' x3_proj']';

    % determine dX
    J = [Jacobian_Triangulation(C1, R1, K, X);
         Jacobian_Triangulation(C2, R2, K, X);
         Jacobian_Triangulation(C3, R3, K, X)];
    dX = inv(J'*J) * J' * (b-f_x);
    
    % step
    X = X + dX;
end

% convert back to 1x3 shape
X = X';

end



function J = Jacobian_Triangulation(C, R, K, X)

x_hom = K*R*(X-C); 
u = x_hom(1);
v = x_hom(2);
w = x_hom(3);
f = K(1);
p_x = K(1,3);
p_y = K(2,3);

d_u = [f*R(1,1)+p_x*R(3,1), f*R(1,2)+p_x*R(3,2), f*R(1,3)+p_x*R(3,3)];
d_v = [f*R(2,1)+p_y*R(3,1), f*R(2,2)+p_y*R(3,2), f*R(2,3)+p_y*R(3,3)];
d_w = R(3,:);

d_f1 = [(w*d_u-u*d_w)/w^2;
        (w*d_v-v*d_w)/w^2];
J = [d_f1']';
end

