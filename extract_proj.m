function [S] = extract_proj(W_image, B, a, K)
% Ground Truths
[width, height] = size(W_image);
% Randomized Array Extraction
S = [];
for i = 1:B:(width - mod(width, B))
    for j = 1:B:(height - mod(height, B))
        % Discrete Cosine Transformation
        tr = dct2(W_image(i:i+B-1, j:j+B-1));
        % Extracting the Information
        data = tr(a + 1, a) > tr(a, a + 1);
        S = [S data];
    end
end
% Inverting the Permutation (Decryption)
S = S';
S = logical(S);
rng(K);
indices = randperm(size(S, 1));
S(indices) = S;
end

