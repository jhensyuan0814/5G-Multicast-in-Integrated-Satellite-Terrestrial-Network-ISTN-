function QoE = calculate_qoe(bandwidth,SINR,state)
    global SCmax;
    g = 7.696;
    if(state == 2) %satellite
         Pmax = 33; %transmission power max (dBm); from Joint cache
         Pgain = 25; %25
         loss = 25.5; %attenuation (dB); from 3GPP p.49
         power = 10^((Pmax+Pgain-loss)/10 - 3);
         %fprintf("power = %f\n",power);
         capacity = 0.95*bandwidth.*log2(1+power);
    else
        capacity = 0.95*bandwidth.*log2(1+SINR);
    end
    
    %if((state == 0 )|| ((state == 1) &&  max(capacity,[],'all')>SCmax))
    %    SCmax = max(capacity,[],'all');
    %end
    %QoE = (1-exp(-g.*capacity./SCmax))./(1-exp(-g));
    QoE = capacity / bandwidth;
    %QoE = SINR;
end