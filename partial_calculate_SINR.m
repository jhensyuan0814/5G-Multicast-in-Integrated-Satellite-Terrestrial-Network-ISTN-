function SINR = partial_calculate_SINR(MS, BS, sender)%a single MS vs multiple BS
    %modified from HW1, downlink (1-3)
    %signal from the central BS
    g = calculate_received_power(BS - MS);
    %all signals from BSs in a SFN
    sending = sum(g(sender),'all');
    %interference from the other BSs
    interference = sum(g,'all')-sending;
    noise = 1.38 * 10 ^ (-23) * 300 * 10 ^ 7;  %Noise = k * Temperature * Bandwidth
    noise = noise + interference;  %in Watt, not in dB
    %fprintf("sending vs interference = %e / %e\n",sending,noise);
    SINR = sending / noise;  %in Watt
end