function [PSNR, nc] = main_project(I, B, a, W2D, K, alpha, Q, adaptive)
if nargin < 8
    adaptive = 0; % The last argument defaults to 'False' when unset.
end
% Ground Truths
[width, height] = size(I);
% Watermarking
[W_image, W1D, PSNR] = embed_proj(I, B, a, W2D, K, alpha, adaptive);
% figure, imshow(W_image);
W1D_ = extract_proj(W_image, B, a, K);
nc = NC_project(W1D_, W1D);
assert(nc == 1);
% Compression and NC Check
imwrite(W_image, 'tmp.jpg', 'quality', Q);
W_image_com = imread('tmp.jpg');
% figure, imshow(W_image_com);
W1D_ = extract_proj(W_image_com, B, a, K);
nc = NC_project(W1D_, W1D);
% Extracting the Watermark
W2D_ = reshape(W1D_, floor(width / B), floor(height / B));
W2D_ = imresize(W2D_, size(W2D));
% figure, imshow(W2D_);
% Saving the attacked Watermark
save_logo(W2D_, W2D, alpha, Q);
end

