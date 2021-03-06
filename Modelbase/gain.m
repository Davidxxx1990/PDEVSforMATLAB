classdef gain < handle
%% Description
%  multiplies the input value with a factor
%% Ports
%  inputs: 
%    in  incoming values
%  outputs: 
%    out      in * gain
%% States
%  s: idle|output
%  value
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information

  properties
    s
    value
    Gain
    name
    debug
  end
    
  methods
    function obj = gain(name, gain, debug)
      obj.s = "idle";
      obj.value = 0;
      obj.Gain = gain;
      obj.name = name;
      obj.debug = debug;
    end
        
    function dint(obj)
      if obj.debug
        fprintf("%-8s entering int, being in phase %s\n", ...
	              obj.name, obj.s)
        showState(obj);
	 end
     
	 obj.s = "idle";
	 
      if obj.debug
        fprintf("%-8s leaving int, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dext(obj,e,x)
      if obj.debug
        fprintf("%-8s entering ext, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
      
      if isfield(x, "in")
        obj.value = x.in;
	   obj.s = "output";
      end
 
      if obj.debug
        fprintf("%-8s  leaving ext, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dcon(obj,e,x)
      if obj.debug    
        fprintf("%-8s con, in phase %s\n", obj.name, obj.s)
      end
      dint(obj);
      dext(obj,e,x);
    end
    
    function y = lambda(obj)
     
	 y.out = obj.value * obj.Gain;
	   
      if obj.debug
        fprintf("%-8s OUT, out=%2d\n", obj.name, y.out)
      end
    end
        
    function t = ta(obj)
      switch obj.s
        case "idle"
          t = inf;
        case "output"
          t = 0;
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%s value=%3d gain=%3d\n", obj.s, obj.value, obj.Gain);
    end  

  end
end
