%% ***********************************************************************************
%     已知坐标，用cordic算法计算相角和幅值。基本公式如下：
%     x(k+1) = x(k) - d(k)*y(k)*2^(-k)
%     y(k+1) = y(k) + d(k)*x(k)*2^(-k)
%     z(k) = z(k) - d(k)*actan(2^(-k))
%% ***********************************************************************************

clear;close all;clc;
% 初始化----------------------------------------
N = 16;  %迭代次数
tan_table = 2.^-(0 : N-1);
angle_LUT = atan(tan_table);

K = 1;
for k = 0 : N-1
    K = K*(1/sqrt(1 + 2^(-2*k)));
end

x = 3;
y = sqrt(3);
angle_accumulate = 0;

% cordic算法计算-------------------------------
if (x==0 && y==0) 
    radian_out = 0;
    amplitude_out = 0;
else  % 先做象限判断，得到相位补偿值
    if (x > 0)
        phase_shift = 0;
    elseif (y < 0)
        phase_shift = -pi;
    else
        phase_shift = pi;
    end
  
    for k = 0 : N-1   % 迭代开始
        x_temp = x;
        if (y < 0)  % d(k)=1，逆时针旋转
            x = x_temp - y*2^(-k);
            y = y + x_temp*2^(-k);
            angle_accumulate = angle_accumulate - angle_LUT(k+1);
        else          % d(k)=-1，顺时针旋转
            x = x_temp + y*2^(-k);
            y = y - x_temp*2^(-k);
            angle_accumulate = angle_accumulate + angle_LUT(k+1);
        end     
        radian_out = angle_accumulate + phase_shift; %弧度输出
    end
    
    amplitude_out = x*K;  %幅值输出
end
    
angle_out = radian_out*180/pi;  %相角输出</span>
