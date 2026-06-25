addpath 'D:\Dropbox\PEDRO\CdSal\codes'
%addpath 'D:\Dropbox\PEDRO\codes\SRTM_DEM_30m'

%% SWATH PROFILES with TOPOTOOLBOX (must be installed first!)

% first lets clear the workspace, command window and close all figures
%clear;
clc; %close all;


%% DEFINE WIDTH SWATH PROFILEs
width1= 20 %unit is meters


%% load DEM file with data


% %BASE DSM Pleiades

folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\PleiadesDSM\'; %   terraces\

%file='0b_CdSal_zonaNorte_DSM__Fmean_25.tif'
% file='0b_CdSal_zonaNorte_PleiadesMix_DSM.tif'

%file='all_terraces_01.tif'

file='1_RiosGrandeSalado_DSM.tif'
%file='4_RioSanPedro_DSM.tif';
% file='3_Confluencia_DSM.tif'
%file='3_Confluencia_DSM__Fmean_25.tif'
%file='5_ValleLuna_DSM.tif';
%file='2_Machuca_DSM.tif'
 
 
% % % %BASE DEM ALOS PALSAR
% folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\ALOS_DSM\'
%  file='Atacama_ALOS_30m_19S.tif'
 
 
 
% % % Pleiades +cop30 mix
 %folder='D:\Dropbox\PEDRO\GIS\AtAcAmA\mixDEM\'
% % file='CdSal__Pleiades__COP30__19S__clipVallecitoWEST.tif' % requires only 1.8 GB RAM
% %  file='CdSal__Pleiades__COP30__19S__clip__SW.tif' % requires only 3.85 GB RAM
% file='CdSal__Pleiades__COP30__19S__clip__i3Tambores.tif'
% file='CdSal__Pleiades__COP30__19S.tif' % requires 17 GB RAM
% file= 'CdSal__AtAcAmA__Pleiades__COP30__19S.tif' % QORQUT ONLY!! requires 33 GB 
%file='CdSal__Pleiades__COP30__19S__clip__perfil_III_Vallecito2.tif'

%% Define swath input mode

%  Three different inputs of profile points
%
% mode = 1  >> points choosed by clicking on the map
% mode = 2  >> points imported from Google Earth KLM file
% mode = 3  >> points defined by user (UTM coordinates), or convert lat and lon
%           >> with deg2utm function. It can be as many points as you want (minimum 2 x,y pairs).

mode = 2

% KML_file= 'EastDomeyko__C-C__Brüggen__pozo1.kml'%QdaTambores__8km.kml'%
%KML_file='xs_Barranco__Catarpe__10km__giro5.kml' %catarpe9000.kml

% KML_file='new5__Lechuza2__44km.kml'
% Puripicar__end__west__Tatio.kml
KML_file='xs__espesor__SanPedro__RioGrande_2__10km.kml'
%'LlanoPaciencia_FMinero_BarrancoAnti__tefra__falla__Confluencia__Catarpe__SdA__18km.kml'
%'SPWindgapQuitor__wpt251_Puripicar__al__este__1800m.kml'% 'perfil3__Brüggen1947__Vallecito2__30km.kml'

% 'RioSalado__domo__a_lomaAyaviri__9km.kml'%'i3__LlanoPaciencia__VJuriques__57.9km.kml'%i3__Tambores__02__NS.kml'     %'i3__sifon__SW__2003m.kml'%i3__sifon__SW__2200m.kml'%ElBordo__finSifon__surVallecito__30km.kml'
% 'LlanoPacienciaSUR__15km.kml'%Gainza__Ayaviri__SBartolodiagonal__N346__29km.kml'%wLLanoPaciencia__BarrancoANti__Catarpe__346.kml'
%'SanBartolo__syn__Catarpe__16km.kml'%ALONG__FRENTE__13km.kml'%xs__185__Vilama__3.5km.kml' %xs__pliegueBend__Vilama__3.5km.kml'
%xs__EBordo__Ayaviri__SBartolo__FrenteCdSal__32km.kml'%'frenteCdSAl__XS__SUR01__10km.kml'%xs__Domeyko__Salar__via__AyaviriSBartoloNZCatarpeFrontal__40km.kml'
%'xs__QdaGainza__067_a_187__4.6km.kml' %'xs__RioSalado__norte__sinclinal__3km.kml' 
%'ElChancho06__2km.kml'%'gAinza__SW__NE__2.kml'%'xs_Gainza02.kml'%{{Turipite-Chaxas__8km{{ LlanoPaciencia__Barranco__SanBartolo__10km.kml'%SanBartolo_syncline__9km__desde041.kml'%TuinaPurilactis__QdaGainza__ElChancho_syn_Machuca__Guatin__60km.kml'%'gainza casi 30k.kml'%'xs__CDomeyko__PurilactisSync__52km.kml'%purilactis__tambores__barranco__catarpe.kml'%'purilactis__tambores__barranco__32km.kml'%Tambores-Barranco__12km.kml'%'xs__CatarpeQuitor__exitCdSal__4km.kml'%xs__Gainza__03b.kml'%'cuencaCalama-rioSalado-rioGrande-MachucaJorquencal-Sairecabur__70km.kml' 
% 'rioSalado-rioGrande-machuca__56km.kml'


% do you need to flip this profile?  
% yes = 1 , no = 0
flip_profile = 0 ;


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
ruta=append(folder,file)

DEM = GRIDobj(ruta);
%DEM = fillsinks(DEM1);
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
    SW1 = SWATHobj(DEM,utm_xx,utm_yy,'width',width1);
elseif mode==3
    fprintf('Importing user coordinates.');
    fprintf('\n');
    SW1 = SWATHobj(DEM,utm_xx,utm_yy,'width',width1);
end

distx_km=SW1.distx; %converting meters into km
cero=SW1.Z*0;



%

%%   first figure
%
fprintf('plotting Fig 1 \n');

figure((width1+6))

hold on
%grid on
grid minor % distx_km SW.distx

%
plot(SW1.distx,SW1.Z,'k:','LineWidth',0.00000000000000000000000001)
% plot(SW1.distx,max(SW1.Z),'k-','LineWidth',0.5)
% plot(SW1.distx,min(SW1.Z),'b-','LineWidth',0.5)


title(''+ string(KML_file) + '        Swath width = ' + string(width1)) %  + 'm       Vertical exageration = ' + string(vx) + 'x')


%
% log scale

%set(gca, 'YScale', 'log')

min(SW1.Z(:))

max(SW1.distx(:))