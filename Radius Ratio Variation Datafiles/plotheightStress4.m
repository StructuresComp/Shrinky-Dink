close all
radiusRatio_array = 0.05:0.01:1;
figure(1)
height = zeros(length(radiusRatio_array),1);
for i = 1:length(radiusRatio_array)
    try
    radiusRatio = radiusRatio_array(i);
    jobName = sprintf( ['r-bi-', '%.0f'], radiusRatio*100);
    filename_short = ['final-short-',jobName,'-output.txt'];

    data1=importdata(filename_short);
    

    height(i) = data1(1);
    catch
        "Oops";
    end
end

radiusRatio_array_exp = [0.05 0.1 0.15 0.3 0.35 0.4:0.1:1];
height_exp = [0.3855 0.3873 0.3982 0.3476 0.3388 0.3148 0.2827 0.2506 0.1932 0.1482 0.1082 0.0703];
plot(radiusRatio_array,height*1e3/110,"-*");
hold on
plot(radiusRatio_array_exp,height_exp,"*");
ylabel("Normalized Height H/2R")
xlabel("Radius Ratio")
ylim([0 1])

