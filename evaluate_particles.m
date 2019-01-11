% This function predicts central point in a new frame by calculating
% weighted mean of all particles.

function [New_particle_probability,Frame_information,Sample_histogram] = evaluate_particles(Particle_set,Frame_information,target_histogram,loop,particle_im,im,N,image_X,image_Y,hx,hy,Particle_probability)

total_probability = 0;

% Evaluate probabilities for all propagated particles.
for i=1:N
    
    [Sample_histogram(i,:), num_bins] = get_histogram(Particle_set(i).x,Particle_set(i).y,hx,hy,im,image_X,image_Y); 

    New_particle_probability(i) = Particle_probability(i) * weight(target_histogram,Sample_histogram(i,:),num_bins);

    total_probability=total_probability+New_particle_probability(i);
    
end

% Normalize probabilities
New_particle_probability = New_particle_probability ./ total_probability;

Frame_information(loop).x = 0;
Frame_information(loop).y = 0;

% Calculate weighted mean of all particles and store coordinate of central point into structure.
for i=1:1:N
    Frame_information(loop).x = Frame_information(loop).x + double(Particle_set(i).x) * New_particle_probability(i);
    Frame_information(loop).y = Frame_information(loop).y + double(Particle_set(i).y) * New_particle_probability(i);
end

% Store histogram and probability of new frame.
Frame_information(loop).histogram = get_histogram(round(Frame_information(loop).x),round(Frame_information(loop).y),hx,hy,im,image_X,image_X);
Frame_information(loop).probability = weight(target_histogram,Frame_information(loop).histogram,num_bins);  





