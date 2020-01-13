K = 19;
I = imread('lena.bmp');
W2D = imread('iut5.bmp');
W2D = imbinarize(W2D);
B = 8;
a = 4;
for alpha = [0, 0.1, 0.5, 1.0]
    for Q = [40, 60, 80, 100]
        fprintf("B: %d, A: %d, alpha: %.1f, Quality: %d\n", B, a, alpha, Q);
        [PSNR, NC] = main_project(I, B, a, W2D, K, alpha, Q);
        fprintf("PSNR: %.2f, NC after attack: %.2f\n", PSNR, NC);
    end
end