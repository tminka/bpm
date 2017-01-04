% Bayes Point Machine Toolbox.
% Version 1.2 10-May-2013
% Written by Tom Minka (my surname @microsoft.com)
%
% EP
%   bpm_task         - Define a classification task.
%   bpm_ep           - Create a bpm_ep object for learning a task.
%   train            - Train or retrain a bpm_ep object.
%   draw             - Draw the learned classification boundary.
%   get_w            - Estimated version space mean (linear kernel only).
%   get_v            - Estimated version space covariance (linear kernel only).
%   get_s            - Estimated version space volume (in log domain).
%   classify         - Classify test data.
%   predict          - Soft classification of test data.
%   bpm_classify     - Low-level version of classify.
%
% Utilities
%   kernelmtx_linear - Compute matrix of inner products (linear kernel).
%   kernelmtx_poly   - Compute matrix of inner products (polynomial kernel).
%   kernelmtx_rbf    - Compute matrix of inner products (RBF kernel).
%   kernelmtx_discrete - Compute matrix of inner products (categorical kernel).
%   bpm_brute        - Compute moments of version space by brute force. 
%
% Graphics
%   plot_data        - Plot classes as x's and o's.
%   bpm_draw         - Draw a classification boundary.
%   show_vs          - Render the version space on the sphere.
%   draw_vs_point    - Plot a labeled point in the version space.
%   draw_ellipsoid   - Plot an ellipsoid in the version space.
%
% Demos
%   test1            - Simple separable test.
%   test2            - Nonseparable test.
%   test_kernel      - Kernel test.
