function MU_reassignment(ANNum,bandwidth,debug)
    global bigrestart;
    global W;
    global SFNNum;
    global bottle_QoE;
    global AN;
    global MU;
    global X;
    global MUinS;
    %MU's SFN reassignment
    restart = false; 
    while(true)
        for i = 2:SFNNum
            if i == 1 && isempty(find(X(1,:)))
                continue;
            end
            [minidx1,newbottle1,oldbottle1,Nm1] = find_bottleuser(i,ANNum,bandwidth); %minidx1 = bottleneck user of SFN i; newbottle = the bottleneck QoE if MU leaves the SFN
            if(isempty(minidx1)) %no MUs is under SFN i
                continue;
            end
            %let MU select other SFN
            for j = 1:SFNNum
                if(j == i)
                    continue;
                end
                sender2 = find(W(j,:));
                members2 = find_mu(sender2);
                Nm2 = length(members2);
                oldscore = oldbottle1*(Nm1+1)+bottle_QoE(j)*Nm2;
                if j == 1 %satellite
                    replace_QoE = bottle_QoE(1);
                else
                    temp_QoE = calculate_qoe(bandwidth,partial_calculate_SINR(MU(minidx1),AN(2:ANNum),sender2-1),1);
                    replace_QoE = min(temp_QoE,bottle_QoE(j));
                end
                newscore =newbottle1*Nm1+replace_QoE*(Nm2+1);
                %fprintf("%f %f vs %f %f\n",oldbottle1,bottle_QoE(j),newbottle1,replace_QoE);
                if newscore > oldscore
                    if(debug)
                        fprintf("successful transfer of MU %d: %d -> %d\n",minidx1,i,j);
                    end
                    bottle_QoE(i) = newbottle1;
                    bottle_QoE(j) = replace_QoE;
                    oldAN = find(X(:,minidx1));
                    newAN = find_closeAN(minidx1,sender2);
                    X(oldAN,minidx1) = 0;
                    X(newAN,minidx1) = 1;
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
end