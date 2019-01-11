% This function processes first frame.
% 1. Initialize particles.
% 2. Set up a structure for storing information of each frame.


function [Particle_set,Particle_probability,Frame_information,target_histogram, num_bins] = process_first_frame(X,Y,hx,hy,im,N,image_X,image_Y)

% Initialize all particles in central point
for i = 1:N
	Particle_set(i).x = X;
	Particle_set(i).y = Y;    
end

% Get histogram of target object
[target_histogram, num_bins] = get_histogram(X,Y,hx,hy,im,image_X,image_Y);

% Store central point / histogram / probabilities to the first element of structure.
Frame_information(1).x = X;
Frame_information(1).y = Y;
Frame_information(1).histogram = target_histogram;
Frame_information(1).probability = weight(Frame_information(1).histogram,target_histogram,num_bins);

% Give each initial particle the same probability: 1/N
initial_probability = 1 / N;

for i=1:N
	Particle_probability(i)=initial_probability;       
end






