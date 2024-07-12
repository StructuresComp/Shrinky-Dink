% R_array = linspace(45,70,26)/1000;
% thickness_array = [1.9:0.3:3.7]/1000;
shape_array = 1:8;
shape_name_array = shape_array;
% 
parob = gcp('nocreate');

% addAttachedFiles(parob,{'PyramidFaceAll.STL','PeanutFaceAll.STL','ButterflyFaceAll.STL','ShellFaceAll.STL'})
parfor i=1:length(shape_array)
shape_id = shape_array(i);
Main;
shape_name_array(i) = shape;

jobName = sprintf( ['r-bi-', '%s'], shape_id);
odbname = [jobName, '.odb'];
system(['mv ',odbname, ' r',odbname])

system(['rm ', jobName,'*']); 
system(['rm -r /tmp/root_', jobName,'*']); 
end

% height = zeros(length(shape_array),1);
% for i = 1:length(shape_array)
%     % if(i==2)
%     %     continue
%     % end
%     shape_id = shape_array(i)
%     jobName = sprintf( ['r-bi-', '%s'], shape_id)
%     filename_short = ['final-short-',jobName,'-output.txt'];
% 
%     data1=importdata(filename_short);
%     i
% 
%     height(i) = data1(1)-0.0018;
% end
% 
% plot(shape_array,height*1e3/110,"*-");

% plot(radiusRatio_array,height*1e3/55,"*-");

% %% Uncomment to plot graphs or use plotheight.m
% height = zeros(length(radiusRatio_array),1);
% curvature =  zeros(length(radiusRatio_array),1);
% height2 =  zeros(length(radiusRatio_array),1);
% main_dimension = 0.055;
% thickness_2 = 1.8/1000;
% for i =1 :length(radiusRatio_array)
% radiusRatio = radiusRatio_array(i);
%     jobName = sprintf( ['r-bi-', '%d-%.0f'], main_dimension*1000, thickness_2*10000);
% odbname = [jobName, '.odb'];
% odbname_new = ['r',jobName,'-gamma-',num2str(radiusRatio*100), '.odb'];
% % system(['mv ', odbname, ' ',odbname_new]);
% 
% filename_short = ['final-short-',jobName,'-output.txt'];
% filename_long = ['final-long-',jobName,'-output.txt'];
% 
% filename_short_new = ['final-short-',jobName,'-gamma-',num2str(radiusRatio*100),'-output.txt'];
% filename_long_new = ['final-long-',jobName,'-gamma-',num2str(radiusRatio*100),'-output.txt'];
% 
% % system(['mv ', filename_long, ' ',filename_long_new]);
% % system(['mv ', filename_short, ' ',filename_short_new]);
% 
% 
%     radiusRatio = radiusRatio_array(i);
% 
%     data1=importdata(filename_short_new);
% 
%     height(i) = data1(1)-0.0018;
%     % 
%     % % data2=importdata(sprintf('rr-ratio-%d-final-long-r-bi-55-18-output.txt',radiusRatio*100));
%     % total_nodes = length(data2)/3;
%     % x = data2(1:total_nodes);
%     % y = data2(total_nodes+1:total_nodes*2);
%     % z = data2(total_nodes*2+1:total_nodes*3);
%     % % surf(x,y,z)
% 
%     axis square
%     % pause(10)
% 
% end
% 
% plot(radiusRatio_array,height*1e3/55,"*-");