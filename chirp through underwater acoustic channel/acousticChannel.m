function [h,delay,powerTaps,varargout] = acousticChannel(type,T,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

input = inputParser;
addRequired(input,'type',@isstr);
addRequired(input,'T',@isnumeric);
addParameter(input,'N_paths',15);
addParameter(input,'delayMean',1e-3);
addParameter(input,'powerDifference',20);
addParameter(input,'Tg',24.6e-3);
addParameter(input,'v_0',20);
addParameter(input,'sigma_v',3);

parse(input, type, T, varargin{:});

type = input.Results.type;
T = input.Results.T;
N_paths = input.Results.N_paths;
delayMean = input.Results.delayMean;
powerDifference = input.Results.powerDifference;
Tg = input.Results.Tg;
v_0 = input.Results.v_0;
sigma_v = input.Results.sigma_v;

% if (nargin == 2)
%     N_paths = 15;
%     delayMean = 1e-3;
%     powerDifference = 20;           % in dB
%     Tg = 24.6e-3;                   % in seconds
%     v_0 = 20;                       % in m/s
%     sigma_v = 3;                    % in m/s
% elseif (nargin == 3)
%     N_paths = varargin{1};
%     delayMean = 1e-3;
%     powerDifference = 20;           % in dB
%     Tg = 24.6e-3;                   % in seconds
%     v_0 = 20;                       % in m/s
%     sigma_v = 3;                    % in m/s
% elseif (nargin == 4)
%     N_paths = varargin{1};
%     delayMean = varargin{2};
%     powerDifference = 20;           % in dB
%     Tg = 24.6e-3;                   % in seconds
%     v_0 = 20;                       % in m/s
%     sigma_v = 3;                    % in m/s
% elseif (nargin == 5)
%     N_paths = varargin{1};
%     delayMean = varargin{2};
%     powerDifference = varargin{3};
%     Tg = 24.6e-3;                   % in seconds
%     v_0 = 20;                       % in m/s
%     sigma_v = 3;                    % in m/s
% elseif (nargin == 6)
%     N_paths = varargin{1};
%     delayMean = varargin{2};
%     powerDifference = varargin{3};
%     Tg = varargin{4};
%     v_0 = 20;                       % in m/s
%     sigma_v = 3;                    % in m/s
% elseif (nargin == 7)
%     N_paths = varargin{1};
%     delayMean = varargin{2};
%     powerDifference = varargin{3};
%     Tg = varargin{4};
%     v_0 = 20;                       % in m/s
%     sigma_v = 3;                    % in m/s
% else
%     error('Invalid parameters.');
% end

c = 1500;

if (strcmp(type,'variant'))
    v = v_0 - sqrt(3)*sigma_v + (2*sqrt(3)*sigma_v)*rand(1,1);
    a = v/c;
    [num_a,den_a] = rat(1+a);
    varargout{1} = num_a;
    varargout{2} = den_a;
elseif (strcmp(type,'invariant'))
    a = 0;
    varargout{1} = 1;
    varargout{2} = 1;
else
    error('Invalid type.')
end

distribution = makedist('exponential','mu',delayMean);

tau = random(distribution,N_paths,1);
tau_position = ceil(tau/T);

delay_position = sum(repmat(tau_position,1,N_paths).'.*tril(ones(N_paths,N_paths)),2);
delay_position = ceil(delay_position/(1 + a));

alpha = log(10^(powerDifference/10))/Tg;

delay = delay_position*T;

powerMean = exp(-alpha*delay);

powerTaps = raylrnd(powerMean*sqrt(2/pi));

h = zeros(max(delay_position),1);

h(delay_position) = powerTaps;

h = h/norm(h);

end

