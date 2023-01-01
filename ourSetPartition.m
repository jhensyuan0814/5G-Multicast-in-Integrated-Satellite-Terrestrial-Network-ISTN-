function split_collection = ourSetPartition(AN_list)
        split_collection = SetPartition(AN_list,1); %all possible permutations of splitting an SFNtl
        for k = 1:length(AN_list)
            tarray = AN_list;
            tarray(k) = [];
            tcell = {AN_list(k),tarray};
            split_collection =  cat(1,split_collection,{tcell});
            if(length(AN_list)==2)
                break;
            end
        end
end