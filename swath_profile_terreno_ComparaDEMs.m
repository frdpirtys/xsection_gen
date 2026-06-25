

%% SWATH PROFILES with TOPOTOOLBOX (must be installed first!)

% first lets clear the workspace, command window and close all figures
clear;
clc; %close all;
%% DEFINE WIDTH SWATH PROFILEs
width1= 100 %unit is meters
mode=2
KML_file= 'frenteCdSAl__XS__SUR01__10km.kml'

% do you need to flip this profile?  
% yes = 1 , no = 0
flip_profile = 0 ;

%% load DEM file with data


% %BASE DSM Pleiades

folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDSM\'; %   terraces\

%file='0b_CdSal_zonaNorte_DSM__Fmean_25.tif'
file='0b_CdSal_zonaNorte_PleiadesMix_DSM.tif'

%file='all_terraces_01.tif'

file='1_RiosGrandeSalado_DSM.tif'
%file='4_RioSanPedro_DSM.tif';
  file='3_Confluencia_DSM.tif'
% file='3_Confluencia_DSM__Fmean_25.tif'
%file='5_ValleLuna_DSM.tif';
%file='2_Machuca_DSM.tif'

Pleiades=append(folder,file)

% %BASE DEM ALOS PALSAR
ALOS30='D:\Dropbox\PEDRO\GIS\AtAcAmA\ALOS_DSM\Atacama_ALOS_30m_19S.tif'


% % copernico 30m
 COP30='D:\Dropbox\PEDRO\GIS\AtAcAmA\COP30\Atacama_COP30_19S.tif'

 
 %% run first, but only once
fprintf('loading DEMs..\n')

DEM1 = GRIDobj(Pleiades);
DEM2 = GRIDobj(ALOS30);
DEM3 = GRIDobj(COP30);
fprintf('!!!! ALL DEMs LOADED !!!!\n')

%%
%%
% create swath profile
fprintf('creating swath profile..\n')
width1
clear SW1
if mode == 1
    % Define UTM coordinates and width for Swath profile
    fprintf('When the map opens, single click to start the swath and double click to stop the swath.')
    fprintf('\n');
    SW1 = SWATHobj(DEM1,'width',width1);
    % Look at what your swath object contains.
    SW1
    % Note that it contains info about the coordinate endpoints you clicked
    % (xy0), the width of the swath, and the swath values (Z).
elseif mode==2
    fprintf('Importing data from KLM file.');
    fprintf('\n');
    KML_file
    [kml_xx,kml_yy,kml_zz]=read_kml(KML_file);
    
        
    if flip_profile==1
        kml_xx=flip(kml_xx);
        kml_yy=flip(kml_yy);
        kml_zz=flip(kml_zz);
        fprintf('--> Swath profile flipped <--');
        fprintf('\n');
    end
  
    
    %[utm_xx,utm_yy,utm_zones]=deg2utm(kml_yy,kml_xx);
    [utm_xx,utm_yy]=deg2utm_19fix(kml_yy,kml_xx);
    SW1 = SWATHobj(DEM1,utm_xx,utm_yy,'width',width1);
    SW2 = SWATHobj(DEM2,utm_xx,utm_yy,'width',width1);
    SW3 = SWATHobj(DEM3,utm_xx,utm_yy,'width',width1);
elseif mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SW1 = SWATHobj(DEM1,utm_xx,utm_yy,'width',width1);
end

distx_km=SW1.distx; %converting meters into km
cero=SW1.Z*0;


%%   first figure
%
fprintf('plotting Fig 1 \n');

figure((1))
hold on
title(''+ string(KML_file) + '        Swath width = ' + string(width1)) %  + 'm       Vertical exageration = ' + string(vx) + 'x')
plot(SW1.distx,SW1.Z,'k-','LineWidth',0.01)
plot(SW2.distx,SW2.Z,'r-','LineWidth',0.1)
plot(SW3.distx,SW3.Z,'b-','LineWidth',0.1)
xlim([0 10000])
%legend('Pleiades 1m','ALOS 30m','COP 30m')