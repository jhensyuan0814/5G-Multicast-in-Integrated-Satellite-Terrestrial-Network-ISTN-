function SINR = ini_calculate_SINR(MS, BS)%a MS vs multiple BS
    %modified from HW1, downlink (1-3)
    %signal from the central BS
    g = calculate_received_power(BS - MS);
    %interference from the other BSs
    interference = sum(g,'all')-g;
    noise = 1.38 * 10 ^ (-23) * 300 *  10 ^ 7;  %Noise = k * Temperature * Bandwidth
    noise = noise + interference;  %in Watt, not in dB
    SINR = g ./ noise;  %in Watt
end