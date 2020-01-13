K = 19;
I = imread('lena.bmp');
figure, imshow(I);
W2D = imread('iut5.bmp');
figure, imshow(W2D);
W2D = imbinarize(W2D);
for B = [8, 10, 12]
    for a = [floor(B / 2), floor(B / 2) + 1]
        for alpha = [0, 0.1, 0.5, 1.0, -1]
            for Q = [40, 60, 80, 100]
                adaptive = alpha == -1;
                if adaptive
                    fprintf("B: %d, A: %d, alpha: adaptive, Quality: %d\n", B, a, Q);
                    [PSNR, NC] = main_Adaptive(I, B, a, W2D, K, alpha, Q);
                else
                    fprintf("B: %d, A: %d, alpha: %.1f, Quality: %d\n", B, a, alpha, Q);
                    [PSNR, NC] = main_project(I, B, a, W2D, K, alpha, Q);
                end
                fprintf("PSNR: %.2f, NC after attack: %.2f\n", PSNR, NC);
                pause
            end
        end
    end
end