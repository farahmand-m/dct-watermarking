function [] = save_logo(W2D_, W2D, alpha, Q)
% The function highlights the similar pixels between the original watermark
% logo and the extracted ones.
% True Positives and False Positives keep their original looks, while False
% Positives and False Negatives are colored as dark gray and light gray
% pixels, respectively.
true_positives = W2D == 1 & W2D_ == 1;
false_positives = W2D == 0 & W2D_ == 1;
true_negatives = W2D == 0 & W2D_ == 0;
false_negatives = W2D == 1 & W2D_ == 0;
image = true_positives * 255 + false_positives * 170 + false_negatives * 85 + + true_negatives * 0; % Last ones just for clarification :D
image = uint8(image);
save_as = sprintf('.\\extracted\\alpha%d-quality%d.bmp', alpha * 100, Q);
imwrite(image, save_as);
end

