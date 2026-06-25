% Strath terraces on Zorro de Catarpe Thrust, Cordillera de la Sal, Chile
% (c) Pedro Guzmán-Marín pedrasca@gmail.com
addpath 'D:\Dropbox\PEDRO\CdSal\codes'
%addpath 'D:\Dropbox\PEDRO\codes\SRTM_DEM_30m'
clear all;
close all;clc;

%%
% TOPO   = readtable('D:\Dropbox\PEDRO\CdSal\codes\Z_DSM_corrected_TOPO2matlab.xlsx');%csv');
% RIO    = readtable('D:\Dropbox\PEDRO\CdSal\codes\Z_DSM_corrected_RIO2matlab.csv');
% STRATH = readtable('D:\Dropbox\PEDRO\CdSal\codes\STRATH2matlab.csv');

TOPO   = readtable('TOPo_datos_2025filter05incision.xlsx');%'Z_DSM_corrected_TOPO2matlab.xlsx');%csv');
RIO    = readtable('Z_DSM_corrected_RIO2matlab.csv');
STRATH = readtable('STRATH2matlab.csv');

% INciSIoN= readtable('Z_strath_incision_vFeb2025_01.csv');%Z_strath_incision_DSM_corrected_TOPO2matlab.csv');
INciSIoN= readtable('TOPo_datos_2025filter03incision.xlsx')% __norte 'TOPo_datos_2025filter04incision__sur.xlsx');%
RIO.Zriverbed=RIO.Z_Strath_m-2460;

% KML_file='D:\Dropbox\PEDRO\CdSal\codes\xscatarpe.kml';
%KML_file= 'catarpeSur1808m.kml'% 'Catarpe__xs__incision__sur2__1600m.kml' %catarpe linea sur incisi
% 'tambores-catarpe-vilama2.kml
KML_file='catarpe3000.kml'%'Catarpe45km.kml'%CatarpeTambilloFault__01.kml'%catarpe17feb__01.kml'%'catarpe__exp_again.kml' % catarpe2025_exp02.kml'% %LINEA NORTE

KML_file='Catarpe4000_301225.kml' %'catarpe291225B_parallelIncision__23km.kml'%'Catarpe__291225__RioVilamaPozo6__18km.kml'%xs_Barranco__Catarpe__10km__giro5__parteE.kml'

%KML_file='xs__CatarpeQuitor__exitCdSal__4km.kml'
%KML_file='tambores-catarpe-vilama23.kml'
%'AltosPurilactis__QdaTambores__Quitor__44km.kml'
%catarpe2025__exp02__norte.kml'%
%rioSanPedroCatarpe.kml';
% 
%catarpe_experimento7.kml'%CATARPE_exp03.kml'%

width= 200; %ONLY FOR SWATH, unit is meters

% BASE DSM Pleiades
folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDSM\';
file='3_Confluencia_DSM.tif';
%file='3_Confluencia_DSM_mean_25_slope.tif'

% % BASE DEM Atacama
% folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\COP30\';
% file='Atacama_COP30_19S.tif';


%BASE mixDEM COP30 & DSM Pleiades
%  folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\mixDEM\'
%  file='CdSal__Pleiades__COP30__19S.tif'


%% LOAD DEM DATA. ONLY RUN ONCE

ruta=append(folder,file);
DEM = GRIDobj(ruta);

%% cReate swath profile!

fprintf('Importing data from KLM file.');
fprintf('\n');

[kml_xx,kml_yy,kml_zz]=read_kml(KML_file);

n_tramos=(length(kml_xx)-1)

if n_tramos>1
    Flag_tramos=1;
else
    Flag_tramos=0;
end

%% flip swath profile (optional)
% kml_xx=flip(kml_xx);
% kml_yy=flip(kml_yy);
% kml_zz=flip(kml_zz);
% fprintf('--> Swath profile flipped <--');
% fprintf('\n');




%% now! cReate swath profile!

fprintf('Creating Swath Profile!!');
fprintf('\n');

[utm_xx,utm_yy,utm_zones]=deg2utm(kml_yy,kml_xx);
%[utm_xx,utm_yy]=deg2utm_19fix(kml_yy,kml_xx);

SW1 = SWATHobj(DEM,utm_xx,utm_yy,'width',width);

dem_distx_km=SW1.distx; %converting meters into km

cero=SW1.Z*0;
a=min(min(SW1.Z))-100;
b=max(max(SW1.Z))+100;

cumulativeDist(1)=0;

if Flag_tramos==1
    cumulativeDist(1)=0;
    for i=2:n_tramos
        cumulativeDist(i)=cumulativeDist(i-1)+sqrt((abs(utm_xx(i)-utm_xx(i+1)))^(2)+(abs(utm_yy(i)-utm_yy(i+1))^(2)))
    end
end


fprintf('--> Swath profile ready <--');



%%   first figure
%

fprintf('plotting topography \n');

figure((width)); hold on

grid minor

plot(SW1.distx,SW1.Z,'k:','LineWidth',0.0001)

title(string(KML_file) + '             Swath width = ' + string(width) + 'm       Vertical exageration = ')% + string(vx) + 'x')
%% reproject data for topography

fprintf('projecting terrace topo data..');
fprintf('\n');



n=height(TOPO);
reproj_TOPO_aux=zeros(n,2);
TOPO_DistAlongPlane=zeros(n,1);
TOPO_perp_dist=zeros(n,1);

for i=1:n
    
    num_tramo=1%TOPO.tramo(i);
    [reproj_TOPO_aux(i,:),TOPO_DistAlongPlane(i,1), TOPO_perp_dist(i,1)] = projection([utm_xx(num_tramo),utm_yy(num_tramo)],[utm_xx(num_tramo+1),utm_yy(num_tramo+1)],[TOPO.X_UTM_East(i),TOPO.Y_UTM_North(i)]);
   % TOPO_DistAlongPlane(i,1)=TOPO_DistAlongPlane(i,1)+cumulativeDist(num_tramo);
end

reproj_TOPO=TOPO;

for i=1:n
    
    reproj_TOPO.X_UTM_East(i)=reproj_TOPO_aux(i,1);
    reproj_TOPO.Y_UTM_North(i)=reproj_TOPO_aux(i,2);
    
end
%TOPO_DistAlongPlane=TOPO_DistAlongPlane/1000; %converting meters into km












%% reproject data for river

fprintf('projecting river talweg data..');
fprintf('\n');

j=height(RIO);
reproj_rio_aux=zeros(j,2);
RIO_DistAlongPlane=zeros(j,1);
RIO_perp_dist=zeros(j,1);

for i=1:j
    %num_tramo=RIO.tramo(i);
    [reproj_rio_aux(i,:),RIO_DistAlongPlane(i,1), RIO_perp_dist(i,1)] = projection([utm_xx(num_tramo),utm_yy(num_tramo)],[utm_xx(num_tramo+1),utm_yy(num_tramo+1)],[RIO.X_UTM_East(i),RIO.Y_UTM_North(i)]);
    RIO_DistAlongPlane(i,1)=RIO_DistAlongPlane(i,1)+cumulativeDist(num_tramo);
end
reproj_RIO=RIO;
for i=1:j
    reproj_RIO.X_UTM_East(i)=reproj_rio_aux(i,1);
    reproj_RIO.Y_UTM_North(i)=reproj_rio_aux(i,2);
end
%RIO_DistAlongPlane=RIO_DistAlongPlane/1000; %converting meters into km








%% reproject data for strath in situ

fprintf('projecting in-situ strath data..');
fprintf('\n');
k=height(STRATH);
reproj_STRATH_aux=zeros(k,2);
STRATH_DistAlongPlane=zeros(k,1);
STRATH_perp_dist=zeros(k,1);
for i=1:k
    %num_tramo=STRATH.tramo(i);
    [reproj_STRATH_aux(i,:),STRATH_DistAlongPlane(i,1), STRATH_perp_dist(i,1)] = projection([utm_xx(num_tramo),utm_yy(num_tramo)],[utm_xx(num_tramo+1),utm_yy(num_tramo+1)],[STRATH.X_UTM_East(i),STRATH.Y_UTM_North(i)]);
    STRATH_DistAlongPlane(i,1)=STRATH_DistAlongPlane(i,1)+cumulativeDist(num_tramo);
end
reproj_STRATH=STRATH;
for i=1:k
    reproj_STRATH.X_UTM_East(i)=reproj_STRATH_aux(i,1);
    reproj_STRATH.Y_UTM_North(i)=reproj_STRATH_aux(i,2);
end
%STRATH_DistAlongPlane=STRATH_DistAlongPlane/1000; %converting meters into km




%% reproject data for Incision

fprintf('projecting incision data..');
fprintf('\n');

j=height(INciSIoN);
reproj_rio_aux=zeros(j,2);
INciSIoN_DistAlongPlane=zeros(j,1);
INciSIoN_perp_dist=zeros(j,1);

for i=1:j
    %num_tramo=INciSIoN.tramo(i);
    [reproj_rio_aux(i,:),INciSIoN_DistAlongPlane(i,1), INciSIoN_perp_dist(i,1)] = projection([utm_xx(num_tramo),utm_yy(num_tramo)],[utm_xx(num_tramo+1),utm_yy(num_tramo+1)],[INciSIoN.X_UTM_East(i),INciSIoN.Y_UTM_North(i)]);
    INciSIoN_DistAlongPlane(i,1)=INciSIoN_DistAlongPlane(i,1)+cumulativeDist(num_tramo);
end
reproj_INciSIoN=INciSIoN;
for i=1:j
    reproj_INciSIoN.X_UTM_East(i)=reproj_rio_aux(i,1);
    reproj_INciSIoN.Y_UTM_North(i)=reproj_rio_aux(i,2);
end
%INciSIoN_DistAlongPlane=INciSIoN_DistAlongPlane/1000; %converting meters into km












%% plot new projected points

figure(2)
title('Reprojected strath topo observations into  ->   ' + extractBefore(string(KML_file),".kml"));
hold on
axis equal
grid on
xlabel('UTM East [m]')
ylabel('UTM North [m]')

for i=1:n_tramos %plot projection lines
    plot([utm_xx(i),utm_xx(i+1)],[utm_yy(i),utm_yy(i+1)],'k-d','MarkerFaceColor','k','MarkerSize',6, 'LineWidth',1.2)
end

%plot projected points
plot(TOPO.X_UTM_East, TOPO.Y_UTM_North,'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',4)
plot(reproj_TOPO.X_UTM_East,reproj_TOPO.Y_UTM_North,'ko','MarkerFaceColor','r','MarkerSize',4);%, 'LineWidth',1)
plot(reproj_STRATH.X_UTM_East,reproj_STRATH.Y_UTM_North,'cd','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',4);%, 'LineWidth',1)
plot(reproj_RIO.X_UTM_East,reproj_RIO.Y_UTM_North,'bd','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',4);%, 'LineWidth',1)

legend('Simplified fault','Reprojection line','Filling observations','Reprojected points')
hold off


%% truco agregado 13.07.2023 before INQUA
% reproj_TOPO.Z_Strath_m(93) = 2.485018594000000e+03;
% reproj_TOPO.Z_Strath_m(94) = 2.484337576000000e+03;





%%
%    plot strath, all topo + strath in-situ + riverbed
%

figure(width+3) ; hold on

plot(SW1.distx,SW1.Z,'k:','LineWidth',0.00000000001)%,'MarkerSize',1);

% plot(dem_distx_km,mean(SW1.Z),'k-','LineWidth',1.5);
% plot(dem_distx_km,min(SW1.Z),'b-','LineWidth',1.8)
% plot(dem_distx_km,SW1.Z,'ko','LineWidth',0.01,'MarkerSize',1);

% LEGEND
%lgd=legend({'Max Swath Elevation','Min Swath Elevation','Cave talweg','Filling 1 Cave','Filling 2 Cave'},'Location','northwest');



title('Elevation of strath terraces (vx10)');

ylabel('Altitude [m a.s.l.]')
xlabel('River talweg distance [m]')

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



%Plot TOPO measurements terraces
for i=1:n 
    if strcmp(reproj_TOPO.bloque(i),'techo')        
        if reproj_TOPO.Qt_id(i)==1
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerSize',6);
        end
    elseif strcmp(reproj_TOPO.bloque(i),'muro')
        if reproj_TOPO.Qt_id(i)==1
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerSize',6);
        end
    else
        if reproj_TOPO.Qt_id(i)==1
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_Strath_m(i), 'ko','MarkerSize',6);
        end
    end
end

clear i

%Plot STRATH in-situ measurements
for i=1:k 
    if reproj_STRATH.Qt_id(i)==1
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i),'ks','MarkerFaceColor','m','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==2
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i),'ks','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==3
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==4
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor','r','MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==5
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
    elseif reproj_STRATH.Qt_id(i)==6
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
    else
        plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_Strath_m(i), 'ks','MarkerSize',6);
    end
end



ylim([2350 2630])

grid minor

hold off


 %   plot(STRATH_DistAlongPlane , reproj_STRATH.Z_Strath_m, 'rd','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
%legend('Cave talweg','Filling 1 Cave','Filling 2 Cave')
%xlim([140 340])

ylim([2450 2730])
%xlim([min(RIO_DistAlongPlane) 5650])
 xlim([-1000 5500])





%%
%    plot strath, all topo + strath in-situ + riverbed
%

figure(33) ; hold on

plot(SW1.distx,SW1.Z,'k:','LineWidth',0.00000000001)%,'MarkerSize',1);

% plot(dem_distx_km,mean(SW1.Z),'k-','LineWidth',1.5);
% plot(dem_distx_km,min(SW1.Z),'b-','LineWidth',1.8)
% plot(dem_distx_km,SW1.Z,'ko','LineWidth',0.01,'MarkerSize',1);

% LEGEND
%lgd=legend({'Max Swath Elevation','Min Swath Elevation','Cave talweg','Filling 1 Cave','Filling 2 Cave'},'Location','northwest');



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



%Plot TOPO measurements terraces
for i=1:n 
    if strcmp(reproj_TOPO.bloque(i),'techo')        
        if reproj_TOPO.Qt_id(i)==1
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor','m','MarkerSize',6);
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerSize',6);
        end
    elseif strcmp(reproj_TOPO.bloque(i),'muro')
        if reproj_TOPO.Qt_id(i)==1
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerSize',6);
        end
    else
        if reproj_TOPO.Qt_id(i)==1
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==2
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==3
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==4
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_TOPO.Qt_id(i)==5
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_TOPO.Qt_id(i)==6
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(TOPO_DistAlongPlane(i), reproj_TOPO.Z_hStrath(i), 'ko','MarkerSize',6);
        end
    end
end

clear i

%Plot STRATH in-situ measurements
% for i=1:k 
%     if reproj_STRATH.Qt_id(i)==1
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i),'ks','MarkerFaceColor','m','MarkerSize',6);
%     elseif reproj_STRATH.Qt_id(i)==2
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i),'ks','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
%     elseif reproj_STRATH.Qt_id(i)==3
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i), 'ks','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
%     elseif reproj_STRATH.Qt_id(i)==4
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i), 'ks','MarkerFaceColor','r','MarkerSize',6);
%     elseif reproj_STRATH.Qt_id(i)==5
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i), 'ks','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
%     elseif reproj_STRATH.Qt_id(i)==6
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i), 'ks','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
%     else
%         plot(STRATH_DistAlongPlane(i), reproj_STRATH.Z_hStrath(i), 'ks','MarkerSize',6);
%     end
% end



ylim([2350 2630])

grid minor

hold off



ylim([2450 2730])

xlim([-1000 5500])


%% plot INCISION ALONG PROFILE, 
figure(636)
hold on

% plot(dem_distx_km,(SW1.Z-2000)/25,'k:','LineWidth',0.01,'MarkerSize',1);
plot(dem_distx_km,SW1.Z,'k:','LineWidth',0.01,'MarkerSize',1);

%plot(dem_distx_km,max(SW1.Z-2500)/4,'k-','LineWidth',1,'MarkerSize',1);
% plot(dem_distx_km,mean(SW1.Z),'k-','LineWidth',1.5);
%plot(dem_distx_km,min(SW1.Z-2500)/4,'b-','LineWidth',1.8)


grid minor
xlabel('Distance [km]'); ylabel('Incision');
title(['Swath profile width = '+string(width)]);
% LEGEND
%lgd=legend({'Max Swath Elevation','Min Swath Elevation','Cave talweg','Filling 1 Cave','Filling 2 Cave'},'Location','northwest');

%plot(dem_distx_km,SW1.Z,'ko','LineWidth',0.01,'MarkerSize',1);

hold on
title('Net incision along river channel, elevation of strath terraces over riverbed');
ylabel('Net Incision [m above riverbed?]')
xlabel('River talweg distance [km]')

% plot(RIO_DistAlongPlane,reproj_RIO.Zriverbed,'b-', 'LineWidth',2);
% plot(dem_distx_km,min(SW1.Z-2460),'b-','LineWidth',1.8)
clear i

plot(RIO_DistAlongPlane,reproj_RIO.Z_Strath_m,'b-', 'LineWidth',2);


for i=1:j %Plot INciSIoN measurements
    if reproj_INciSIoN.Qt_id(i)==1
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)),'ko','MarkerFaceColor','m','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==2
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==3
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==4
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)), 'ko','MarkerFaceColor','r','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==5
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)), 'ko','MarkerFaceColor',[254/255 255/255 0/255],'MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==6
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
    else
        plot(INciSIoN_DistAlongPlane(i), (3000+5*reproj_INciSIoN.incision_m(i)), 'ko','MarkerSize',6);
    end
end

grid minor

%% plot INCISION ALONG PROFILE, 
figure(444)
hold on
%plot(dem_distx_km,(SW1.Z-2000)/25,'k:','LineWidth',0.01,'MarkerSize',1);
%plot(dem_distx_km,max(SW1.Z-2500)/4,'k-','LineWidth',1,'MarkerSize',1);
% plot(dem_distx_km,mean(SW1.Z),'k-','LineWidth',1.5);
%plot(dem_distx_km,min(SW1.Z-2500)/4,'b-','LineWidth',1.8)

%grid ON
xlabel('Distance [km]'); ylabel('Incision');
title(['Swath profile width = '+string(width)]);
% LEGEND
%lgd=legend({'Max Swath Elevation','Min Swath Elevation','Cave talweg','Filling 1 Cave','Filling 2 Cave'},'Location','northwest');

%plot(dem_distx_km,SW1.Z,'ko','LineWidth',0.01,'MarkerSize',1);


title('Net incision along river channel, elevation of strath terraces over riverbed');
ylabel('Net Incision [m above riverbed?]')
xlabel('River talweg distance [km]')

% plot(RIO_DistAlongPlane,reproj_RIO.Zriverbed,'b-', 'LineWidth',2);
% plot(dem_distx_km,min(SW1.Z-2460),'b-','LineWidth',1.8)
clear i

for i=1:j %Plot INciSIoN measurements
    if reproj_INciSIoN.Qt_id(i)==1
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==2
       plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==3
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==4
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==5
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[255/255 255/255 0/255],'MarkerSize',6);
    elseif reproj_INciSIoN.Qt_id(i)==6
        plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
    else
       % plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerSize',6);
    end
end

ylim([00000 400])
xlim([00000 5000])

yticks([ 0 10 20 30 40 50 60 70 80 90 100])

%%
%  PLOT INCISION ALONG LINE

figure(11)
% 'ko','MarkerFaceColor',[1 0 0],
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
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'k^','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',8);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor','r','MarkerSize',8);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',8);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerSize',8);
        end
    elseif strcmp(reproj_INciSIoN.bloque(i),'muro')
        if reproj_INciSIoN.Qt_id(i)==1
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'kv','MarkerFaceColor','m','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'kv','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',8);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor','r','MarkerSize',8);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',8);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerSize',8);
        end
    else
        if reproj_INciSIoN.Qt_id(i)==1
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerSize',6);
        end
    end
end

%%
%  PLOT INCISION ALONG LINE log scale

figure(12)

hold on
grid minor
title('Net incision along river channel, elevation of strath terraces over riverbed');
ylabel('log scale incision [m above riverbed]')
xlabel('River talweg distance [km]')
for i=1:j %Plot INciSIoN measurements terraces
    if strcmp(reproj_INciSIoN.bloque(i),'techo')        
        if reproj_INciSIoN.Qt_id(i)==1
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'k^','MarkerFaceColor','m','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'k^','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',8);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor','r','MarkerSize',8);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',8);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k^','MarkerSize',8);
        end
    elseif strcmp(reproj_INciSIoN.bloque(i),'muro')
        if reproj_INciSIoN.Qt_id(i)==1
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'kv','MarkerFaceColor','m','MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'kv','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',8);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor','r','MarkerSize',8);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',8);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',8);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'kv','MarkerSize',8);
        end
    else
        if reproj_INciSIoN.Qt_id(i)==1
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor','m','MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==2
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i),'ko','MarkerFaceColor',[20/255 20/255 255/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==3
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
            %plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'k*','MarkerFaceColor',[26/255 255/255 26/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==4
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor','r','MarkerSize',6);
        elseif  reproj_INciSIoN.Qt_id(i)==5
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[254/255 97/255 0/255],'MarkerSize',6);
        elseif reproj_INciSIoN.Qt_id(i)==6
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerFaceColor',[255/255 170/255 0/255],'MarkerSize',6);
        else
            plot(INciSIoN_DistAlongPlane(i), reproj_INciSIoN.incision_m(i), 'ko','MarkerSize',6);
        end
    end
end


set(gca, 'YScale', 'log')