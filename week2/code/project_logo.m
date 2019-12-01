% project_logo.m is the test file for the University of
% Pennsylvania's Coursera course Robotics:Perception, week 2 assignment, to
% project a logo onto a given area in a target image
% Written for the University of Pennsylvania's Robotics:Perception course

% Note: You don't have to change this script for the assignment, but you
% can if you'd like to change the images or other parameters

% Load logo image. Replace with your image as desired.
logo_img = imread('images/logos/penn_engineering_logo.png');
% Generate logo points (they are just the outer corners of the image)
[logoy, logox, ~] = size(logo_img);
logo_pts = [0 0; logox 0; logox logoy; 0 logoy];

% Load the four points (x,y) of the goal corners of the video for all frames
load data/BarcaReal_pts.mat %video_pts in 4x2x129
num_ima = size(video_pts, 3);

% analyze video points
x = squeeze(video_pts(1,:,:));
disp(x')

% Set of images to test on
% To only test on images 1, 4 and 10, use the next line (you can edit
% it for your desired test images)
test_images = 1:num_ima;
%test_images = [1,129];
num_test = length(test_images);

% Initialize the images
video_imgs = cell(num_test, 1);
projected_imgs = cell(num_test, 1);

% Process all the images
for i=1:num_test
    msg = ['Calculating image ', num2str(i), '/', num2str(num_test)];
    disp(msg);
    %fflush(stdout);
    %fflush(stderr);
    
    % load 4 goal points in image
    idx_frame = test_images(i);
    video_pts_curr = video_pts(:,:,idx_frame);
      
    % Read the next video frame
    video_img = imread(sprintf('images/barcaReal/BarcaReal%03d.jpg', idx_frame));
    video_imgs{i} = video_img;
    
    % Find all points in the video frame inside the polygon defined by
    % video_pts
    [ interior_pts ] = calculate_interior_pts(size(video_img),...
        video_pts_curr);
    
    % Debug mode -> show image
    hold off
    imshow(video_img);
    hold on
    plot(video_pts_curr(:,1), video_pts_curr(:,2), 'rx', 'MarkerSize', 15)
    plot(interior_pts(:,1), interior_pts(:,2), 'g.', 'MarkerSize', 1)
    saveas(gcf,['img_debug/' num2str(i) '.png']);
    
    % Warp the interior_pts to coordinates in the logo image
    warped_logo_pts = warp_pts(video_pts_curr,...
        logo_pts,...
        interior_pts);
    
    
    % Copy the RGB values from the logo_img to the video frame
    projected_img = inverse_warping(video_img,...
        logo_img,...
        interior_pts,...
        warped_logo_pts); 
    projected_imgs{i} = projected_img;
end


% display images
%play_video(projected_imgs)

% save images
save_images(projected_imgs)