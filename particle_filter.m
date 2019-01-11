clc;
clear;

isGrayscale = 1;    % O for rgb image. 1 for grayscale image

prev_frames = 15;     % Number of previous frames used to predict new position.
prev_probability = zeros(1, prev_frames);   % Store the probability for previous frames

N = 300;      % Number of particles generated

predict_x = 0;       % Object speed along x-axis
predict_y = 0;       % Object speed along y-axis
prev_frames = 5;     % Number of previous frames used to predict new position.

x_sigma = 10;    % Variance of particles' x-coordinate
y_sigma = 10;    % Variance of particles' y-coordinate

threshold = 0.5; % A probability threshold for skipping certain frame.

% Directory of input frames.
frames_dir = '/Users/jingxiaoma/Documents/MATLAB/test/';
first_frame = '0191.jpg';
% Directory to save results
result_dir = strcat(frames_dir, 'result/');

% Read first frames
first_frame_dir = strcat(frames_dir, first_frame);
im = imread(first_frame_dir);
imshow(im);

% Select area of target object
[~, rect] = imcrop(im);
% Get four vertices
x1 = rect(1); 
x2 = rect(1) + rect(3);
y1 = rect(2);
y2 = rect(2) + rect(4);
% Get coordinate of object centre
X = round((x1+x2) / 2);
Y = round((y1+y2) / 2);
% Half of length of edges
hx = round(rect(3) / 2);
hy = round(rect(4) / 2);

imsize = size(im);
image_X = int16(imsize(2));
image_Y = int16(imsize(1));

% Store first frames to results folder
cur_frame = getframe;
mkdir(result_dir);
output_dir = strcat(result_dir, '1.jpg');
imwrite(cur_frame.cdata, output_dir);

% Get list of frames and its length
input_frames_names = strcat(frames_dir, '/*.jpg'); 
input_frames = dir(input_frames_names);
num_frames = length(input_frames);

% Process first frame / Initialize target model
[Particle_set, Particle_probability, Frame_information, target_histogram, num_bins] = process_first_frame(X, Y, hx, hy, im, N, image_X, image_Y);

for loop = 2:num_frames
    % Read current frame
    frame_name = strcat(frames_dir, input_frames(loop).name);
    im = imread(frame_name);
    
    % Generate random particles based on previous distribution and movement
    [Particle_set, particle_im] = particle_reproduce(Particle_set, im, N, predict_x, predict_y, image_X, image_Y, x_sigma, y_sigma, isGrayscale);
    
    % Make prediction of position based on probability (weight)
    [Particle_probability, Frame_information, Particle_histogram] = evaluate_particles(Particle_set, Frame_information, target_histogram, loop, particle_im, im, N, image_X, image_Y, hx, hy, Particle_probability);
    
    % Get probability of last few frames
    if (loop <= prev_frames)
        mean_probability = sum(prev_probability) / loop;
    else
        mean_probability = mean(prev_probability);
    end
    
    % If probability is too low, then skip this frame
    if (Frame_information(loop).probability < threshold && loop > prev_frames)
        isSkipping = 1;
        Frame_information(loop).x = Frame_information(loop - 1).x + predict_x;
        Frame_information(loop).y = Frame_information(loop - 1).y + predict_y;
        continue; 
    end
    
    % Update target model if probability is higher than previous patches
    if (Frame_information(loop).probability > mean_probability)
        [prev_probability, target_histogram] = update_model(target_histogram, Particle_histogram, Particle_probability, Frame_information, prev_probability, num_bins, N, loop);
    end
    % Update "previous patches"
    if (loop > prev_frames)
        for i = 1:(prev_frames - 1)
            prev_probability(i) = prev_probability(i+1);
        end
        prev_probability(prev_frames) = Frame_information(loop).probability;
    else
        prev_probability(loop) = Frame_information(loop).probability;
    end
     
    % Predict new position based on several previous frames
    [predict_x, predict_y] = predict_next(Frame_information, prev_frames, loop);
    
    % Evaluate variance of particles' weight
    sum_squared_weight = 0;
    
    for i = 1:N
        sum_squared_weight = sum_squared_weight + (Particle_probability(i))^2;
    end
    varience = 1 / sum_squared_weight;
    
    % Judge whether need re-sampling
    if(varience < N/2)
        [Particle_set,Particle_probability]=resample(Particle_set,Particle_probability,N);
    end
    
    imshow(particle_im);
    
    hold on;
    % Top-left corner
    x1 = Frame_information(loop).x - rect(3) / 2;
    y1 = Frame_information(loop).y - rect(4) / 2;
    % Bottom-right corner
    x2 = Frame_information(loop).x + rect(3) / 2;
    y2 = Frame_information(loop).y + rect(4) / 2;
    % Plot on frames
    plot([x1,x2],[y1,y1],[x1,x1],[y1,y2],[x1,x2],[y2,y2],[x2,x2],[y1,y2],'LineWidth',2,'Color','b');
    
    % Get and save frames
    cur_frame = getframe;
    output_dir=strcat(result_dir,num2str(loop),'.jpg');
    imwrite(cur_frame.cdata,output_dir); 
       
end

