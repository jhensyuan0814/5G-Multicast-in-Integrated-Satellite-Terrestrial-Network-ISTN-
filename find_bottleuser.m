function [minidx1,newbottle,oldbottle,Nm1] = find_bottleuser(i,ANNum,bandwidth)
    global W;
    global AN;
    global MU;
    if i == 1
        members = find_mu([1]);
        Nm1 = length(members)-1;
        if(Nm1 <= 0)
            minidx1 = members(1);
        else
            minidx1 = randi([1,length(members)],1);
        end
        newbottle = calculate_qoe(bandwidth,0,2);
        oldbottle = newbottle;
    else
        sender = find(W(i,:));
        members = find_mu(sender); %all MUs in SFN i
        Nm1 = length(members);
        QoE = zeros(1,Nm1); %every MU's QoE in the original SFN
        for k = 1:Nm1
            QoE(k) = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members(k)),AN(2:ANNum),sender-1),1);
        end
        [oldbottle,minidx1] = min(QoE);
        QoE(minidx1) = 999999;
        [newbottle,~] = min(QoE);
        %fprintf("first = %f, seconde = %f\n",oldbottle,newbottle);
        minidx1 = members(minidx1);
        Nm1 = Nm1-1;
    end
end