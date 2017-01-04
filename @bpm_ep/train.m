function obj = train(obj, varargin)

% clear the state
obj.state = [];

obj = retrain(obj, varargin{:});
