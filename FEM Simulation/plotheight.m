% lambda_array = [1.2, 1.4, 1.6, 1.8, 2];
% 
% heigheight = zeros(length(lambda_array),1);

for i =1 :length(lambda_array)
%     system(['/home/sci02/abaqus/Commands/abaqus cae noGUI=readODB -- rr-j-alpha-tri-',...
%         num2str(lambda_array(i)*10),'-30.odb']);
    str = ['rr-j-alpha-tri-',num2str(lambda_array(i)*10),'-30_output.txt']
    data=importdata(str);
    zall=data(length(data)*2/3+1:end);
    yall=data(length(data)/3+1:length(data)*2/3);
    xall=data(1:length(data)/3);
    maxzall=max(max(zall));
    minzall=min(min(zall));
    height(i) = maxzall-minzall;
end

plot(lambda_array,height/0.06, "ro");