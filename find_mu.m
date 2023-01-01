function members = find_mu(sender)
    global X;
    members = [];
    for k = 1:length(sender)
        members = cat(2,members,find(X(sender(k),:))); 
    end
end