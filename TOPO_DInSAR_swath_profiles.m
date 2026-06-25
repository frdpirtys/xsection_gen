%% SWATH PROFILES with TOPOTOOLBOX (must be installed first!)

% first lets clear the workspace, command window and close all figures
clear;clc;close all;

%% load Base DEM and DInSAR data

% BASE DEM Atacama
folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\COP30\';
file='Atacama_COP30_19S.tif';

% BASE DEM Pleiades Pisani
% folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDEM\';
% file='DEM_05_nd.tif';

% DInSAR DataGEBCO Atacama 19S
di.folder='D:\Sentinel1\CdSAL_InSAR_proc\GIS_des\';
di.file='20150520_20201231_dispVV.tif';
%di.file='20150520_20201231_dispVV_coh_0_3.tif';
% .                                             20150520_20180311_dispVV.tif.aux.xml          20150520_20201231_dispVV.tif.aux.xml          20150520_20201231_dispVV_coh_0_3.tif.aux.xml  des_20141203_20201231_dispVV.tif.aux.xml      
% ..                                            20150520_20180311_dispVV.tif.ovr              20150520_20201231_dispVV.tif.ovr              20150520_20201231_dispVV_coh_0_3.tif.ovr      des_20141203_20201231_dispVV.tif.ovr          
% 20150520_20180311_dispVV.tfw                  20150520_20201231_dispVV.tfw                  20150520_20201231_dispVV_coh_0_3.tfw          des_20141203_20201231_dispVV.tfw              
% 20150520_20180311_dispVV.tif                  20150520_20201231_dispVV.tif                  20150520_20201231_dispVV_coh_0_3.tif          des_20141203_20201231_dispVV.tif         

%% Define swath width and input mode

width= 5000; %unit is meters

mode=3;% <-- three different inputs of profile points
% 1 >> points choosed by clicking on the map
% 2 >> points imported from Google Earth KLM file
KML_file='newcatarpe.kml';
% 3 >> points defined by user (UTM coordinates), 
%utm_xx=[575090,575270];
%utm_yy=[7463246,7462963];
% or convert from Degrees with deg2utm function.
% It can be as many points as you want (minimum 2 x,y pairs).
% userLat=[-22.914,-22.973];
% userLon=[-68.335,-68.268];
userLat=[-23.2,-23.2];
userLon=[-69.25,-68.25];
[utm_xx,utm_yy,utm_zones]=deg2utm(userLat,userLon);

%qda seca
% utm_xx=[575658.199,579334.375];
% utm_yy=[7474275.073,7473158.337];

%catarpe thrust


%% run first, if you want to keep source of information but change swath, don't clear all, safe here
ruta=append(folder,file);
di.ruta=append(di.folder,di.file);
id=extractBefore(di.file,".tif");
id = strrep(id,'_dispVV','')
id = strrep(id,'_','-')
%% LOAD DEM AND DINSAR DATA. ONLY RUN ONCE
DEM = GRIDobj(ruta);
DInSAR = GRIDobj(di.ruta);

%%
clear SWdem SWdinsar
clc
if mode == 1
    % Define UTM coordinates and width for Swath profile
    fprintf('When the map opens, single click to start the swath and double click to stop the swath.')
    fprintf('\n');
    SWdem = SWATHobj(DEM,'width',width);
    % Look at what your swath object contains.
    SWdem
    % Note that it contains info about the coordinate endpoints you clicked
    % (xy0), the width of the swath, and the swath values (Z).
    di.y=SWdem.xy0(:,2)
    di.x=SWdem.xy0(:,1)
    SWdinsar = SWATHobj(DInSAR,di.x,di.y,'width',width);
elseif mode==2
    fprintf('Importing data from KLM file.');
    fprintf('\n');
    [kml_xx,kml_yy,kml_zz]=read_kml(KML_file);
    %[utm_xx,utm_yy,utm_zones]=deg2utm(kml_yy,kml_xx);
    [utm_xx,utm_yy]=deg2utm_19fix(kml_yy,kml_xx);
    SWdem = SWATHobj(DEM,utm_xx,utm_yy,'width',width);
    SWdinsar = SWATHobj(DInSAR,utm_xx,utm_yy,'width',width);
elseif mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SWdem = SWATHobj(DEM,utm_xx,utm_yy,'width',width);
    SWdinsar = SWATHobj(DInSAR,utm_xx,utm_yy,'width',width);
end

dem_distx_km=SWdem.distx/1000; %converting meters into km
dinsar_distx_km=SWdinsar.distx/1000; %converting meters into km
cero=SWdem.Z*0;
a=min(min(SWdem.Z))-100;
b=max(max(SWdem.Z))+100;
%% limites para ejemplo valle de la luna
figure(2)
subplot(2,1,1)
hold on
%   yyaxis left

plot(dem_distx_km,mean(SWdem.Z),'k-','LineWidth',2)
plot(dem_distx_km,max(SWdem.Z),'k-','LineWidth',0.4)
plot(dem_distx_km,min(SWdem.Z),'k-','LineWidth',0.4)
xlim([min(dem_distx_km), max(dem_distx_km)]);%,min(min(SWdem.Z)), max(max(SWdem.Z))])
xlabel('Distance [km]'); ylabel('Elevation [m a.s.l.]');
%title(['Swath profile (width= '+string(width)+' m).  Topography v/s  DInSAR: '+id]);
title(['Topography  and   DInSAR ('+string(id)+')  Swath Profile (width= '+string(width)+' m)']);
lgd=legend({'Mean swath elevation','σ elevation'},'Location','northeast');
%ylim([2370 2670]) % valle luna
%ylim([2360 2660]) % qda seca
%pbaspect([1 1 1])
% (2) plot the mean swath elevation +/- 1 standard deviation of the mean 
% elevations
subplot(2,1,2)
% figure(2)
 hold on
%   yyaxis right

plot(dinsar_distx_km,100*mean(SWdinsar.Z),'r-','LineWidth',1.6)
plot(dinsar_distx_km,100*mean(SWdinsar.Z)+100*std(SWdinsar.Z),'r-','LineWidth',0.01)
%plot(dinsar_distx_km,max(SWdinsar.Z),'r-','LineWidth',1)
plot(dinsar_distx_km,100*mean(SWdinsar.Z)-100*std(SWdinsar.Z),'r-','LineWidth',0.01)
% ylim([-0.096 -0.06])
 %ylim([-9.6 -8.0])
 ylim([-15 -4])
%plot(dinsar_distx_km,min(SWdinsar.Z),'b-','LineWidth',1)

xlim([min(dem_distx_km), max(dem_distx_km)]);
xlabel('Distance [km]'); ylabel('LOS VV displacement [cm]');
% lgd=legend({'Max swath elevation','Mean swath elevation','Min swath elevation','Mean VV LOS displacement','σ Mean VV LOS displacement'},'Location','northwest');
% LEGEND
% lgd=legend({'Mean VV displacement','σ Mean VV displacement','Max VV displacement'},'Location','northwest');
 lgd=legend({'Mean LOS VV displacement','σ LOS VV displacement'},'Location','northeast');
%lgd=legend({'Max Swath Elevation','Mean Swath Elevation','Min Swath Elevation','VV displacement InSAR','+σ VV displacement','-σ VV displacement'},'Location','northwest');
%pbaspect([1 1 2])
%% plot your swath topography B&w, using dots.now 

figure(4) %suitable for catarpe
hold on
plot(dem_distx_km,SWdem.Z,'ko','LineWidth',0.1,'MarkerSize',5);
plot(dem_distx_km,max(SWdem.Z),'k-','LineWidth',2,'MarkerSize',8);
%plot(dem_distx_km,mean(SWdem.Z),'k-','LineWidth',2,'MarkerSize',8);
plot(dem_distx_km,min(SWdem.Z),'b-','LineWidth',2);
xlim([min(dem_distx_km), max(dem_distx_km)]);
ylim([a b]);
%axis([min(dem_distx_km), max(dem_distx_km),min(min(SWdem.Z)), max(max(SWdem.Z))])
xlabel('Distance [km]'); ylabel('Elevation [m a.s.l.]');
title(['Swath profile width = '+string(width)]);
% LEGEND
lgd=legend({'Max Swath Elevation','Min Swath Elevation','Mean Swath Elevation'},'Location','northwest');
%% just black and white with lines
figure(5)
plot(dem_distx_km,max(SWdem.Z),'k--','LineWidth',1)
hold on
plot(dem_distx_km,mean(SWdem.Z),'k-','LineWidth',2)
plot(dem_distx_km,min(SWdem.Z),'k-','LineWidth',1)
%plot(distx_km,cero,'b-','LineWidth',0.5)
axis([min(dem_distx_km), max(dem_distx_km),min(min(SWdem.Z)), max(max(SWdem.Z))])
xlabel('Distance [km]'); ylabel('Elevation [m a.s.l.]');
title(['Swath profile width = '+string(width)]);
%ylim([500 6200]);
% LEGEND
lgd=legend({'Max Swath Elevation','Min Swath Elevation','Mean Swath Elevation'},'Location','northwest');

%% Plot the trace of your swath profile (including width)
figure(3)
imageschs(DEM);
hold on
plot(SWdem)  
hold off 

%% export line to shape
MSl = SWATHobj2gds(SWdem,'lines');
shapewrite(MSl,'swath_elbordosur.shp');

