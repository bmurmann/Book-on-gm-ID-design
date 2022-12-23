function format_and_save(fighandle, filename, varargin)
% format_and_save(fighandle, filename, varargin)
% default values for optional parameters:
% W = 4 (inches)
% H = 3 (inches)
% FontSize = 9
%
% Usage example:
% format_and_save(h, 'MyFigure', 'W', 7, 'H', 6, 'FontSize', 12)
defaultW = 4;
defaultH = 3;
defaultFontSize = 9;

% parse optional parameters
p = inputParser; 
p.addParamValue('W', defaultW);
p.addParamValue('H', defaultH);
p.addParamValue('FontSize', defaultFontSize);
p.parse(varargin{:});
par = p.Results;

% first save a copy of the original figure in figure format as a backup
saveas(fighandle, filename, 'fig');

% create a duplicate figure
%h=figure(get(fighandle,'Number')+100);
h=figure(100);
copyobj(get(fighandle,'children'),h);
drawnow;

% get the position of the original figure and place it to the right
% position vector: [left, bottom, width, height]:
set(fighandle, 'units', 'inches');
pos = get(fighandle, 'position');
set(fighandle, 'units', 'inches');
set(fighandle, 'position', [pos(1)+pos(3)+0.25 pos(2)+(pos(4)-par.H) par.W par.H]);
set(fighandle, 'Name', strcat(filename, '.png'), 'NumberTitle','off');

% format the figure
AX = get(fighandle, 'children');
for i = 1:length(AX)
    if strcmp(get(AX(i),'tag'), 'legend')
        set(AX(i), 'FontSize', par.FontSize);
        set(AX(i), 'FontName', 'Arial');
    else
    set(AX(i), 'FontSize', par.FontSize);
    set(AX(i), 'FontName', 'Arial');
    set(get(AX(i),'Ylabel'),'fontsize', par.FontSize);
    set(get(AX(i),'Xlabel'),'fontsize', par.FontSize);
    set(get(AX(i),'Title'),'fontsize', par.FontSize);
    set(AX(i), 'LooseInset', get(gca,'TightInset'))
    end
end 

% save the figure in tiff and eps files
savename1 = strcat(filename, '.png');
savename2 = strcat(filename, '.eps');
savename3 = strcat(filename, '.tif');
set(fighandle, 'PaperPositionMode', 'auto');
print(fighandle, '-dpng', '-r600', savename1);
print(fighandle, '-deps', savename2);
print(fighandle, '-dtiff', '-r1200', savename3);


