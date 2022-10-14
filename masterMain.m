% This file executes the main function for a set of time series
files = {'b41043.txt', 'b41044.txt', 'b41046.txt', 'b41047.txt', 'b41048.txt', 'b41049.txt', 'b46001.txt', 'b46075.txt','HS_SIMAR.txt'};
warning('off');
c = clock;
folder = ['reports' filesep num2str(c(1)) '-' num2str(c(2)) '-'  num2str(c(3)) '-' num2str(c(4)) '-' num2str(c(5)) '-' num2str(uint8(c(6)))];
mkdir('.',folder)

for file=1:numel(files),
    serie=load(['time_series' filesep char(files(file))]);
    serie=serie(:,2);
    filename = char(files(file));
    [H, mu, sigma, delta, gamma] = main(serie,50,folder,filename);
end
