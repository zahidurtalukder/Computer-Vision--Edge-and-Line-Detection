%% Load  image
img = imread( 'lines.png');
% Gaussian Image blur before Edge detection
gaussianFilter = fspecial('gaussian',5, 5);
img_filted = imfilter(img, gaussianFilter,'symmetric');
% Using my own sobel function to generate edges
img = sobel(img_filted);

%% Perform Hough Transform for lines
img_edges = logical(img);
[H, theta, rho] = hough_lines_acc(img_edges); 


% Plot/show accumulator array H
figure();
imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho,...
      'InitialMagnification','fit');
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);
% Find Peaks
peaks = hough_peaks(H,14); 
% Highlight peak locations on accumulator array
imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho,'InitialMagnification','fit');
title('Hough transform with peaks found');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(theta(peaks(:,2)),rho(peaks(:,1)),'o','LineWidth',3,'color','red');
% Draw Lines
hough_lines_draw(img, peaks,rho,theta);


%% Functions for Hough transform.
function [H, theta, rho] = hough_lines_acc(BW, varargin)
    p = inputParser();
    addParameter(p, 'RhoResolution', 1);
    addParameter(p, 'Theta', linspace(-90, 89, 180));
    parse(p, varargin{:});
    rhoStep = p.Results.RhoResolution;
    theta = p.Results.Theta;
    dMax = sqrt((size(BW,1) -1 ) ^ 2 + (size(BW,2)-1 ) ^ 2);
    numRho = 2 * (ceil(dMax / rhoStep)) + 1;
    diagonal = rhoStep * ceil(dMax / rhoStep);% rho ranges from -diagonal to diagonal
    numTheta = length(theta);
    H = zeros(numRho, numTheta);
    rho = -diagonal : diagonal;
    for i = 1 : size(BW,1)
        for j = 1 : size(BW,2)
            if (BW(i, j))
                for k = 1 : numTheta
                    temp = j * cos(theta(k) * pi / 180) + i * sin(theta(k) * pi / 180);
                    rowIndex = round((temp + diagonal) / rhoStep) + 1;
                    H(rowIndex, k) = H(rowIndex, k) + 1;                   
                end
            end            
        end
    end    
end


function hough_lines_draw(img, peaks, rho, theta)
    figure();
    imshow(img);
    hold on;
    for i = 1 : size(peaks,1)
       rho_i = rho(peaks(i,1));
       theta_i = theta(peaks(i,2)) * pi / 180;
       if theta_i == 0
           x1 = rho_i;
           x2 = rho_i;
           if rho_i > 0
               y1 = 1;
               y2 = size(img,1);
               plot([x1,x2],[y1,y2],'r','LineWidth',1.5); 
           end           
       else
           x1 = 1;
           x2 = size(img, 2);
           y1 = (rho_i - x1 * cos(theta_i)) / sin(theta_i);
           y2 = (rho_i - x2 * cos(theta_i)) / sin(theta_i);
           plot([x1,x2],[y1,y2],'r','LineWidth',1.5); 
       end
             
    end
end

function peaks = hough_peaks(H, varargin)
    p = inputParser;
    addOptional(p, 'numpeaks', 1, @isnumeric);
    addParameter(p, 'Threshold', 0.5 * max(H(:)));
    addParameter(p, 'NHoodSize', floor(size(H) / 100.0) * 2 + 1);  % odd values >= size(H)/50
    parse(p, varargin{:});

    numpeaks = p.Results.numpeaks;
    threshold = p.Results.Threshold;
    nHoodSize = p.Results.NHoodSize;

    peaks = zeros(numpeaks, 2);
    num = 0;
    while(num < numpeaks)
        maxH = max(H(:));
        if (maxH >= threshold)
            num = num + 1;
            [r,c] = find(H == maxH);
            peaks(num,:) = [r(1),c(1)];
            rStart = max(1, r - (nHoodSize(1) - 1) / 2);
            rEnd = min(size(H,1), r + (nHoodSize(1) - 1) / 2);
            cStart = max(1, c - (nHoodSize(2) - 1) / 2);
            cEnd = min(size(H,2), c + (nHoodSize(2) - 1) / 2);
            for i = rStart : rEnd
                for j = cStart : cEnd
                        H(i,j) = 0;
                end
            end
        else
            break;          
        end
    end
    peaks = peaks(1:num, :);            
end