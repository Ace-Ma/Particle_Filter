function [prev_probability, new_target_histogram] = update_model(target_histogram, Particle_histogram, Particle_probability, Frame_information, prev_probability, num_bins, N, loop)

% Get the N/10 particles with highest probability
n = N / 10;
[probability, position] = sort(Particle_probability, 'descend');
probability = probability(1 : n);
position = position(1 : n);

% Normalize the probability of these N/10 particles
sum_probability = sum(probability);
probability = probability ./ sum_probability;

% Get average histogram of these N/10 particles
average_histogram = zeros(1, num_bins);
for i = 1:n
    average_histogram = average_histogram + probability(i) * Particle_histogram(position(i));
end

% Update that information to target model and normalize it
new_target_histogram = 0.1 * average_histogram + 0.9 * target_histogram;
new_target_histogram = new_target_histogram ./ sum(new_target_histogram);

