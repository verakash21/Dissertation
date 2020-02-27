%  f = image intensity function, p = order, q = repetition like n,m in the equations

clear all; clc;
%imshow(image);  % Display one gray pixel
order=4;   % For 12 ZMs: Z00, Z11, Z20,Z22, Z31,Z33,Z40,Z42,Z44,Z51,Z53,Z55
output_filename = 'Moments_data_bleeding.xlsx';
allFiles = dir('120bleeding/*.png');
format short g;
T = table;
for k = 1:length(allFiles)
    baseFileName = allFiles(k).name;
    fullFileName = fullfile('120bleeding/', baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    image = imread(fullFileName);
    N = length(image);    %To discretize the image
    x = 1:N; y = 1:N;
    [X,Y] = meshgrid(x,y);
    X=X-1; Y=Y-1;
    xi=(2.*X+1-N)/(N*sqrt(2));  yj=(2.*Y+1-N)/(N*sqrt(2));   %For image map into the circle in complex plane

    R = sqrt(xi.^2+yj.^2); 
    R = (R<=1).*R;                      % Radius for whichever points are inside the circle
    Theta = atan2(yj,xi);           % Angle for all points in/out of circle
    Theta=(Theta<0)*2*pi+Theta;    

    f = double(image);      % pixel intensity function
    count=1;
    for p=0:order
        for q=0:p
             if (mod((p-abs(q)),2)~=0)
                continue;
            end
            Rad = radialpoly(R,p,q);
            Product = f.*Rad.*exp(-i*q*Theta);                   
            Z = sum(Product(:));  
            Z = ((2*(p+1))/(pi*N^2))*Z;     % xi*yj=4/D^2 and for outer circle D=N*sqrt(2)
            Re(count)=real(Z);       
            Imag(count)=imag(Z);
            A(count) = round(abs(Z),3);       % Zernike moments for image features are here
            Phi(count) = angle(Z);   % What is the advantage of this Phi? 
            count=count+1;
        end
    end
    %disp('For n=m=4 the 9 Zernike moments are: ');
    disp(A);
    x_t = table({baseFileName},A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9));
    T = [T; x_t];
end
T.Properties.VariableNames = {'File','Z00','Z11','Z20','Z22','Z31','Z33','Z40','Z42','Z44'};
writetable(T,output_filename,'Sheet',1)