close all

% Simulation

addpath('Radius Ratio Variation Simulation Data/')

radiusRatio_array = 0.05:0.01:1;
norm_height_sim = zeros(length(radiusRatio_array),1);

for i = 1:length(radiusRatio_array)
    try
    radiusRatio = radiusRatio_array(i);
    jobName = sprintf( ['r-bi-', '%.0f'], radiusRatio*100);
    filename_short = ['final-short-',jobName,'-output.txt'];

    data_sim=importdata(filename_short);
    
    norm_height_sim (i) = data_sim(1)/0.11;
    catch
        fprintf("Error: File not Found for Radius Ratio %.0f", radiusRatio_array(i));
    end
end

%Experiment
radiusRatio_array_exp = [0.05 0.1 0.15 0.3 0.35 0.4 0.5 0.6 0.7 0.8 0.9 1];
norm_height_exp1 = [41.00, 42.4, 43.10,36.4,36,34,30.6,29.3,21.6,17.9,5,3.9]/110;
norm_height_exp2 = [44.6,42.2,45,40.1,37.7,35.2,31.3,32.1,21.25,13.4,10,12.2]/110;
norm_height_exp3 = [41.6,43.2,43.3,38.2,38.1,34.7,31.4,21.3,20.9,17.6,20.7,7.1]/110;

norm_height_exp = (norm_height_exp1+norm_height_exp2+norm_height_exp3)/3;

error_norm_height_exp = std([norm_height_exp1;norm_height_exp2;norm_height_exp3]);

p = polyfit(radiusRatio_array_exp, norm_height_exp, 3);
py = polyval(p, radiusRatio_array_exp);

pWidth = 4; % inches
pHeight = 3;
colpos = [247 148 30;0 166 81;237 28 36;0 174 239; 0 0 0]/255; % colors

h1 = figure(1);

plot(radiusRatio_array,norm_height_sim,"b*-",'DisplayName','Simulation','MarkerSize',1);
hold on
errorbar(radiusRatio_array_exp,norm_height_exp,error_norm_height_exp,"^",'DisplayName','Experiment',...
    'MarkerSize',10,'LineWidth',2,'Color', colpos(1,:))

ylabel("Normalized Height H/2R")
xlabel("Radius Ratio")
ylim([0 1])
legend('Location','northeast',"FontSize",12)
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);
saveas(h1, "Parametric Variation Plot.pdf");
