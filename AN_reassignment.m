function AN_reassignment(ANNum,bandwidth,debug)
    global bigrestart;
    global W;
    global SFNNum;
    global bottle_QoE;
    global AN;
    global MU;
 %AN's SFN reassignment (never enter)
    restart = false; 
    while(true)
        for i = 2:ANNum
            oldSFN = find(W(:,i)); %original SFN that AN i belongs to
            members0 = find_mu([i]); %MUs of AN i
            Nm0 = length(members0);
            sender1 = find(W(oldSFN,:)); %ANs of original SFN that AN i belongs to (no AN i)
            sender1 = sender1(sender1~=i);
            members1 = find_mu(sender1); %MUs of original SFN (no AN i)
            Nm1 = length(members1);
            is_single = false; %whether AN i is a single AN in its SFN -> merge
            if(length(sender1) == 1)
                is_single = true;
            end
            SFN_cand = 2:SFNNum; %possible SFNs AN i is going to move to
            SFN_cand = SFN_cand(SFN_cand~=oldSFN);
            for j = 1:length(SFN_cand)
                sender2 = find(W(SFN_cand(j),:)); %ANs of target SFN that AN i is moving to
                members2 = find_mu(sender2); %MUs of target SFN
                Nm2 = length(members2);
                oldscore = (Nm1+Nm0)*bottle_QoE(oldSFN)+Nm2*bottle_QoE(SFN_cand(j));
                replace_QoE2 = zeros(1,Nm2+Nm0); %every MU's QoE in the new SFN
                sender2_prime = [i sender2]; %AN is is moved to the new SFN
                members2_prime = [members0 members2];
                for k = 1:Nm2+Nm0
                    replace_QoE2(k) = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members2_prime(k)),AN(2:ANNum),sender2_prime-1),1);
                end
                if is_single
                    newscore = min(replace_QoE2)*(Nm2+Nm0);
                else
                    replace_QoE1 = zeros(1,Nm1); %every MU's QoE in the original SFN
                    for k = 1:Nm1
                        replace_QoE1(k) = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members1(k)),AN(2:ANNum),sender1-1),1);
                    end
                    newscore = min(replace_QoE2)*(Nm2+Nm0)+min(replace_QoE1)*Nm1;
                end
                %fprintf("%d %d->%d old = %f, new = %f\n",i,oldSFN,SFN_cand(j),oldscore, newscore);
                %fprintf("QoE %f+%f vs %f+%f\n", bottle_QoE(oldSFN),bottle_QoE(SFN_cand(j)),min(replace_QoE1),min(replace_QoE2));
                if(oldscore < newscore) %a successful transfer
                    if(debug)
                        fprintf("successful transfer of AN\n");
                    end
                    if is_single
                        W(SFN_cand(j),i) = 1; %update relevant variables 
                        W(oldSFN,:) = [];
                        bottle_QoE(SFN_cand(j)) = min(replace_QoE2);
                        bottle_QoE(oldSFN) = [];
                        SFNNum = SFNNum -1;
                    else
                        W(SFN_cand(j),i) = 1; %update relevant variables 
                        W(oldSFN,i) = 0;
                        bottle_QoE(SFN_cand(j)) = min(replace_QoE2);
                        bottle_QoE(oldSFN) = min(replace_QoE1);
                    end
                    if(debug)
                        printW(SFNNum);
                    end
                    restart = true;
                    bigrestart = true;
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
        fprintf("!!!!!!!!!!!!!Afer AN reassignment\n");
        printW(SFNNum);
    end
end