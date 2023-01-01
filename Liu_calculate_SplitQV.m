function Split_QV = Liu_calculate_SplitQV(bandwidth,ANNum)
    global W;
    sender = find(W(2,:));
    members =  find_mu(sender);
    bottleSINR = Liu_calculate_bottleSINR(members,sender,ANNum);
    Split_QV = length(members)*log(bandwidth*log(1+bottleSINR));
end