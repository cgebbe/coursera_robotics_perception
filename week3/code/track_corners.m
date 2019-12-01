function [ corners ] = track_corners(images, img_pts_init)
%TRACK_CORNERS 
% This function tracks the corners in the image sequence and visualizes a
% virtual box projected into the image
% Inputs:
%     images - size (N x 1) cell containing the sequence of images to track
%     img_pts_init - size (4 x 2) matrix containing points to initialize
%       the tracker
% Outputs:
%     corners - size (4 x 2 x N) array of where the corners are tracked to

% params
flag_save_as_png = 0;
flag_return_last_result = 1;  % requires computer vision toolbox!
num_images = size(images,1);
%num_images = min(num_images, 5);

% actual code
if flag_return_last_result == 1
    file_corners = matfile('corners.mat');
    corners = file_corners.corners;
else
    % from https://de.mathworks.com/help/vision/ref/vision.pointtracker-system-object.html
    corners = zeros(4,2,num_images);    
    corners(:,:,1) = img_pts_init;
    pointTracker = vision.PointTracker('NumPyramidLevels',3);
    initialize(pointTracker,corners(:,:,1),images{1});
    for i = 2:num_images
        fprintf(['Tracking points in image ' num2str(i) '\n'])
        [points, point_validity, scores] = pointTracker(images{i});
        corners(:,:,i) = points;
    end
    save('corners.mat','corners');
end


%%% VISUALIZATION
if flag_save_as_png == 1
    for i = 1:num_images
        hold off
        imshow(images{i});
        hold on 
        plot(corners(:,1,i), corners(:,2,i), 'rx', 'MarkerSize', 15)
        saveas(gcf,['tmp/' num2str(i) '.png']);
    end
end
    
end

