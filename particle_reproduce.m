% This function propagates particles based on previous moving direction
% together with gaussian distribution.

function [Particle_set,particle_im]=particle_reproduce(Particle_set,im,N,predict_x,predict_y,image_X,image_Y,x_sigma,y_sigma,isGrayscale)

particle_im = im;

% Here we randomly get displacement of particles.
% The mean of gaussian distribution is previous displacement.
% We use that information to guide the propagation of new particles.
disp_x = random('Normal',predict_x,x_sigma,1,N);
disp_y = random('Normal',predict_y,y_sigma,1,N);

for i = 1:N

    current_x = Particle_set(i).x;
    current_y = Particle_set(i).y;
    rand_x = round(disp_x(i));
    rand_y = round(disp_y(i));
    
    Particle_set(i).x = current_x+rand_x;
    Particle_set(i).y = current_y+rand_y;   
    
    % Handling special situation that particles run out of image.
    if Particle_set(i).x <= 0
        Particle_set(i).x = 1;
    end
	if Particle_set(i).y <= 0
        Particle_set(i).y = 1;
    end
	if Particle_set(i).x > image_X
               Particle_set(i).x = image_X;
    end
 	if Particle_set(i).y > image_Y
               Particle_set(i).y = image_Y;
    end
    
    % Plot particles on image
 	particle_im(Particle_set(i).y,Particle_set(i).x,1)=255; 
    if (~isGrayscale)
        particle_im(Particle_set(i).y,Particle_set(i).x,2)=0;
        particle_im(Particle_set(i).y,Particle_set(i).x,3)=0;
    end
end


