%% Plotting Function
ext = '*.xlsx';
files = dir(ext);

for i = 1:length(files)
    plot_Data(files(i).name)
end

function plot_Data (filename)

split_array = split(filename,["_","."]);

deformationTime = str2double(split_array(3))/100;
plotTitle = strjoin(["Temperature Data for ",split_array(1),": Specimen ",split_array(2)]);
plotFileName = strjoin(split_array(1:3),"_");

dataTable = readtable(filename, 'TextType','string');
dataTable.CH1 = extractBefore(dataTable.CH1,strlength(dataTable.CH1)-1);
disp(dataTable.Properties.VariableNames);

temperature = str2double(dataTable.CH1);
time_size = length(temperature);
time = linspace(1, time_size, time_size);
h1 = figure(1);
m = mean(temperature);
meanploty = [m, m];
meanplotx = [0 max(time) + 10];
grid('on');
FONT = 'Arial';
FONTSIZE = 12;
pWidth = 4; % inches
pHeight = 3;
colpos = [247 148 30;0 166 81;237 28 36;0 174 239; 0 0 0]/255; % colors
plot(time, temperature, '^', 'Color', colpos(1,:));
%title(figureTitle, 'Fontname', FONT, 'FontSize', FONTSIZE);
title(plotTitle, 'Fontname', FONT, 'FontSize', FONTSIZE);
xLine = [deformationTime, deformationTime]; % x-coordinates of the line
yLimits = [0 max(temperature)+10]; % Get the y-axis limits of the current plot

% Plot the vertical line
line(xLine, yLimits, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2); % Red dashed line with thickness 2
line(meanplotx, meanploty, 'Color', 'b', 'LineStyle', '-', 'LineWidth', 1); % Red dashed line with thickness 2
box on
xlabel('Time After Placing in Oven, t (s)', 'Fontname', FONT, 'FontSize', FONTSIZE);
ylabel(strcat('Temperature of Oven, T (', char(176), 'F)'), 'Fontname', FONT, 'FontSize', FONTSIZE);
AX = legend('Temperature','Start of Deformation', 'Mean Temperature', 'Location', 'SouthEast');
LEG = findobj(AX,'type','text');
ylim([0 inf])
set(LEG,'Fontname',FONT,'FontSize',FONTSIZE);
set(gca,'Fontname', FONT,'FontSize',FONTSIZE);
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);
saveas(h1, strjoin([plotFileName,".pdf"]));
hold off

end
