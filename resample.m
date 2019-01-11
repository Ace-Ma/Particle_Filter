% This function resamples particles when variance of probabilities is too high.
% 1. Remove particles with extremely low probabilities.
% 2. Copy particles with relatively high probabilities.

function [New_particle_set,New_particle_probability] = resample(Particle_set,Particle_probability,N)

% Calculate cumulative density function of probability.
Sum_probability(1) = Particle_probability(1);
for i = 2:N
    Sum_probability(i) = Sum_probability(i-1) + Particle_probability(i);
end

% Normalize
CDF_probability = Sum_probability ./ Sum_probability(N);

% Random seed
Y = rand(1,N);

particle_copy=zeros(1,N);

for i=1:N
    
   j = min(find(CDF_probability >= Y(i)));
   particle_copy(j) = particle_copy(j) + 1;
      
end

% Find the particles to be deleted
discard = find(particle_copy == 0);
% Particles to be kept
keep = find(particle_copy == 1);
% Particles to be copied (to make up the deleted particles)
copy = find(particle_copy > 1);

length_discard = length(discard);
length_keep = length(keep);
length_copy = length(copy);

% Just make a copy of the kept particles
i = 1;
while(i <= length_keep)
	New_particle_set(keep(i)).x = Particle_set(keep(i)).x;
	New_particle_set(keep(i)).y = Particle_set(keep(i)).y;
	i = i + 1;
end

% Make a copy of copied particles
i = 1;
while(i <= length_copy)
	New_particle_set(copy(i)).x = Particle_set(copy(i)).x;
	New_particle_set(copy(i)).y = Particle_set(copy(i)).y;
	i = i + 1;
end

% For each pair of copied and discarded particles, calculate their weighted sum as a new particle.
i = 1;
j = 1;
for i = 1:length_copy
	while(particle_copy(copy(i)) > 1 && j <= length_discard)
        
        w_c = Particle_probability(copy(i)) / (Particle_probability(copy(i))+Particle_probability(discard(j)));
        w_d = Particle_probability(discard(j)) / (Particle_probability(copy(i))+Particle_probability(discard(j)));
        New_particle_set(discard(j)).x = round(w_c * double(Particle_set(copy(i)).x) + w_d * double(Particle_set(discard(j)).x));
        New_particle_set(discard(j)).y = round(w_c * double(Particle_set(copy(i)).y) + w_d * double(Particle_set(discard(j)).y));
        j = j + 1;
        
        particle_copy(copy(i)) = particle_copy(copy(i)) - 1;
        
    end
end

% Assign new probabilities to resampled particles
for i = 1:N
	New_particle_probability(i) = 1/N;
end


