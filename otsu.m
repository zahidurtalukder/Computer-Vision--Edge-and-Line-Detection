
%B=imread('cat.jpg');
B= imread('umbrella_woman.jpg');
figure, imshow(B);title('Actual RGB Image');
B= rgb2gray(B);
figure, imshow(B);title('Actual grayscale Image');
V=reshape(B,[],1);
G=hist(V,0:255);
H=reshape(G,[],1);
Ind=0:255;
Index=reshape(Ind,[],1);
result=zeros(size([1 256]));

for i=0:255
     [wbk,varbk]=calculate_threshold(1,i,H,Index);
     [wfg,varfg]=calculate_threshold(i+1,255,H,Index);
     result(i+1)=(wbk*varbk)+(wfg*varfg);
 end
%Find the minimum value in the array.                  
[threshold_value,val]=min(result);
tval=(val-1)/256;
fprintf('Minimum Threshold Value is %f',tval);
bin_im=im2bw(B,tval);
figure,imshow(bin_im);title('Thresholded Image');



function [weight,var]=calculate_threshold(m,n,H,Index)
%Weight Calculation
     weight=sum(H(m:n))/sum(H);
%Mean Calculation
     value=H(m:n).*Index(m:n);
     total=sum(value);
     mean=total/sum(H(m:n));
     if(isnan(mean)==1)
         mean=0;
     end
%Variance calculation.
     value2=(Index(m:n)-mean).^2;
     numer=sum(value2.*H(m:n));
     var=numer/sum(H(m:n));
     if(isnan(var)==1)
         var=0;
     end
end

