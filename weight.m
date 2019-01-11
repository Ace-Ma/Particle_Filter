% Evaluate similarity between two histrogram
% based on Bhattacharyya distance.
% While the value is 0, it means that two histograms are totally different.

function similarity=weight(tracked,target,n)

similarity = 0;

for i = 1:n
	similarity = similarity + (tracked(i) * target(i))^0.5;  
end
