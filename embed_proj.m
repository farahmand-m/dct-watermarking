function [W_image, W1D, PSNR] = embed_proj(I, B, a, W2D, K, alpha, adaptive)
if nargin < 7
    adaptive = 0; % The last argument defaults to 'False' when unset.
end
% Ground Truths
[width, height] = size(I);
% Watermark Preparation
W1D = imresize(W2D, [floor(width / B), floor(height / B)]);
W1D = W1D(:);
% Watermark Randomization
rng(K);
indices = randperm(size(W1D, 1));
W1D_randomized = W1D(indices); % The randomized W1D is embedded but the original one is left to return for later comparision
% Embedding
W_image = double(I);
index = 0;
for i = 1:B:(width - mod(width, B))
    for j = 1:B:(height - mod(height, B))
        % Discrete Cosine Transformation
        tr = dct2(I(i:i+B-1, j:j+B-1));
        % Tampering with the DCT coefficients
        index = index + 1;
        data = W1D_randomized(index);
        tr = alter(tr, data, a, alpha, adaptive);
        % Block Reconstruction
        W_image(i:i+B-1, j:j+B-1) = idct2(tr);
    end
end
W_image = uint8(W_image);
PSNR = psnr(W_image, I);
end

