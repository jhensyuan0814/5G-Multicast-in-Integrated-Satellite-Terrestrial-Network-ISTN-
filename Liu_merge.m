function Liu_merge(bandwidth,ANNum,debug)
    global W;
    global SFNNum;
            restart = false; 
            while(true)
                pairing = zeros((SFNNum-1)*(SFNNum-2)/2,2);
                count = 1;
                for i = 2:SFNNum
                    for j = i+1:SFNNum
                        pairing(count,1) = i;
                        pairing(count,2) = j;
                        count = count +1;
                    end
                end
                Merge_qS = zeros(1,SFNNum);
                for i = 2:SFNNum
                    sender = find(W(i,:));
                    members = find_mu(sender);
                    bottle =  Liu_calculate_bottleSINR(members,sender,ANNum);
                    Merge_qS(i) = length(members)*log(bandwidth*log(1+bottle));
                end
                [m,n] = size(pairing);   
                Merge_qSAB = zeros(1,m);
                Merge_qMAB = zeros(1,m);
                for i = 1:m
                    if m == 1
                        A = pairing(1);
                        B = pairing(2);
                    else
                        A = pairing(i,1);
                        B = pairing(i,2);
                    end
                    Merge_qSAB(i) = Merge_qS(A)+Merge_qS(B);
                    sender = union(find(W(A,:)),find(W(B,:)));
                    members = find_mu(sender);
                    bottle = Liu_calculate_bottleSINR(members,sender,ANNum);
                    Merge_qMAB(i) = length(members)*log(bandwidth*log(1+bottle));
                end
                Merge_wAB = Merge_qMAB - Merge_qSAB;
                [max_Merge_wAB,maxidx] = max(Merge_wAB);
                if max_Merge_wAB >0
                    restart = true;
                    maxA = pairing(maxidx,1);
                    maxB = pairing(maxidx,2);
                    tv = W(maxA,:)|W(maxB,:);
                    W(maxA,:) = tv;
                    W(maxB,:) = [];
                    SFNNum = SFNNum - 1;
                    if(debug)
                        fprintf("successful Liu merge %d %d\n",maxA,maxB);
                    end
                end
                if restart == false
                    break;
                else
                    restart = false;
                end
            end
            if(debug)
                fprintf("!!!!!!!!!!!!!Afer Liu Merge\n");
                printW(SFNNum);
            end
end