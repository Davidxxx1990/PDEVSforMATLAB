function [out] = testShiftregister(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 15;
    end
    
    tVec1 = [3, 4, 5, 6, 9, 11, 100];   % in
    tVec2 = [0.5, 1.0];                 % clk
    mdebug = false;

    N1 = coordinator('N1');

    Bingenerator1 = devs(bingenerator("Bingenerator1", 0, tVec1, mdebug));
    Bingenerator2 = devs(bingenerator("Bingenerator2", 1, tVec2, mdebug));
    Notgate = devs(notgate("Notgate", mdebug));
    JKFF1 = devs(jkflipflop("JKFF1", 0, mdebug));
    JKFF2 = devs(jkflipflop("JKFF2", 0, mdebug));
    JKFF3 = devs(jkflipflop("JKFF3", 0, mdebug));
    JKFF4 = devs(jkflipflop("JKFF4", 0, mdebug));
    Terminator1 = devs(terminator("Terminator1"));
    Binout1 = devs(toworkspace("Binout1", "bin1Out", 0));
    Binout2 = devs(toworkspace("Binout2", "bin2Out", 0));
    JKFFq1 = devs(toworkspace("JKFFq1", "q1Out", 0));
    JKFFq2 = devs(toworkspace("JKFFq2", "q2Out", 0));
    JKFFq3 = devs(toworkspace("JKFFq3", "q3Out", 0));
    JKFFq4 = devs(toworkspace("JKFFq4", "q4Out", 0));

    N1.add_model(Bingenerator1);
    N1.add_model(Bingenerator2);
    N1.add_model(Notgate);
    N1.add_model(JKFF1);
    N1.add_model(JKFF2);
    N1.add_model(JKFF3);
    N1.add_model(JKFF4);
    N1.add_model(Terminator1);
    N1.add_model(Binout1);
    N1.add_model(Binout2);
    N1.add_model(JKFFq1);
    N1.add_model(JKFFq2);
    N1.add_model(JKFFq3);
    N1.add_model(JKFFq4);

    N1.add_coupling("Bingenerator1","out","JKFF1","j");
    N1.add_coupling("Bingenerator1","out","Notgate","in");
    N1.add_coupling("Notgate","out","JKFF1","k");
    N1.add_coupling("Bingenerator2","out","JKFF1","clk");
    N1.add_coupling("Bingenerator2","out","JKFF2","clk");
    N1.add_coupling("Bingenerator2","out","JKFF3","clk");
    N1.add_coupling("Bingenerator2","out","JKFF4","clk");
    N1.add_coupling("JKFF1","q","JKFF2","j");
    N1.add_coupling("JKFF1","qb","JKFF2","k");
    N1.add_coupling("JKFF2","q","JKFF3","j");
    N1.add_coupling("JKFF2","qb","JKFF3","k");
    N1.add_coupling("JKFF3","q","JKFF4","j");
    N1.add_coupling("JKFF3","qb","JKFF4","k");
    N1.add_coupling("JKFF4","qb","Terminator1","in");
    % outputs
    N1.add_coupling("Bingenerator1","out","Binout1","in");
    N1.add_coupling("Bingenerator2","out","Binout2","in");
    N1.add_coupling("JKFF1","q","JKFFq1","in");
    N1.add_coupling("JKFF2","q","JKFFq2","in");
    N1.add_coupling("JKFF3","q","JKFFq3","in");
    N1.add_coupling("JKFF4","q","JKFFq4","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure("name","testshift","NumberTitle","off", ...
		 "Position",[1 1 550 575]);
    subplot(6,1,1)
    stairs(simout.bin1Out.t,simout.bin1Out.y);
    title("In");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(6,1,2)
    stairs(simout.bin2Out.t,simout.bin2Out.y);
    title("CLK");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(6,1,3)
    stairs(simout.q1Out.t,simout.q1Out.y);
    title("Out 1");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(6,1,4)
    stairs(simout.q2Out.t,simout.q2Out.y);
    title("Out 2");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(6,1,5)
    stairs(simout.q3Out.t,simout.q3Out.y);
    title("Out 3");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(6,1,6)
    stairs(simout.q4Out.t,simout.q4Out.y);
    title("Out 4");
    xlim([0, tend])
    ylim([-0.1, 1.1])
    
    out = simout;
end