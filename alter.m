function [tr] = alter(tr, data, a, alpha, adaptive)
current_data = tr(a + 1, a) > tr(a, a + 1);
if current_data ~= data
    % Using alpha, we specify the range of values that should be considered
    % before deciding about the new values of tr(a+1, a) and tr(a,a+1).
    % When the alpha is low, we only make sure that these two elements have
    % a significant value compared to the high-frequency components of the
    % patch. Therefore, the watermarking can survive high-quality
    % compression.
    % As the alpha value increases, we look at lower and lower frequencies
    % of the image and adjust tr(a+1, a) and tr(a,a+1) so that they have a
    % considerable value compared to them. Higher values would ensure the
    % survival of the watermark but cause visible distortions within the
    % image, specially if the patch under process is smooth. Maximum value
    % for alpha ensures recovery but causes visible distortions.
    % Adaptive behaviour disposes the specified alpha and picks a value
    % according to the patch; the smoother the patch, the lower the alpha
    % rate.
    if adaptive 
        % Automatically adjust the alpha according to tr. Lower values of
        % alpha avoid causing distortions in smooth patches. Such patches
        % have considerabely higher values for their low-frequency DCT
        % components. To detect this numerically, we will check to see if
        % the DC component of the patch is its prominant one. If not, we
        % use a measure of smoothness to determine alpha accordingly.
        % We can then set alpha to 1 minus this ratio.
        s = sum(abs(tr), 'all');
        if s == 0
            alpha = 0; % The patch is perfectly smooth: Division by Zero!
        else
            alpha = 1 - abs(tr(1, 1)) / s; % The DC value of the path divided by the total sum.
            % The smoother the patch, the larger the DC coefficient,
            % the smaller the alpha.
        end
    end
    % Applying the alpha rate
    offset = alpha * (a - 1);
    a_ = floor(a - offset) + 1;
    % Picking the new values for tr(a + 1, a) and tr(a, a + 1)
    vertical_selection_region = tr(a_:end, :);
    horizontal_selection_region = tr(:, a_:end);
    selection_region = cat(1, vertical_selection_region(:), horizontal_selection_region(:));
    maximum = max(selection_region, [], 'all');
    minimum = min(selection_region, [], 'all');
    % These values might be the same...
    if maximum == minimum
        % Double the maximum if both variables contain the same positive
        % number.
        if maximum > 0
            maximum = maximum * 2;
        % Or if they're the same negative number, cut the maximum in half
        % so it is considered larger.
        elseif maximum < 0
            maximum = maximum / 2;
        % If they're both zero, it is likely that we're dealing with a
        % perfectly empty patch. In this case, any value may cause visible
        % distortions, so let's involve alpha again.
        else
            maximum = 10 + 990 * alpha; 
        end
    end
    % Finally, we set the new values of tr(a+1, a) and tr(a,a+1).
    if data
        tr(a + 1, a) = maximum;
        tr(a, a + 1) = minimum;
    else
        tr(a + 1, a) = minimum;
        tr(a, a + 1) = maximum;
    end
end
end

