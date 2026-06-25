% Strath terraces on Zorro de Catarpe Thrust, Cordillera de la Sal, Chile
% (c) Pedro Guzmán-Marín pedrasca@gmail.com
addpath 'D:\Dropbox\PEDRO\CdSal\codes'
%addpath 'D:\Dropbox\PEDRO\codes\SRTM_DEM_30m'
clear all;%close all;clc;

%%
TOPO   = readtable('D:\Dropbox\PEDRO\CdSal\codes\Z_DSM_corrected_TOPO2matlab.xlsx');%csv');
RIO    = readtable('D:\Dropbox\PEDRO\CdSal\codes\Z_DSM_corrected_RIO2matlab.csv');
STRATH = readtable('D:\Dropbox\PEDRO\CdSal\codes\STRATH2matlab.csv');
INciSIoN= readtable('Z_strath_incision_DSM_corrected_TOPO2matlab.csv');

RIO.Zriverbed=RIO.Z_Strath_m-2460;


%BASE DSM Pleiades
folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDSM\'; %   terraces\
file='3_Confluencia_DSM.tif'


%% Define swath input mode
%  3 different inputs of profile points

mode = 2

KML_file='catarpe2025_exp01.kml'%rioSanPedroCatarpe.kml';


width= 200; %ONLY FOR SWATH, unit is meters


%% LOAD DEM DATA. ONLY RUN ONCE

ruta=append(folder,file);
DEM = GRIDobj(ruta);


%% cReate swath profile!

fprintf('Importing data from KLM file.');
fprintf('\n');

[kml_xx,kml_yy,kml_zz]=read_kml(KML_file);


%% now! cReate swath profile!
[utm_xx,utm_yy,utm_zones]=deg2utm(kml_yy,kml_xx);
%[utm_xx,utm_yy]=deg2utm_19fix(kml_yy,kml_xx);
SWdem = SWATHobj(DEM,utm_xx,utm_yy,'width',width);

%SWdinsar = SWATHobj(DInSAR,utm_xx,utm_yy,'width',width);

dem_distx_km=SWdem.distx/1000; %converting meters into km
%dinsar_distx_km=SWdinsar.distx/1000; %converting meters into km
% cero=SWdem.Z*0;
% a=min(min(SWdem.Z))-100;
% b=max(max(SWdem.Z))+100;
OrthoLine_start=[utm_xx(1),utm_yy(1)];
OrthoLine_end=[utm_xx(2),utm_yy(2)];



%% reproject data for topography
fprintf('projecting terrace topo data..');
fprintf('\n');
n=height(TOPO);
reproj_strath_aux=zeros(n,2);
TOPO_DistAlongPlane=zeros(n,1);
TOPO_perp_dist=zeros(n,1);
for i=1:n
    [reproj_strath_aux(i,:),TOPO_DistAlongPlane(i,1), TOPO_perp_dist(i,1)] = projection(OrthoLine_start,OrthoLine_end,[TOPO.X_UTM_East(i),TOPO.Y_UTM_North(i)]);
end
reproj_TOPO=TOPO;
for i=1:n
    reproj_TOPO.X_UTM_East(i)=reproj_strath_aux(i,1);
    reproj_TOPO.Y_UTM_North(i)=reproj_strath_aux(i,2);
end
TOPO_DistAlongPlane=TOPO_DistAlongPlane/1000; %converting meters into km

%% reproject data for river
fprintf('projecting river talweg data..');
j=height(RIO);
reproj_rio_aux=zeros(j,2);
RIO_DistAlongPlane=zeros(j,1);
RIO_perp_dist=zeros(j,1);
for i=1:j
    [reproj_rio_aux(i,:),RIO_DistAlongPlane(i,1), RIO_perp_dist(i,1)] = projection(OrthoLine_start,OrthoLine_end,[RIO.X_UTM_East(i),RIO.Y_UTM_North(i)]);
end
reproj_RIO=RIO;
for i=1:j
    reproj_RIO.X_UTM_East(i)=reproj_rio_aux(i,1);
    reproj_RIO.Y_UTM_North(i)=reproj_rio_aux(i,2);
end
RIO_DistAlongPlane=RIO_DistAlongPlane/1000; %converting meters into km

% reproject data for strath in situ
k=height(STRATH);
reproj_STRATH_aux=zeros(k,2);
STRATH_DistAlongPlane=zeros(k,1);
STRATH_perp_dist=zeros(k,1);
for i=1:k
    [reproj_STRATH_aux(i,:),STRATH_DistAlongPlane(i,1), STRATH_perp_dist(i,1)] = projection(OrthoLine_start,OrthoLine_end,[STRATH.X_UTM_East(i),STRATH.Y_UTM_North(i)]);
end
reproj_STRATH=STRATH;
for i=1:k
    reproj_STRATH.X_UTM_East(i)=reproj_STRATH_aux(i,1);
    reproj_STRATH.Y_UTM_North(i)=reproj_STRATH_aux(i,2);
end
STRATH_DistAlongPlane=STRATH_DistAlongPlane/1000; %converting meters into km

%% reproject data for Incision

fprintf('projecting incision data..');
fprintf('\n');

j=height(INciSIoN);
reproj_rio_aux=zeros(j,2);
INciSIoN_DistAlongPlane=zeros(j,1);
INciSIoN_perp_dist=zeros(j,1);

for i=1:j
    num_tramo=INciSIoN.tramo(i);
    [reproj_rio_aux(i,:),INciSIoN_DistAlongPlane(i,1), INciSIoN_perp_dist(i,1)] = projection([utm_xx(1),utm_yy(1)],[utm_xx(2),utm_yy(2)],[INciSIoN.X_UTM_East(i),INciSIoN.Y_UTM_North(i)]);
    end
reproj_INciSIoN=INciSIoN;
for i=1:j
    reproj_INciSIoN.X_UTM_East(i)=reproj_rio_aux(i,1);
    reproj_INciSIoN.Y_UTM_North(i)=reproj_rio_aux(i,2);
end
INciSIoN_DistAlongPlane=INciSIoN_DistAlongPlane/1000; %converting meters into km



%% plot new projected points

figure(11)
title('Reprojected strath observations into riverbed');
hold on
axis equal
grid on
xlabel('UTM East')
ylabel('UTM North')

% for i=1:n_tramos %plot projection lines
%     plot([utm_xx(i),utm_xx(i+1)],[utm_yy(i),utm_yy(i+1)],'k-d','MarkerFaceColor','k','MarkerSize',6, 'LineWidth',1.2)
% end

%plot projected points
plot(TOPO.X_UTM_East, TOPO.Y_UTM_North,'ko','MarkerFaceColor','g','MarkerSize',4)
plot(reproj_TOPO.X_UTM_East,reproj_TOPO.Y_UTM_North,'ko','MarkerFaceColor','r','MarkerSize',4);%, 'LineWidth',1)
plot(reproj_STRATH.X_UTM_East,reproj_STRATH.Y_UTM_North,'cd','MarkerFaceColor','c','MarkerSize',4);%, 'LineWidth',1)
plot(reproj_RIO.X_UTM_East,reproj_RIO.Y_UTM_North,'bd','MarkerFaceColor','b','MarkerSize',4);%, 'LineWidth',1)

legend('Simplified fault','Reprojection line','Filling observations','Reprojected points')
hold off



%% truco agregado 13.07.2023 before INQUA
reproj_TOPO.Z_Strath_m(93) = 2.485018594000000e+03;
reproj_TOPO.Z_Strath_m(94) = 2.484337576000000e+03;
%% plot toda la wea
figure(22)
hold on
%plot(dem_distx_km,SWdem.Z,'k:','LineWidth',0.01,'MarkerSize',1);
% plot(dem_distx_km,mean(SWdem.Z),'k-','LineWidth',1.5);
plot(dem_distx_km,min(SWdem.Z),'b-','LineWidth',1.8)


xlabel('Distance [km]'); ylabel('Elevation [m a.s.l.]');
title(['Swath profile width = '+string(width)]);
% LEGEND
%lgd=legend({'Max Swath Elevation','Min Swath Elevation','Cave talweg','Filling 1 Cave','Filling 2 Cave'},'Location','northwest');

%plot(dem_distx_km,SWdem.Z,'ko','LineWidth',0.01,'MarkerSize',1);

hold on
title('Elevation of strath terraces (vx10)');
ylabel('Altitude [m a.s.l.]')
xlabel('River talweg distance [km]')
plot(RIO_DistAlongPlane,reproj_RIO.Z_Strath_m,'b-', 'LineWidth',2);

% 'o'	Círculo
% '+'	Signo más
% '*'	Asterisco
% '.'	Punto
% 'x'	Cruz
% 'square' o 's'	Cuadrado
% 'diamond' o 'd'	Rombo
% '^'	Triángulo hacia arriba
% 'v'	Triángulo hacia abajo
% '>'	Triángulo hacia la derecha
% '<'	Triángulo hacia la izquierda
% 'pentagram' o 'p'	Estrella de cinco puntas (pentagrama)
% 'hexagram' o 'h'	Estrella de seis puntas (hexagrama)
% 'none'	Sin marcadores


% for i=1:n %Plot TOPO measurements terraces
%     if reproj_TOPO.Qt_id(i)==1
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'kv','MarkerFaceColor','m','MarkerSize',6);
%     elseif reproj_TOPO.Qt_id(i)==2
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'kv','MarkerFaceColor','b','MarkerSize',6);
%     elseif reproj_TOPO.Qt_id(i)==3
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'kv','MarkerFaceColor','c','MarkerSize',6);
%         %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
%     elseif reproj_TOPO.Qt_id(i)==4
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'kv','MarkerFaceColor','r','MarkerSize',6);
%     elseif reproj_TOPO.Qt_id(i)==5
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'kv','MarkerFaceColor','g','MarkerSize',6);
%     elseif reproj_TOPO.Qt_id(i)==6
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'kv','MarkerFaceColor','y','MarkerSize',6);
%     else
%         plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'kv','MarkerSize',6);
%     end
% end


for i=1:n %Plot TOPO measurements terraces
    if strcmp(reproj_TOPO.bloque(i),'techo')        
        if reproj_TOPO.Qt_id(i)==1
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','b','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','c','MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','g','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','y','MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerSize',6);
        end
    elseif strcmp(reproj_TOPO.bloque(i),'muro')
        if reproj_TOPO.Qt_id(i)==1
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','b','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','c','MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','g','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','y','MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerSize',6);
        end
    else
        if reproj_TOPO.Qt_id(i)==1
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','b','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','c','MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','g','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','y','MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerSize',6);
        end
    end
end

%%
%figure(33)
hold on
clear i
for i=1:k %Plot STRATH in-situ measurements
    if reproj_STRATH.Qt_id(i)==1
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i),'ks','MarkerFaceColor','m','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==2
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i),'ks','MarkerFaceColor','b','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==3
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor','c','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==4
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor','r','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==5
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor','g','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==6
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor','y','MarkerSize',6);
    else
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerSize',6);
    end
end

 %   plot(STRATH_DistAlongPlane , reproj_STRATH.Z_Strath_m, 'rd','MarkerFaceColor','g','MarkerSize',6);
%legend('Cave talweg','Filling 1 Cave','Filling 2 Cave')
%xlim([140 340])
ylim([2350 2630])
%ylim([2400 2730])
%xlim([min(RIO_DistAlongPlane) 5.65])
xlim([0 5.5])


grid on

hold off


%% plot toda la wea
figure(33)
hold on
%plot(dem_distx_km,SWdem.Z,'k:','LineWidth',0.01,'MarkerSize',1);
% plot(dem_distx_km,mean(SWdem.Z),'k-','LineWidth',1.5);
%plot(dem_distx_km,min(SWdem.Z),'b-','LineWidth',1.8)

grid minor
xlabel('Distance [km]'); ylabel('Incision');
title(['Swath profile width = '+string(width)]);
% LEGEND
%lgd=legend({'Max Swath Elevation','Min Swath Elevation','Cave talweg','Filling 1 Cave','Filling 2 Cave'},'Location','northwest');

%plot(dem_distx_km,SWdem.Z,'ko','LineWidth',0.01,'MarkerSize',1);

hold on
title('Net incision along river channel, elevation of strath terraces over riverbed');
ylabel('Net Incision [m above riverbed?]')
xlabel('River talweg distance [km]')

% plot(RIO_DistAlongPlane,reproj_RIO.Zriverbed,'b-', 'LineWidth',2);
% plot(dem_distx_km,min(SWdem.Z-2460),'b-','LineWidth',1.8)
clear i

for i=1:j %Plot INciSIoN measurements
    if reproj_INciSIoN.Qt_id(i)==1
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==2
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','b','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==3
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','c','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==4
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==5
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','g','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==6
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','y','MarkerSize',6);
    else
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerSize',6);
    end
end

%%
figure(44)

hold on
grid minor
title('Net incision along river channel, elevation of strath terraces over riverbed');
ylabel('Net Incision [m above riverbed]')
xlabel('River talweg distance [km]')
for i=1:j %Plot INciSIoN measurements terraces
    if strcmp(reproj_INciSIoN.bloque(i),'techo')        
        if reproj_INciSIoN.Qt_id(i)==1
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'k^','MarkerFaceColor','m','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'k^','MarkerFaceColor','b','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor','c','MarkerSize',8);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor','r','MarkerSize',8);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor','g','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor','y','MarkerSize',8);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerSize',8);
        end
    elseif strcmp(reproj_INciSIoN.bloque(i),'muro')
        if reproj_INciSIoN.Qt_id(i)==1
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'kv','MarkerFaceColor','m','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'kv','MarkerFaceColor','b','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor','c','MarkerSize',8);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor','r','MarkerSize',8);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor','g','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor','y','MarkerSize',8);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerSize',8);
        end
    else
        if reproj_INciSIoN.Qt_id(i)==1
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','b','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','c','MarkerSize',6);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor','c','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','g','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','y','MarkerSize',6);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerSize',6);
        end
    end
end


