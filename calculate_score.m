function score = calculate_score(bandwidth,ANNum,version)
    global SFNNum;
    global W;
    global AN;
    global MU;
    global bottle_QoE;
    score = 0;
    for i = 1:SFNNum
        sender = find(W(i,:));
        if(isempty(sender))
            continue;
        end
        members = find_mu(sender);
        %disp(members)
         if(isempty(members))
            continue;
         end
        temp_QoE = zeros(1,length(members));
        if i ==1
            for j = 1:length(members)
                temp_QoE(j) = calculate_qoe(bandwidth,0,2);
            end
        else
            for j = 1:length(members)
                temp_QoE(j) = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members(j)),AN(2:ANNum),sender-1),1);
            end
        end
        %disp(temp_QoE);
        %disp(members);
        score = score + min(temp_QoE)*length(members);
        bottle_QoE(i) = min(temp_QoE);
    end
    fprintf("********************\n");
    fprintf("Version %d is %f\n",version,score);
end