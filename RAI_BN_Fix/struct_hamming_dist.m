function [SHD, SHD_u, SHD_d, SHD_u_err, SHD_d_err] = struct_hamming_dist(learned_cpdag, true_cpdag)
% SHD calculate the structural Hamming distance
% between two cpdags
% [SHD, SHD_u, SHD_d, SHD_u_err, SHD_d_err] = struct_hamming_dist(learned_cpdag, true_cpdag)
%
% SHD - total structural Hamming distance.
% SHD_u - total structural errors in the undirected graph: extra + missing
%         edges.
% SHD_u - total structural errors in the directinality of edges:
%         extra+missing+reversed directions.
% SHD_u_err - data-structure for the number of extra & missing edges.
% SHD_d_err - data-structure for the number of extra, missing & reversed
%             directions.
%
%
% Written by Raanan Yehezkel
% SHD is as defined in Tsamardinos et al. Machine Learning 2006



% *** calculate errors due to undirected edges ***
learned_cpdag_u = (learned_cpdag | learned_cpdag'); % undirected
true_cpdag_u = (true_cpdag | true_cpdag'); % undirected

SHD_u_om  = ...
    sum(sum((learned_cpdag_u == 0) & (true_cpdag_u == 1)))/2; % omissions
SHD_u_co  = ...
    sum(sum((learned_cpdag_u == 1) & (true_cpdag_u == 0)))/2; % commissions
SHD_u = SHD_u_om + SHD_u_co; % erroneous edges

SHD_u_err.omissions = SHD_u_om;
SHD_u_err.commissions = SHD_u_co;

% *** calculate errors due to directed edges ***
learned_cpdag_u = (learned_cpdag | learned_cpdag'); % undirected
true_cpdag_u = (true_cpdag | true_cpdag'); % undirected

learned_only_directed = learned_cpdag & (learned_cpdag ~= learned_cpdag');
learned_only_undirected = learned_cpdag & (learned_cpdag == learned_cpdag');

true_only_directed = true_cpdag & (true_cpdag ~= true_cpdag');
true_only_undirected = true_cpdag & (true_cpdag == true_cpdag');

common_cpdag = (learned_cpdag_u == 1) & (true_cpdag_u == 1);

cpdag_d_om = ... % leave omitted directions
    common_cpdag & (learned_only_undirected & true_only_directed);
cpdag_d_co = ... % leave committed directions
    common_cpdag & (learned_only_directed & true_only_undirected);
cpdag_d_rv = ... % leave reversed edges
    common_cpdag & (learned_only_directed & true_only_directed');

SHD_d_om = sum(sum(cpdag_d_om));
SHD_d_co = sum(sum(cpdag_d_co));
SHD_d_rv = sum(sum(cpdag_d_rv));
SHD_d = SHD_d_om + SHD_d_co + SHD_d_rv;

SHD_d_err.omissions = SHD_d_om;
SHD_d_err.commissions = SHD_d_co;
SHD_d_err.reversed = SHD_d_rv;

% *** total errors ***
SHD = SHD_u + SHD_d;

