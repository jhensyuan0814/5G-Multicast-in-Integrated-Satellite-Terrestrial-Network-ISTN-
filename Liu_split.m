function Liu_split(bandwidth,ANNum,debug)
            global W;
            global X;
            global SFNNum;
            restart = false; 
            while(true)
                Split_QV = Liu_calculate_SplitQV(bandwidth,ANNum); 
                sender = find(W(2,:));
                members = find_mu(sender);
                Split_Qj = zeros(1,length(sender));
                for i = 1:length(sender) %pick each AN from V1
                    members1 = find(X(sender(i),:));
                    members2 = setdiff(members,members1);
                    sender1 = sender(i);
                    sender2 = setdiff(sender,sender1);
                    bottle1 = Liu_calculate_bottleSINR(members1,sender1,ANNum);
                    bottle2 = Liu_calculate_bottleSINR(members2,sender2,ANNum);
                    Split_Qj(i) = length(members1)*log(bandwidth*log(1+bottle1))+length(members2)*log(bandwidth*log(1+bottle2));
                end
                Split_gj = Split_Qj - Split_QV;
                [max_Split_gj,maxidx] = max(Split_gj);
                if max_Split_gj >0
                    restart = true;
                    maxidx = sender(maxidx);
                    W(2,maxidx) = 0;
                    tv = zeros(1,ANNum);
                    tv(maxidx) = 1;
                    W = cat(1,W,tv);
                    SFNNum = SFNNum + 1;
                    if(debug)
                        fprintf("successful Liu split %d\n",maxidx);
                    end
                end
                if restart == false
                    break;
                else
                    restart = false;
                end
            end
            if(debug)
                fprintf("!!!!!!!!!!!!!Afer Liu Split\n");
                printW(SFNNum);
            end
end