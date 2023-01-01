function plot_connection(BSNum,MUNum)
    global AN;
    global MU;
    global X;
    labels = reshape(split(num2str(2: 1: BSNum+1)), 1, BSNum);
    figure(1); plot(MU,'x'); title('Connection'); xlabel('x-axis(m)'); ylabel('y-axis(m)'); hold on;
    plot(AN(2:BSNum+1),'ro'); hold on;
    text(real(AN(2:BSNum+1)), imag(AN(2:BSNum+1)), labels, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left'); hold on;
    for i = 1:MUNum
        BSidx = find(X(:,i));
        plot([real(AN(BSidx)); real(MU(i))], [imag(AN(BSidx)); imag(MU(i))],'--gs'); hold on;
    end
    hold off;
end