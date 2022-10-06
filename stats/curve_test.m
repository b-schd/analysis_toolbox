
function [p, true_area]=curve_test(Y,cnd_1, cnd_2, n_perm)
%     Assess whether two curves are statistically significant based on
%     permutation test over conditions and replicates.
%     Parameters
%     ----------
%     Y: 2d array,    shape: (time x var)
%         Observations matrix for each variable over time.
%     cnd_1: list,    shape: (n_reps_1)
%         List of replicate indices in columns of Y for condition 1
%     cnd_2: list,    shape: (n_reps_2)
%         List of replicate indices in columns of Y for condition 2
%     n_perm: int
%         Number of permutations to group
%     Returns
%     -------
%     p: int
%         Two-tailed p-value

    n_reps_1 = length(cnd_1);
    n_reps_2 = length(cnd_2);
    n_reps = size(Y,2); 
    
    if n_reps ~= (n_reps_1 + n_reps_2)
        disp('n_reps does not add up')
        p=[];
        return
    end

    % Get true area between condition curves
    Y_1 = nanmean(Y(:, cnd_1), 2);
    Y_2 = nanmean(Y(:, cnd_2), 2);
    true_area = max(nanmean(Y_1-Y_2), nanmean(Y_2-Y_1));

    % Estimate null distribution of area between curves
    p_count = 0;
    for pr= [1:n_perm]
        rnd_reps = randperm(n_reps);
        rnd_cnd_1 = rnd_reps(1+end-n_reps_1:end);
        rnd_cnd_2 = rnd_reps(1:n_reps_1);

        rnd_Y_1 = nanmean(Y(:, rnd_cnd_1), 2);
        rnd_Y_2 = nanmean(Y(:, rnd_cnd_2), 2);
        rnd_area = max(nanmean(rnd_Y_1-rnd_Y_2), nanmean(rnd_Y_2-rnd_Y_1));

        if rnd_area > true_area
            p_count = p_count+1;
        end
    end

    p = p_count / n_perm;
        
    
end