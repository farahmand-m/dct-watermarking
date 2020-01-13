function [PSNR, nc] = main_Adaptive(I, B, a, W2D, K, alpha, Q)
[PSNR, nc] = main_project(I, B, a, W2D, K, alpha, Q, 1);
end

