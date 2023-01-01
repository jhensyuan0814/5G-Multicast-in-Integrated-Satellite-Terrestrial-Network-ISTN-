function g = calculate_received_power(d)
    %calculate received power when the distance is d (an array)
    ht = 5;  %the height of the base station
    hi = 1.5;  %the height of the mobile station
    Ptx = 13;  %the power of the AP, in dB
    Gtx = 8;  %the power of the transimitter gain, in dB
    Grx = 8;  %the power of the receiver gain, in dB
    numerator = (hi * ht) ^ 2;
    g = numerator * abs(d) .^ (-4);  %two-ray ground model
    g = g * db2pow( Ptx + Gtx + Grx);  %in Watt
    g = 20*log10(40*pi*abs(d)*6/3)+10*log10(abs(d))-14.77+0.002*log10(ht*abs(d));
    g = db2pow( Ptx + Gtx + Grx - g);
end