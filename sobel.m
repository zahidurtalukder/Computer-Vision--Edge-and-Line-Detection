function Edge_detect = sobel(Input_image)
    Input= rgb2gray(Input_image);
    figure, imshow(Input); title('Actual GrayScale Image for Sobel Edge Detection'); 
    Input= double(Input);
    [row,col]=size(Input);
    Edge_detect = zeros(size(Input)); 
    x_image= zeros(size(Input));
    y_image=zeros(size(Input));
    dir=zeros(size(Input));
    % X filter and Y filter
    Hx = [-1 0 1; -2 0 2; -1 0 1]; 
    Hy = [-1 -2 -1; 0 0 0; 1 2 1];
 

    for i = 2:row-2 
        for j = 2:col-2 
            % Convolution with X filter and Y filter
            Grad_x= -Input(i-1,j-1)-2*Input(i,j-1)-Input(i+1,j-1)+Input(i-1,j+1)+2*Input(i,j+1)+Input(i+1,j+1);
            Grad_y= -Input(i-1,j-1)-2*Input(i-1,j)-Input(i-1,j+1)+Input(i+1,j-1)+2*Input(i+1,j)+Input(i+1,j+1);
            x_image(i,j)=Grad_x;
            y_image(i,j)=Grad_y;
            bla= atan2(Grad_y, Grad_x) * 100;
            if (bla >= 1 && bla <= 255)
                dir(i,j) = 255;
            else
                dir(i,j) = 0;
            end
            Edge_detect(i, j) = sqrt(Grad_x.^2 + Grad_y.^2); 

        end
    end
    Edge_detect = uint8(Edge_detect);
    Edge_detect(Edge_detect>=100)=255;
    Edge_detect(Edge_detect<100)=0;
    figure, imshow(Edge_detect); title('Gradient Magnitude Image for sobel Edge Detection (Threshold 100)'); 
    dir = uint8(dir); 
    figure, imshow(dir); title('Gradient Direction Image for sobel Edge Detection');

end
