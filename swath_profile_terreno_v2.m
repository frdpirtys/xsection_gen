%% SWATH PROFILES with TOPOTOOLBOX (must be installed first!)

% first lets clear the workspace, command window and close all figures
%clear;
clc;
close all;


%% DEFINE WIDTH SWATH PROFILEs
width1= 100 %unit is meters

width2= 010
width3= 400
width4= 020

%% load DEM file with data

%BASE DSM Pleiades
%  folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\mixDEM\'
%  file='CdSal__Pleiades__COP30__19S.tif'
%   
 
 folder= 'E:\Pedro\ESD Group Dropbox\gu pedro\GIS\AtAcAmA\'
 folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\mixDEM\'

 file='CdSal__Pleiades__COP30__19S.tif' % requires 17 GB RAM
 %file= 'CdSal__AtAcAmA__Pleiades__COP30__19S.tif' %requires 33 GB RAM, only in qorqut!
%folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDSM\'; %   terraces\
%folder='E:\Pedro\ESD Group Dropbox\gu pedro\GIS\AtAcAmA\PleiadesDSM\';
% folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\ALOS_DSM\'

%file='0b_CdSal_zonaNorte_DSM__Fmean_25.tif'
%file='0b_CdSal_zonaNorte_PleiadesMix_DSM.tif'

%file='all_terraces_01.tif'

%file='1_RiosGrandeSalado_DSM.tif'
%file='4_RioSanPedro_DSM.tif';
%file='3_Confluencia_DSM.tif'
%file='5_ValleLuna_DSM.tif';
%file='2_Machuca_DSM.tif'

%file='Atacama_ALOS_30m_19S.tif'
%% Define swath input mode
%  3 different inputs of profile points

mode = 2

%
% mode = 1
%          >> points choosed by clicking on the map
% mode = 2
%          >> points imported from Google Earth KLM file
% mode = 3
%          >> points defined by user (UTM coordinates), or convert lat and lon
%             with deg2utm function. It can be as many points as you want (minimum 2 x,y pairs).


% mode = 2 
KML_file= 'syncDomeyko__Ayaviri224__BarrancoThrust__CatarpeUP__VilamaTech__32.030km.kml'
%'xs__EBordo__Ayaviri__SBartolo__FrenteCdSal__32km.kml'
%'AltosPurilactis__QdaTambores__Quitor__44km.kml'
% 'BarrancoThrust__Ruta.kml'%'real xs C-C Brüggen.kml'%'xs C-C Brüggen 8km 3rd.kml'%'casi como xs C-C Brüggen 8km.kml' %'CordDomeyko__RSalado__SanJuan__SurMachuca__32km.kml'% 'XS_2__RioGrande__Machuca__10km.kml'%'AltosPuripicar__syncRioGrande__Putana__14km.kml'%'xs  PurilactisSur 2 - Valle Luna  -  18km.kml'
%'dOMEYKO__Gainza__Guatin__32km.kml'%'gainzaaa26km.kml'%
%'AltosPuripicar__Putana__12km.kml'
% xs__AltosPuripicarSUR__RioGrande__Machuca__12km.kml' %'xs__N01__AltosPuripicar__Putana.kml'%'ZorroCatarpe01__2km.kml'

% 'SanBartolo__QuitorEste__16km.kml'
%'SanBartolo__Tunel__Kari__2__20km.kml'%'Barranco__Catarpe__Quitor__6km.kml'

% 'BarrancoThrust__Vilama__14km.kml'%'Barranco__Catarpe__Vilama__12km.kml'


%'new__xs__Vallecito__25k.kml' 
% 'xs__Estrechadura__7.5k.kml' %'xs__01__surVallecito__5k.kml' %'Turipite en Vallecito 01.kml'
%'xs__W_ValleLuna_CerroMarmol__5k.kml'%'xs__CerroMarmol_NW_corner2__2.5k.kml'%'xs__CerroMarmol_Tortas__2.5k.kml'%'xs__W_ValleLuna_CerroMarmol__2.5k.kml'
%'elChancho incognito004 15k.kml '%'incognito004 10k.kml'%'incognito002 15k.kml'%'incognito001.kml'
% 'xs N3 new - San Juan - Sur V. Machuca.kml'%'machuca001_long.kml'%'sync_N_SanJuan.kml'%'xs machuca 20k.kml'
%'mini Chancho pop-up 2.kml'%'Real Chancho 09.kml'%'el_chancho01.kml'%yayayai.kml'turibless001.kml'
%'cerro_marmol_edge_01.kml'%'confluencia01.kml'% pelon_ns_salado.kml
%'catarpeTech.kml'%pliegue_confluenciaW.kml'%'ridge_del_minero_02.kml' 
% 'xs_Gainza04.kml'%'llanoPelon02.kml'%'donde_esta_yb_2.kml'%'vilamaTech.kml'
%'donde_esta_yb_3.kml' %'mamasita2.kml'%'xs_YB_AbraPampa_Valley2.kml'%'xs_YB_AbraPampa_Valley.kml'
%'perfil_lahar_sobrePelon.kml'xs_30102323_B
% 'que_es__ne_el_chancho.kml';%'lechuza_2.5k.kml'


% do you need to flip this profile?  
% yes = 1 , no = 0
flip_profile = 0 ;


%'perfil_rio_desde_VMachuca_1.kml'
%'sanbartolo_confluencia1.kml' 

%'nw-se, sync cerro marmol a lechuza.kml'
%'e-w desde lechuza, cerro marmol, a las tortas.kml'
%'pelon1.kml'
%'es_yb_o_no_es5.kml'
%'espesorYB1.kml'%'donde_esta_yb_3.kml' %'aaa112.kml'%'SB1.kml';%'piuri.kml' %'AbraPampita.kml'%'problema1.kml'%'abrapampa3.kml'
%'barranquito_1.kml'%'syncVallecito1.kml'; %'perfilSUR.kml' 'ruta333.kml'; %'lacroce.kml';  %'lalalai.kml';



% mode = 3
%          >> points defined by user (UTM coordinates), or convert lat and lon
%             with deg2utm function. It can be as many points as you want (minimum 2 x,y pairs).
userLat=[-50,-50];
userLon=[-73,-71];

% utm_yy = [7460680 ,  7459200];
% utm_xx = [572505 , 574444];




% userX=[]; userY=[];

[utm_xx,utm_yy]=deg2utm_19fix(userLat,userLon);


%% run first, but only once
fprintf('loading dem..\n')
ruta=append(folder,file);

 DEM = GRIDobj(ruta);
fprintf('!!!! DEM LOADED !!!!\n')
%%
% create swath profile
fprintf('creating swath profile..\n')
width1
clear SW1
if mode == 1
    % Define UTM coordinates and width for Swath profile
    fprintf('When the map opens, single click to start the swath and double click to stop the swath.')
    fprintf('\n');
    SW1 = SWATHobj(DEM,'width',width1);
    % Look at what your swath object contains.
    SW
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
    SW1 = SWATHobj(DEM,utm_xx,utm_yy,'width',width1);
elseif mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SW1 = SWATHobj(DEM,utm_xx,utm_yy,'width',width1);
end

distx_km=SW1.distx/1000; %converting meters into km
cero=SW1.Z*0;



%%
%
%   first figure
fprintf('plotting Fig 1 \n');

figure((width1))

hold on
%grid on
grid minor % distx_km SW.distx

plot(SW1.distx,SW1.Z,'k:','LineWidth',0.0001)

%plot(distx_km,max(SW.Z),'r-','LineWidth',0.1)
%plot(distx_km,min(SW.Z),'b-','LineWidth',0.1)
%

  
% %plot y-axis also at the right side... good if x-axis is long
%   
% Ax = gca;
% ytix = Ax.YTick;
% ytl = Ax.YTickLabel;
% text(ones(size(ytix))*max(xlim)+0.02*diff(xlim), ytix, ytl, 'Horiz','left', 'Vert','middle')


% escala horizontal vs vertical

%axis equal


% TOPObase = 2400   % definido por usuario

vx       = 1     % vertical exageration 2x imply vx=2; 3x imply vx=3; ...

% ylim([1484,2700]) % 4vx for 10 km in 1:25k Vallecito
% ylim([268,2700]) % 2vx for 10 km in 1:25k Vallecito
%ylim([1484,2700]) % 4vx for 10 km in 1:25k Vallecito
%% GET LENGTH OF Y-AXIS
ylim_1=ylim
yDif_1=ylim_1(1,2)-ylim_1(1,1)
%hrz_1=max(SW1.distx)/8;

%% 
title(string(KML_file) + '             Swath width = ' + string(width1) + 'm       Vertical exageration = ' + string(vx) + 'x')
  %%
%xticks([0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000 10500 11000 11500 12000])
%%
%ylim([TOPObase (TOPObase+(max_horizontal/vx))]);
 %xlim([0 hrz_1]);
 %xlim([hrz_1 hrz_1*2]);
ylim_12=ylim
yDif_12=ylim_12(1,2)-ylim_12(1,1)

%%

%ylim([(3000-yDif_12), 3000])
%itle(string(KML_file) + '       Swath width = ' + string(width) + 'm       Vertical exageration = ' + string(vx) + 'x')
  
%%


%% define vertical scale (vx) and max elevation of Y-axis (Htop)
axis normal

vx= 1


width=width1
Htop=4000

ylim([(Htop-yDif_1/vx), Htop])
% '5/5  of  '+
title(''+ string(KML_file) + '         Swath width = ' + string(width) + 'm       Vertical exageration = ' + string(vx) + 'x')

export_name1=string(extractBefore(string(KML_file),".kml") + '__w' +string(width)+'m__vx'+ string(vx))


%% create other swath profile, different width
fprintf('creating swath profile..\n')

% DEFINE WIDTH SWATH PROFILE
width2

clear SW2
if mode == 1
    % Define UTM coordinates and width for Swath profile
    fprintf('When the map opens, single click to start the swath and double click to stop the swath.')
    fprintf('\n');
    SW2 = SWATHobj(DEM,'width',width2);
    SW2
end 
    % Note that it contains info about the coordinate endpoints you clicked
    % (xy0), the width of the swath, and the swath values (Z).
if mode==2      
    fprintf('Importing data from KLM file.');
    fprintf('\n');
    KML_file
    [kml_xx,kml_yy,kml_zz]=read_kml(KML_file);
    
        
%     if flip_profile==1
%         kml_xx=flip(kml_xx);
%         kml_yy=flip(kml_yy);
%         kml_zz=flip(kml_zz);
%         fprintf('--> Swath profile flipped <--');
%         fprintf('\n');
%     end
  
    
    %[utm_xx,utm_yy,utm_zones]=deg2utm(kml_yy,kml_xx);
    [utm_xx,utm_yy]=deg2utm_19fix(kml_yy,kml_xx);
    SW2 = SWATHobj(DEM,utm_xx,utm_yy,'width',width2);
end
if mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SW2 = SWATHobj(DEM,utm_xx,utm_yy,'width',width2);
end

% distx_km=SW2.distx/1000; %converting meters into km
% cero=SW2.Z*0;



%%
figure(width2)
hold on
%grid on
%grid minor
plot(SW2.distx,SW2.Z,'k:','LineWidth',0.0001)
%plot(distx_km,max(SW.Z),'r-','LineWidth',0.1)
%plot(distx_km,min(SW.Z),'b-','LineWidth',0.1)
%
% escala horizontal vs vertical
% TOPObase = 2400   % definido por usuario
vx       = 1     % vertical exageration 2x imply vx=2; 3x imply vx=3; ...
%ylim([1484,2700]) % 4vx for 10 km in 1:25k Vallecito
title(string(KML_file) + '       Swath width = ' + string(width2) + 'm       Vertical exageration = ' + string(vx) + 'x')
max_horizontal=max(SW2.distx);
  %ylim([TOPObase (TOPObase+(max_horizontal/vx))]);
  xlim([0 max_horizontal]);

  
  
 % plot y-axis also at the right side... good if x-axis is long
  
%   
%  Ax = gca;
% ytix = Ax.YTick;
% ytl = Ax.YTickLabel;
% text(ones(size(ytix))*max(xlim)+0.02*diff(xlim), ytix, ytl, 'Horiz','left', 'Vert','middle')
%    axis equal
  grid minor

%%

fprintf('creating swath profile..\n')

% DEFINE    WIDTH   SWATH PROFILE

    width3     %unit is meters

clear SW
if mode == 1
    % Define UTM coordinates and width for Swath profile
    fprintf('When the map opens, single click to start the swath and double click to stop the swath.')
    fprintf('\n');
    SW = SWATHobj(DEM,'width',width3);
    % Look at what your swath object contains.
    SW
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
    SW = SWATHobj(DEM,utm_xx,utm_yy,'width',width3);
elseif mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SW = SWATHobj(DEM,utm_xx,utm_yy,'width',width3);
end

distx_km=SW.distx/1000; %converting meters into km
cero=SW.Z*0;



%%
figure(width3)
hold on
%grid on
%grid minor
plot(SW.distx,SW.Z,'k:','LineWidth',0.01)
%plot(distx_km,max(SW.Z),'r-','LineWidth',0.1)
%plot(distx_km,min(SW.Z),'b-','LineWidth',0.1)
%
% escala horizontal vs vertical
% TOPObase = 2400   % definido por usuario
vx       = 1     % vertical exageration 2x imply vx=2; 3x imply vx=3; ...
title(string(KML_file) + '       Swath width = ' + string(width3) + 'm       Vertical exageration = ' + string(vx) + 'x')
max_horizontal=max(SW.distx);
  %ylim([TOPObase (TOPObase+(max_horizontal/vx))]);
% xlim([0 max_horizontal]);

  
  
 % plot y-axis also at the right side... good if x-axis is long
  
%   
%  Ax = gca;
% ytix = Ax.YTick;
% ytl = Ax.YTickLabel;
% text(ones(size(ytix))*max(xlim)+0.02*diff(xlim), ytix, ytl, 'Horiz','left', 'Vert','middle')
 %   axis equal
  grid minor
% for XS Vallecito 25k, largo aprox 9 km
% !!
% para el eje Y amplificar:
% x2(rango=2360m)> ylim:340,2700
% x4(rango=1180m)>1520,2700
% x8(rango=590m)> 2110,2700
%%%%%%%%

%%

fprintf('creating swath profile..\n')

% DEFINE    WIDTH   SWATH PROFILE

    width4     %unit is meters

clear SW4
if mode == 1
    % Define UTM coordinates and width for Swath profile
    fprintf('When the map opens, single click to start the swath and double click to stop the swath.')
    fprintf('\n');
    SW4 = SWATHobj(DEM,'width',width4);
    % Look at what your swath object contains.
    SW4
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
    SW4 = SWATHobj(DEM,utm_xx,utm_yy,'width',width4);
elseif mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SW4 = SWATHobj(DEM,utm_xx,utm_yy,'width',width4);
end

distx_km=SW4.distx/1000; %converting meters into km
cero=SW4.Z*0;



%
figure(width4)
hold on
%grid on
%grid minor
plot(SW4.distx,SW4.Z,'k:','LineWidth',0.01)
%plot(distx_km,max(SW.Z),'r-','LineWidth',0.1)
%plot(distx_km,min(SW.Z),'b-','LineWidth',0.1)
%
% escala horizontal vs vertical
% TOPObase = 2400   % definido por usuario
%vx       = 1     % vertical exageration 2x imply vx=2; 3x imply vx=3; ...
title(string(KML_file) + '       Swath width = ' + string(width4) + 'm       Vertical exageration = ' + string(vx) + 'x')
 max_horizontal=max(SW4.distx);
  %ylim([TOPObase (TOPObase+(max_horizontal/vx))]);
  xlim([0 max_horizontal]);

  
  
 % plot y-axis also at the right side... good if x-axis is long
  
%   
%  Ax = gca;
% ytix = Ax.YTick;
% ytl = Ax.YTickLabel;
% text(ones(size(ytix))*max(xlim)+0.02*diff(xlim), ytix, ytl, 'Horiz','left', 'Vert','middle')
 %   axis equal
  grid minor
% ylim([1579.412835023942,2550.030768491683]) % for 'xs__W_ValleLuna_CerroMarmol__5k.kml'
%%%%%%%%

% ylim([268,2700]) % 2vx for 10 km in 1:25k Vallecito

%ylim([1484,2700]) % 2vx for 10 km in 1:25k Vallecito
%% export figure

export_name =  (extractBefore(string(KML_file),".kml")) + '__Swath_' +string(width1)+'m__V_'+ string(vx) + 'x__.eps'
%print(gcf, export_name, '-depsc', '-r300'); % '-depsc' for EPS format, '-r300' for 300 dpi resolution