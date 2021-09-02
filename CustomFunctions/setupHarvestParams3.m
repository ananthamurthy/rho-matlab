%% SETUP HARVEST PARAMETERS - All Methods
job = 0;
%1
job = job + 1;
params(job).fileLocation = sprintf('%s/Imaging/%s/%s/', ANALYSIS_DIR, db.mouseName, db.date);
params(job).methodList = 'A';
params(job).sdcpStart = 1;
params(job).sdcpEnd = 96;
params(job).gDate = 20210714;
params(job).gRun = 1;
params(job).trim = 0;
params(job).trimRun = 0;

%2
job = job + 1;
params(job).fileLocation = sprintf('%s/Imaging/%s/%s/', ANALYSIS_DIR, db.mouseName, db.date);
params(job).methodList = 'B';
params(job).sdcpStart = 1;
params(job).sdcpEnd = 96;
params(job).gDate = 20210714;
params(job).gRun = 1;
params(job).trim = 0;
params(job).trimRun = 0;

%3
job = job + 1;
params(job).fileLocation = sprintf('%s/Imaging/%s/%s/', ANALYSIS_DIR, db.mouseName, db.date);
params(job).methodList = 'C';
params(job).sdcpStart = 1;
params(job).sdcpEnd = 96;
params(job).gDate = 20210714;
params(job).gRun = 1;
params(job).trim = 0;
params(job).trimRun = 0;

%4
job = job + 1;
params(job).fileLocation = sprintf('%s/Imaging/%s/%s/', ANALYSIS_DIR, db.mouseName, db.date);
params(job).methodList = 'D';
params(job).sdcpStart = 1;
params(job).sdcpEnd = 96;
params(job).gDate = 20210714;
params(job).gRun = 1;
params(job).trim = 0;
params(job).trimRun = 0;

%5
job = job + 1;
params(job).fileLocation = sprintf('%s/Imaging/%s/%s/', ANALYSIS_DIR, db.mouseName, db.date);
params(job).methodList = 'E';
params(job).sdcpStart = 1;
params(job).sdcpEnd = 96;
params(job).gDate = 20210714;
params(job).gRun = 1;
params(job).trim = 0;
params(job).trimRun = 0;

%6
job = job + 1;
params(job).fileLocation = sprintf('%s/Imaging/%s/%s/', ANALYSIS_DIR, db.mouseName, db.date);
params(job).methodList = 'F';
params(job).sdcpStart = 1;
params(job).sdcpEnd = 96;
params(job).gDate = 20210714;
params(job).gRun = 1;
params(job).trim = 0;
params(job).trimRun = 0;