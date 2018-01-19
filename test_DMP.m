addpath('DMP-LWR')
addpath('imitation')
addpath('dmp_learning')

%% load data

name = 'sensor';
%name = 'circleresult';
%name = 'sinresult';
%name = '8result';
[~, data]=get_data2(name);
clear('name')

%% chosse DMP parameters

% K: Stifness coefficient
% D: Damping coefficient
% ng: number of gaussian
% as: decrease of the time dx/dt = as*x
% s: initial time'

%% square
%        { K,       D,      ng,     as,         s }
%answer = {'5000',   '800',  '100',  '0.001',    '1'}; % overdamping
%answer = {'5000',   '600',  '100',  '0.001',    '1'}; % no overshoot
%answer = {'5000',   '400',  '100',  '0.001',    '1'}; % small overshoot
%answer = {'40000',   '1600',  '100',  '0.001',    '1'}; % best fit
%answer = {'52360',   '1734',  '100',  '0.0012',    '1'}; % learned

%% circle
%answer = {'8000',   '400',  '100',  '0.001',    '1'}; % manual
%answer = {'3673',   '882',  '100',  '0.0032',    '1'}; % learned (10000 it)

%% sinus
%answer = {'8000',   '400',  '100',  '0.001',    '1'}; % manual

%% 8
answer = {'8000',   '400',  '100',  '0.001',    '1'}; % manual

par = generate_param(answer);
clear('answer')

%% train DMP

r = dmpTrain(data, par);
clear('par')

%% plot DMP

close all
plot_ids = [1, 3, 14];
for k = plot_ids
    result=dmpReplay(r);
    result.options=[k];
    res=dmpPlot(data, result);
end
clear('plot_ids', 'k', 'res')