function plot_data(X,Y)
% PLOT_DATA(X,Y) plots two classes as x's and o's.
% X is matrix of rows.
% Y is (1,-1) labels.

i1 = find(Y > 0);
i0 = find(Y < 0);
plot(X(i1,1), X(i1,2), 'o', X(i0,1), X(i0,2), 'x');
