function plotmatrixcorr(varargin)
%PLOTMATRIXCORR The function takes each column of a matrix as a variable
%   and create the scatter plot of the correlation between variables. 
%   The function sets a linear model to the data and graph the results in
%   the upper diagonal matrix. In the main diagonal places the name of the 
%   variable and the lower triangular matrix shows the linear fit equation, 
%   the coefficient of determination and Pearson correlation.
%  
%   PLOTMATRIXCORR(X) scatter plots the columns of X where each column
%   represents a variable
%   PLOTMATRIXCORR(X,LABELS) put the labels of LABELS input into the main
%   diagonal (P1, P2, P3,..., Pn as default)
%
% Example
%
% r=rand(5);
% plotmatrixcorr(r)

% By Saul Arciniega Esparza
% zaul.ae@gmail.com
% 27/08/2015
% Inspired in PLOTMATRIX of Clay M. Thompson 10-3-94 


%% Extrac data
if length(varargin)==0
    error('MATLAB:plotmatrix:InvalidLineSpec','Error in input arguments')
end
x=varargin{1}; % Data matrix mxn
cols=size(x,2); rows=cols;
if length(varargin)==2
    labels=varargin{2};
else
    labels={};
    for i=1:cols
        labels{i}=['P' num2str(i)]; % Default labels
    end
end


%% Define default properties
sym='.'; % Default scatter plot symbol.
symc='k'; % Default symbol color.
lfitc='b'; % Default linear fit line color.
linc='r'; % Default line 1:1 color.
space=0.02; % 2 percent space between sub-axes.
inset=0.15; % 10 percent limits of x and y

%% Coeficients and linear fit
Mcorr=zeros(rows,cols); % Correlation matrix
Mr2=zeros(rows,cols); % Determinaction coeficient
Ma=zeros(rows,cols); % Lineal fit, a value, y=ax+b
Mb=zeros(rows,cols); % Lineal fit, b value, y=ax+b
for i=rows:-1:1
    for j=cols:-1:1
        % Delete nans
        x1=x(:,i); %ydata
        x2=x(:,j); %xdata
        pos=find(isnan(x1));
        x1(pos)=[]; x2(pos)=[];
        pos=find(isnan(x2));
        x1(pos)=[]; x2(pos)=[];
        % Correlation
        Mcorr(i,j)=corr(x2,x1);
        % Linear fit
        eq=polyfit(x2,x1,1);
        Ma(i,j)=eq(1); Mb(i,j)=eq(2);
        y=polyval(eq,x2);
        Mr2(i,j)=sum((y-mean(x1)).^2)/sum((x1-mean(x1)).^2);
    end
end

%% xlimits and ylimits
Mmm=[min(x)' max(x)']; % Matrix of mins and max
d=(Mmm(:,2)-Mmm(:,1))*inset; % diference between axes limits and extreme values
Mlim=[Mmm(:,1)-d Mmm(:,2)+d]; %Matrix of limits

%% Create BigAx and make it invisible
BigAx=newplot;
fig=ancestor(BigAx,'figure');
hold_state=ishold(BigAx);
hold on
plot(0,0,[sym symc])
plot(0,0,['-' lfitc])
plot(0,0,['-' linc])
legend({'Data','Linear fit','Line 1:1'},'Color',[1 1 1],'Location','SouthOutside','Orientation','Horizontal')
set(BigAx,'Visible','off','color','none')


%% Plot into sub-axes
ax=zeros(rows,cols);
pos=get(BigAx,'Position');
width=pos(3)/cols;
height=pos(4)/rows;
pos(1:2)=pos(1:2)+space*[width height];
m=size(x,1);
k=size(x,3);
BigAxHV=get(BigAx,'HandleVisibility');
BigAxParent=get(BigAx,'Parent');
paxes=findobj(fig,'Type','axes','tag','PlotMatrixScatterAx');


for i=rows:-1:1,
    for j=cols:-1:1,
        axPos=[pos(1)+(j-1)*width pos(2)+(rows-i)*height ...
            width*(1-space) height*(1-space)];
        findax=findaxpos(paxes, axPos);
        if isempty(findax),
            ax(i,j)=axes('Position',axPos,'HandleVisibility',BigAxHV,'parent',BigAxParent);
            set(ax(i,j),'visible','on');
        else
            ax(i,j) = findax(1);
        end
        if j>i % Plot axes
            plot(ax(i,j),x(:,j),x(:,i),[sym symc])
            xlim(Mlim(j,:));
            hold on
            y=Ma(i,j)*xlim'+Mb(i,j);
            plot(ax(i,j),xlim,y,['-' lfitc])
            plot(ax(i,j),xlim,xlim,['-' linc])
            ylim(Mlim(i,:));
            set(gca,'XAxisLocation','top','Xtick',round(linspace(Mmm(j,1),Mmm(j,2),3)*100)/100)
            set(gca,'YAxisLocation','right','Ytick',round(linspace(Mmm(i,1),Mmm(i,2),3)*100)/100)
            if i~=1
                set(gca,'Xticklabel',[])
            end
            if j~=cols
                set(gca,'Yticklabel',[])
            end
        elseif j<i % Coeficients axes
            axis([-1 1 -1 1])
            set(gca,'Xtick',[-1 1],'Xticklabel',[],'Ytick',[-1 1],'Yticklabel',[])
            box
            ttext=[{sprintf('y=%.2fx%+.2f',Ma(i,j),Mb(i,j))}];
            ttext=[ttext;{sprintf('r^2=%+.3f',Mr2(i,j))}];
            ttext=[ttext;{sprintf('  p=%+.3f',Mcorr(i,j))}];
            text(0,0,ttext,'HorizontalAlignment','center','VerticalAlignment','middle','fontsize',10)
        elseif i==j % Label axes
            axis([-1 1 -1 1])
            set(gca,'Xtick',[-1 1],'Xticklabel',[],'Ytick',[-1 1],'Yticklabel',[])
            box
            text(0,0,labels{i},'HorizontalAlignment','center','VerticalAlignment','middle','fontsize',12)
        end
    end
end
%% Axes of legend in BigAxes
set(fig,'CurrentAx',BigAx)
end


function str=id(str)
str = ['MATLAB:plotmatrix:' str];
end

function findax = findaxpos(ax, axpos)
tol = eps;
findax = [];
for i = 1:length(ax)
    axipos = get(ax(i),'Position');
    diffpos = axipos - axpos;
    if (max(max(abs(diffpos))) < tol)
        findax = ax(i);
        break;
    end
end
end
