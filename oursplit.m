function oursplit(ANNum,bandwidth,debug)
    global bigrestart;
    global W;
    global SFNNum;
    global bottle_QoE;
    global AN;
    global MU;
    global X;
   %split(never enter)
    restart = false; 
    while(true)
        for i = 2:SFNNum
            AN_list = find(W(i,:));
            if(length(AN_list))>1 %eligible for split
                members = find_mu(AN_list); %all MUs in SFN i
                Nm = length(members);
                split_collection = ourSetPartition(AN_list); %all possible permutations of splitting an SFN i
                newscore = zeros(1,length(split_collection)); %the score for every permutation
                newscore(1) = Nm*bottle_QoE(i); %first score is reserved for the old SFN (no partitions)
                for j = 2:length(split_collection)
                    subSFN_info = zeros(length(split_collection{j}),2); %dim1-bottleneck SINR of subSFN (default:-1); dim2-number of MUs under subSFN (default:0)
                    subSFN_info(:,1) = -ones(length(split_collection{j}),1);
                    for m = 1:Nm %traverse MU to calculate bottleneck SINR of subSFN
                        for k = 1:length(split_collection{j})
                            AN_coalition = cell2mat(split_collection{j}(k));
                            if(~isempty(find(X(AN_coalition,members(m))))) %MU belongs to this subSFN
                                 temp_QoE = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members(m)),AN(2:ANNum),AN_coalition-1),1);
                                 if((subSFN_info(k,1) < 0 ) || (temp_QoE < subSFN_info(k,1))) %the first MU or worse QoE for subSFN
                                    subSFN_info(k,1) = temp_QoE;
                                 end
                                 subSFN_info(k,2) = subSFN_info(k,2)+1;
                            end
                        end
                    end
                    newscore(j) = sum(subSFN_info(:,1).*subSFN_info(:,2));
                end
                [maxscore,maxsubsfn] = max(newscore);
                if(maxsubsfn ~= 1) %successful split (never enter so not yet debugged)
                    fprintf("successful split\n");
                    W(i,:) = [];
                    bottle_QoE(i) = [];
                    subSFN_info = -ones(length(split_collection{maxsubsfn}),1); %dim1-bottleneck SINR of subSFN (default:-1)
                    for m = 1:Nm %traverse MU to calculate bottleneck SINR of subSFN
                        for k = 1:length(split_collection{maxsubsfn})
                            AN_coalition = cell2mat(split_collection{maxsubsfn}(k));
                            if(~isempty(find(X(AN_coalition,members(m))))) %MU belongs to this subSFN
                                 temp_QoE = calculate_qoe(bandwidth,partial_calculate_SINR(MU(members(m)),AN(2:ANNum),AN_coalition-1),1);
                                 if((subSFN_info(k) < 0 ) || (temp_QoE < subSFN_info(k))) %the first MU or worse QoE for subSFN
                                    subSFN_info(k) = temp_QoE;
                                 end
                            end
                            %update W
                            if(m==1)
                                tv = zeros(1,ANNum);
                                tv(AN_coalition) = 1;
                                W = cat(1,W,tv);
                            end
                        end
                    end
                    %update bottle_QoE
                    changem(subSFN_info,[0 ],[-1]);%replace -1 with 0 in bottleneck QoE
                    bottle_QoE = cat(2,bottle_QoE,subSFN_info');
                    %update SFNNum
                    restart = true; %restart the split algorithm
                    bigrestart = true;
                    SFNNum = SFNNum + 1;
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
        fprintf("!!!!!!!!!!!!!Afer Split\n");
        printW(SFNNum);
    end
end