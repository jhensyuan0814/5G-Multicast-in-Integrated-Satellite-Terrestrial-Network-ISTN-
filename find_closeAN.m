function ANidx = find_closeAN(MUidx,sender2)
    global MU;
    global AN;
    distance = abs(AN(sender2)-MU(MUidx));
    [~,ANidx] = min(distance);
    ANidx = sender2(ANidx);
end