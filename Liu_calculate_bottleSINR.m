function bottleSINR = Liu_calculate_bottleSINR(members,sender,ANNum)
    global MU;
    global AN;
    bottleSINR = 100000000;
    for i = 1:length(members)
        tSINR = partial_calculate_SINR(MU(members(i)),AN(2:ANNum),sender-1);
        bottleSINR = min(tSINR, bottleSINR);
    end
end