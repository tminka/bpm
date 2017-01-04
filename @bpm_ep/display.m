function disp(obj)

fprintf('BPM-EP %s %d\n', obj.type, obj.e)
fprintf('mw = ')
disp(obj.mw(:)')
