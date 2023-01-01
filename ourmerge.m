function ourmerge(ANNum,bandwidth,debug)
    global bigrestart;
    global W;
    global SFNNum;
    global bottle_QoE;
    global AN;
    global MU;
    %merge
    restart = false; % rerun the process of merge when there is a successful merge
    while(true)
        for i = 2:SFNNum-1
            for j = i+1:SFNNum
                sender1 = find(W(i,:));
                sender2 = find(W(j,:));
                sender = cat(2,sender1,sender2); %ANs in SFN i and SFN j
                members = find_mu(sender1); %MUs in SFN i and SFN j
                Nm1 = length(members);
                members = cat(2,members,find_mu(sender2));
                Nm2 = length(members)-Nm1;
                oldscore = Nm1*bottle_QoE(i)+Nm2*bottle_QoE(j);
                replace_QoE = zeros(1,Nm1+Nm2); %every MU's QoE in the new SFN
                for k = 1:Nm1+Nm2
                    replace_QoE(k) = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members(k)),AN(2:ANNum),sender-1),1);
                end
                newscore = min(replace_QoE)*(Nm1+Nm2);
                if oldscore < newscore %merge condition is satisfied
                    %fprintf("THIS is %d %d\n",i,j);
                    %fprintf("%f * %d + %f *%d =  %f vs %f * %d = %f\n",bottle_QoE(i),Nm1,bottle_QoE(j),Nm2,oldscore,min(replace_QoE),Nm1+Nm2,newscore);
                    W(j,:) = W(i,:) |  W(j,:); %update relevant variables as two SFNs are merged
                    W(i,:) = [];
                    bottle_QoE(j) = min(replace_QoE);
                    bottle_QoE(i) = [];
                    restart = true; %restart the merge algorithm
                    bigrestart = true;
                    SFNNum = SFNNum-1;
                    %printW(SFNNum);

                end
                if(restart)
                    break;
                end
            end
            if(restart)
                break;
            end
        end
        if(restart == false) %cannot improve
            break;
        else
            restart = false;
        end
    end
    if(debug)
        fprintf("!!!!!!!!!!!!!Afer Merge\n");
        printW(SFNNum); %print the final relationship between SFNs and ANs
    end
end