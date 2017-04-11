clear all%, close all 

case_title = '''Lascas''';


%==================================================================
%  
%  Define source data:
%  
%==================================================================

%disp('Defining source characteristics...')
% load bathymetry_10km
load bathymetry_10km
load ssp_lascas

%C = C_aux2;
%Z = Z_aux;

maximo_range_hidrofone = 10e3;
track_ranges_aux = track_ranges(track_ranges <= maximo_range_hidrofone); 
INDICE_MAX_RANGE = length(track_ranges_aux);
INDICE_MAX_RANGE = INDICE_MAX_RANGE + 1;
track_ranges = track_ranges(1:INDICE_MAX_RANGE);
track_depths = track_depths(1:INDICE_MAX_RANGE); 

for ii = 1:1 

freq   =  7500;
Rmax   =  maximo_range_hidrofone;
Dmax   =  max(track_depths); 

ray_step = Rmax/1000; 

zs       = 15;
rs       = 0;
thetamax = 45.0;
np2      = 5001;
la       = linspace(-thetamax,thetamax,np2);

source_data.ds       = ray_step;
source_data.position = [rs zs];
source_data.rbox     = [rs-2 Rmax+2];
source_data.f        = freq;
source_data.thetas   = la;

%==================================================================
%  
%  Define altimetry data:
%  
%==================================================================

%disp('Defining surface characteristics...')

altimetry(1,:) = (linspace(rs-2,Rmax + 2,INDICE_MAX_RANGE));
altimetry(2,:) = (0.1*sin((50*pi*altimetry(1,:)/(Rmax + 2))));

altimetry(1,1) = source_data.rbox(1);
altimetry(1,end) = source_data.rbox(2);


surface_data.type  =   '''E'''; 
surface_data.ptype =   '''H'''; % Homogeneous
surface_data.units =   '''W'''; % (Attenuation Units) dB/Wavelenght
surface_data.itype =  '''4P'''; % Sea surface interpolation type
surface_data.x     = altimetry; % Surface coordinates


surface_data.properties = [1510.0 600.0 0.99 0.1 0.0];

%==================================================================
%  
%  Define sound speed data:
%  
%==================================================================

%mesma velocidade para tudo
ssp_data.cdist = '''c(z,z)'''; % Sound speed profile
ssp_data.cclass = '''ISOV'''; 
ssp_data.z   = [0 45];
ssp_data.r   = [];
ssp_data.c   = [1500 1500]';


%==================================================================
%  
%  Define object data:
%  
%==================================================================

object_data.nobjects = 0; % Number of objects

%==================================================================
%  
%  Define bathymetry data:
%  
%==================================================================

%disp('Defining bottom characteristics...')
bathy(:,1)   = [vertcat(track_ranges(1)-2,track_ranges(2:end-1),track_ranges(end)+2)];
bathy(:,2)   = track_depths;

%ruido guassiano na batimetria
bathymetry   = (bathy)' ;

bathymetry(1,1) = rs-2;
bathymetry(1,end) = Rmax+2;


bottom_data.type   = '''E''' ;
bottom_data.ptype  = '''H''' ; % Homogeneous bottom
bottom_data.units  = '''W''' ; % Bottom attenuation units
bottom_data.itype  = '''4P'''; % Bottom interpolation type 
bottom_data.x      = bathymetry; % Bottom coordinates 


bottom_data.properties = [1684 0.0 1.99 0.6 0];% [cp cs rho ap as]

%==================================================================
%  
%  Define output data:
%  
%==================================================================

%disp('Defining output options...')
c0 = 1500;
freq = 10e3;
lambda = c0/freq;
d = lambda/2;

numero_hidrofones = 8;
miss_number = d/10e3;

profundidade_inicial = 35; 

ranges = maximo_range_hidrofone;
depths = profundidade_inicial:d:(profundidade_inicial + (numero_hidrofones-1)*d); 

output_data.ctype       = '''ERF'''; 
output_data.array_shape = '''VRY''';
output_data.r           = ranges;
output_data.z           = depths; 
output_data.miss        = miss_number;

%==================================================================
%  
%  Call the function:
%  
%==================================================================

%disp('Writing TRACEO waveguide input file...')

wtraceoinfil('flat1.in',case_title,source_data,surface_data,ssp_data,object_data,bottom_data,output_data);

%disp('Calling cTraceo...')
!ctraceo flat1

ad = load('aad.mat');
er = load('eig.mat');

for jj = 1:numero_hidrofones
    
hydn = jj;

ganho{ii,jj}   = [ad.arrivals(hydn).arrival(1:ad.arrivals(hydn).nArrivals).amp];
atraso{ii,jj}  = [ad.arrivals(hydn).arrival(1:ad.arrivals(hydn).nArrivals).tau];
raioR{ii,jj}  = [er.eigenrays(hydn).eigenray(1:er.eigenrays(hydn).nEigenrays).r];
raioZ{ii,jj}   = [er.eigenrays(hydn).eigenray(1:er.eigenrays(hydn).nEigenrays).z];

end

end
save('./results/Results.mat','ganho','atraso');
save('./results/raios.mat','raioR','raioZ');
