% SanPedro S0 accross Zorro de Catarpe Thrust, Cordillera de la Sal, Chile
% (c) Pedro Guzmán-Marín pedrasca@gmail.com
clear all;clc; %close all;
%%

% DATOS ESTRUCTURALES
 structur= readtable('D:\Dropbox\PEDRO\CdSal\codes\stereonet_Barrancos.xlsx');

%structur=readtable('D:\Dropbox\PEDRO\CdSal\FaultKin\Stereonet\S0_compiladoFinal__PGM.xlsx')
%structur= readtable('D:\Dropbox\PEDRO\CdSal\codes\stereonet_Catarpe_east.xlsx');
fault=readtable('D:\Dropbox\PEDRO\CdSal\codes\faultkin2matlab_Barrancos.xlsx');


% [structur.X_UTM_East, structur.Y_UTM_North,structur.UTM_Zone]=deg2utm(structur.y_latitude,structur.x_longitude);
%%

% TOPOGRAPHIC SWATH WIDTH (in meters!)
width=200 


% Structur SWATH WIDTH (in kilometers!)
structurDist2XS= 300


% LENGTH of Xbase for S0/fault plane projection
base= 20; % unit is meters


%%

%KML_file='xs_Barranco__Catarpe__10km__giro5.kml'% catarpe2025_exp02.kml'
%'BarrancoNorte__03__1000m.kml'%
KML_file='barrancos_catarpe.kml'
id=('Catarpe thrust');

%BASE DEM Atacama
folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\COP30\';
file='Atacama_COP30_19S.tif';

% BASE DEM Pleiades
%folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDSM\';
%file='3_Confluencia_DSM.tif';

% folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\mixDEM\'
% %file='CdSal__Pleiades__COP30__19S.tif'
% file='CdSal__Pleiades__COP30__19S.tif' % requires 17 GB RAM

%DATOS TERRAZAS
TOPO   = readtable('D:\Dropbox\PEDRO\CdSal\codes\TOPO2matlab.csv');
RIO    = readtable('D:\Dropbox\PEDRO\CdSal\codes\RIO2matlab.csv');
STRATH = readtable('D:\Dropbox\PEDRO\CdSal\codes\STRATH2matlab.csv');


%% LOAD DEM. ONLY RUN ONCE
ruta=append(folder,file);
DEM = GRIDobj(ruta);
%% cReate swath profile!
fprintf('Importing data from KLM file.');
fprintf('\n');
[kml_xx,kml_yy,kml_zz]=read_kml(KML_file);
[utm_xx,utm_yy,utm_zones]=deg2utm(kml_yy,kml_xx);
%[utm_xx,utm_yy]=deg2utm_19fix(kml_yy,kml_xx);
SWdem = SWATHobj(DEM,utm_xx,utm_yy,'width',width);


dem_distx_m=SWdem.distx;

cero=SWdem.Z*0;
a=min(min(SWdem.Z))-100;
b=max(max(SWdem.Z))+100;
OrthoLine_start=[utm_xx(1),utm_yy(1)];
OrthoLine_end=[utm_xx(2),utm_yy(2)];

% REPROJECT DATA TO LINE
%% reproject structural data
fprintf('projecting structural data..');
fprintf('\n');
n=height(structur);
reproj_STRUCTUR_aux=zeros(n,2);
STRUCTUR_DistAlongPlane=zeros(n,1);
STRUCTUR_perp_dist=zeros(n,1);
for i=1:n
    [reproj_STRUCTUR_aux(i,:),STRUCTUR_DistAlongPlane(i,1), STRUCTUR_perp_dist(i,1)] = projection(OrthoLine_start,OrthoLine_end,[structur.X_UTM_East(i),structur.Y_UTM_North(i)]);
end
reproj_structur=structur;
for i=1:n
    reproj_structur.X_UTM_East(i)=reproj_STRUCTUR_aux(i,1);
    reproj_structur.Y_UTM_North(i)=reproj_STRUCTUR_aux(i,2);
end

%% reproject FAULTal data
fprintf('projecting FAULT data..');
fprintf('\n');
n=height(fault);
reproj_FAULT_aux=zeros(n,2);
FAULT_DistAlongPlane=zeros(n,1);
FAULT_perp_dist=zeros(n,1);
for i=1:n
    [reproj_FAULT_aux(i,:),FAULT_DistAlongPlane(i,1), FAULT_perp_dist(i,1)] = projection(OrthoLine_start,OrthoLine_end,[fault.X_UTM_East(i),fault.Y_UTM_North(i)]);
end
reproj_fault=fault;
for i=1:n
    reproj_FAULT.X_UTM_East(i)=reproj_FAULT_aux(i,1);
    reproj_FAULT.Y_UTM_North(i)=reproj_FAULT_aux(i,2);
end


%% calcular rumbo perfil
dx=utm_xx(2)-utm_xx(1);
dy=utm_yy(1)-utm_yy(2); %ojo aqui, y aumenta hacia el norte
phi=atand(dx/dy);
rumbo_xs=180-phi;

% manteo aparente datos y efectuar proyeccion en perfil
reproj_structur.difStrk=abs((reproj_structur.strike)-rumbo_xs);

for i=1:length(reproj_structur.dip)
    reproj_structur.ApDip(i)=atand(tand(reproj_structur.dip(i))*sind(reproj_structur.difStrk(i)));

end
for i=1:length(reproj_structur.dip)
    reproj_structur.planoZ1(i)=reproj_structur.Z(i)-base*tand(reproj_structur.ApDip(i));
    reproj_structur.planoX1(i)=STRUCTUR_DistAlongPlane(i)-base;
    reproj_structur.planoZ2(i)=reproj_structur.Z(i)+(base)*tand(reproj_structur.ApDip(i));
    reproj_structur.planoX2(i)=STRUCTUR_DistAlongPlane(i)+(base);
end

% manteo aparente fallas y efectuar proyeccion en perfil

reproj_fault.difStrk=abs((reproj_fault.strike)-rumbo_xs);

for i=1:length(reproj_fault.dip)
    reproj_fault.ApDip(i)=atand(tand(reproj_fault.dip(i))*sind(reproj_fault.difStrk(i)));
end

for i=1:length(reproj_fault.dip)
    reproj_fault.planoZ1(i)=reproj_fault.Z(i)-base*tand(reproj_fault.ApDip(i));
    reproj_fault.planoX1(i)=FAULT_DistAlongPlane(i)-base;
    reproj_fault.planoZ2(i)=reproj_fault.Z(i)+(base/2)*tand(reproj_fault.ApDip(i));
    reproj_fault.planoX2(i)=FAULT_DistAlongPlane(i)+base/2;
end
%%
figure(width+1)
hold on
plot(dem_distx_m,SWdem.Z,'k:','LineWidth',0.00000001,'MarkerSize',0.1);
% plot(dem_distx_m,max(SWdem.Z),'b-','LineWidth',1,'MarkerSize',8);
% plot(dem_distx_m,mean(SWdem.Z),'k-','LineWidth',1,'MarkerSize',8);
% plot(dem_distx_m,min(SWdem.Z),'k--','LineWidth',1,'MarkerSize',8);
for i=1:length(reproj_structur.dip) %Plot S0 measurements
    if abs(STRUCTUR_perp_dist(i))<=(structurDist2XS)
        plot([reproj_structur.planoX1(i), reproj_structur.planoX2(i)],[reproj_structur.planoZ1(i), reproj_structur.planoZ2(i)],'k-','LineWidth',1,'MarkerSize',8);
    end
end
for i=1:length(reproj_fault.dip) %Plot faults in red
    plot([reproj_fault.planoX1(i), reproj_fault.planoX2(i)],[reproj_fault.planoZ1(i), reproj_fault.planoZ2(i)],'r-','LineWidth',2,'MarkerSize',8);
end
%%
figure(width+11)
hold on
plot(dem_distx_m,SWdem.Z,'k-','LineWidth',0.1,'MarkerSize',8);
%plot(dem_distx_m,mean(SWdem.Z),'k-','LineWidth',1,'MarkerSize',8);
%plot(dem_distx_m,min(SWdem.Z),'k--','LineWidth',1,'MarkerSize',8);
for i=1:length(reproj_structur.dip) %Plot S0 measurements
    plot([reproj_structur.planoX1(i), reproj_structur.planoX2(i)],[reproj_structur.planoZ1(i), reproj_structur.planoZ2(i)],'k-','LineWidth',1,'MarkerSize',8);
end
for i=1:length(reproj_fault.dip) %Plot faults in red
    plot([reproj_fault.planoX1(i), reproj_fault.planoX2(i)],[reproj_fault.planoZ1(i), reproj_fault.planoZ2(i)],'r-','LineWidth',2,'MarkerSize',8);
end
%%
figure(2)
hold on
plot(dem_distx_m,SWdem.Z,'k:','LineWidth',0.00001,'MarkerSize',1);
% plot(dem_distx_m,mean(SWdem.Z),'k-','LineWidth',1,'MarkerSize',8);
% plot(dem_distx_m,min(SWdem.Z),'k--','LineWidth',1,'MarkerSize',8);
for i=1:length(reproj_structur.dip) %Plot TOPO measurements terraces
    plot([reproj_structur.planoX1(i), reproj_structur.planoX2(i)],[reproj_structur.planoZ1(i), reproj_structur.planoZ2(i)],'b-','LineWidth',1,'MarkerSize',8);
end
for i=1:length(reproj_fault.dip) %Plot faults in red
    plot([reproj_fault.planoX1(i), reproj_fault.planoX2(i)],[reproj_fault.planoZ1(i), reproj_fault.planoZ2(i)],'r-','LineWidth',1.2,'MarkerSize',8);
end
plot(FAULT_DistAlongPlane,reproj_fault.Z,'k+')
plot(STRUCTUR_DistAlongPlane,reproj_structur.Z,'b+')
% escala horizontal vs vertical
TOPObase=1200  % definido por usuario
vx=1        % vertical exageration 2x imply vx=2; 3x imply vx=3; ...
max_horizontal=max(SWdem.distx);
ylim([TOPObase (TOPObase+(max_horizontal/vx))]);
xlim([0 max_horizontal]);


