%% Robert Edge Detection

Image = imread('umbrella_woman.jpg'); 
rober_edge= robert(Image);

%% Sobel Edge Detection

Image = imread('umbrella_woman.jpg'); 
sobel_edge= sobel(Image);

%% Prewitt Edge Detection

Image = imread('umbrella_woman.jpg'); 
prewitt_edge= prewitt(Image);