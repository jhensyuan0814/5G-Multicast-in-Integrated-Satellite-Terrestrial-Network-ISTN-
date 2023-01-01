clear all;
clear plt;

MUNum_collection = 3000;
version_collection = [1:3];
debug = false; %you want to print the information about SFN during the algorithm
final_result = zeros(length(MUNum_collection),length(version_collection)); %the final scores
scenario =3;
print_result = false;

for CM = 1:length(MUNum_collection)
    for VER = 1:length(version_collection)
        disp(version_collection(VER));
        version = version_collection(VER); %1:ours; 2:all SFN; 3:all PTM
        %parameter
        bandwidth = 10 ^ 7;
        side = 15000; %ISD 
        BSNum = 19; %total number of BSs
        MUNum = MUNum_collection(CM); %total number of MUs
        ANNum = BSNum+1; %total number of ANs
        CNum = 3; %total number of contents

        %global variable
        global MU; %position in complex number
        global AN; %position in complex number
        global W; %SFNNum*ANNum; idx'1' is reserved for the satellite
        global Y; %MUNum*CNum
        global X; %ANNum*MUNum; idx'1' is reserved for the satellite
        global bottle_QoE; %1*SFNNum; bottleneck SINR for each SFN
        global SCmax;
        global SFNNum;
        global bigrestart;
        side = 45000; %ISD 
        %ini_BSMU(side,BSNum,MUNum,scenario); %initialize position of BSs and MUs
        ini_BSMU_hex_c(side,BSNum,MUNum,scenario); %side = ISD
        %plot_BSMU(BSNum,side,scenario);

        ini_ourSFN(ANNum,version); %each AN is an SFN

        %this part is unused yet
        Y = zeros(CNum,MUNum); %initial content
        yidx = [0:CNum:(MUNum-1)*CNum]+ randi([1,CNum],1,MUNum);
        Y(yidx) = 1;
        Y = Y';
        
 
        X = zeros(ANNum,MUNum); %initialize SINR
        SINR = zeros(ANNum,MUNum);
        if version == 3  && (ANNum == 20 || ANNum == 8) %PTM with reuse factor
            for i = 1:MUNum %select the BS with maximum SINR for each MU (satellite isn't considered)
                SINR([2:ANNum],i) = ini_calculate_SINR(MU(i),AN(2:ANNum)); %may need to modify when iniSFN is different
                max_QoE = -999;
                max_SFN = -1;
                for j = 2:SFNNum
                    sender = find(W(j,:));
                    temp_QoE = calculate_qoe(bandwidth,partial_calculate_SINR(MU(i),AN(2:ANNum),sender-1),1);
                    if(temp_QoE>max_QoE)
                        max_QoE = temp_QoE;
                        max_SFN = j;
                    end
                    %disp(temp_QoE);
                end
                X(max_SFN,i) = 1;
            end
        else
            for i = 1:MUNum %select the BS with maximum SINR for each MU (satellite isn't considered)
                SINR([2:ANNum],i) = ini_calculate_SINR(MU(i),AN(2:ANNum)); %may need to modify when iniSFN is different
                [~, maxidx] = max(SINR([2:ANNum],i));
                X(maxidx+1,i) = 1;
            end
        end
        if version ==2
            QoE = calculate_qoe(bandwidth,SINR,0);
            bottle_QoE(1) = calculate_qoe(bandwidth,0,2);
            %calculate_score(bandwidth,ANNum,version);
            %MU_reassignment(ANNum,bandwidth,debug);
            final_result(CM, VER) = calculate_score(bandwidth,ANNum,version); %all SFN
        else
            QoE = calculate_qoe(bandwidth,SINR,0);
            bottle_QoE(1) = calculate_qoe(bandwidth,0,2);
            for j = 2:ANNum
                target = find(X(j,:));
                if(isempty(target))
                    minQoE = 0;
                else
                    minQoE = min(QoE(j,target));
                end
                bottle_QoE(j) = minQoE;
            end
        end
        if(version ==3)
            %calculate_score(bandwidth,ANNum,version);
            %MU_reassignment(ANNum,bandwidth,debug);
            final_result(CM, VER) = calculate_score(bandwidth,ANNum,version); %all PTM
        end
        %plot_connection(BSNum,MUNum); %see the relationship between BS and MU
        bigrestart = true;
        while(bigrestart == true && version ==1)
            bigrestart = false;
            ourmerge(ANNum,bandwidth,debug);
            oursplit(ANNum,bandwidth,debug);
            AN_reassignment(ANNum,bandwidth,debug);
            %MU_reassignment(ANNum,bandwidth,debug);    
        end
        while(bigrestart == true && version ==0)
            bigrestart = false;
            ourmerge(ANNum,bandwidth,debug);
            oursplit(ANNum,bandwidth,debug);
            AN_reassignment(ANNum,bandwidth,debug);
            MU_reassignment(ANNum,bandwidth,debug);    
        end
        if(version ==1 | version == 0)
            final_result(CM, VER) = calculate_score(bandwidth,ANNum,version);
            plot_BSMU(BSNum,side,scenario);
            %plot_SFN(BSNum,side,scenario);
        end
        if(version == 4)
            Liu_split(bandwidth,ANNum,debug);
            Liu_merge(bandwidth,ANNum,debug);
            final_result(CM, VER) = calculate_score(bandwidth,ANNum,version); %Liu's method
        end
    end
end
final_result = final_result*2.5;
if print_result
    final_result = final_result';
    hfig = figure(1);
    plot(MUNum_collection, final_result(1, :), '--o','LineWidth', 2);
    hold on;
    plot(MUNum_collection, final_result(2, :), '--d','LineWidth', 2);
    hold on;
    plot(MUNum_collection, final_result(3, :), '--x','LineWidth', 2);
    hold on;
    plot(MUNum_collection, final_result(4, :), '--h','LineWidth', 2);
    hold on;
    plot(MUNum_collection, final_result(5, :), '--^','LineWidth', 2);
    hold off;
    xlabel('number of MUs');
    ylabel('QoE score');
    set(gca,'FontSize',16);
    legend('Proposed with satellite','Proposed without satellite', 'All SFN', 'All PTM', 'GGPA', 'Location','northwest','FontSize',12);
    topic = sprintf("Score for MUNum scenario %d",scenario);
    %title(topic); 
    topic = sprintf("%d",scenario);
    saveas(gcf,'pic_capacity/'+topic+'.png');
    grid on;
end