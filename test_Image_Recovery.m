%% Test for Image Recovery
clear
close all

rng('shuffle')

addpath('utils')
addpath(genpath('algs\'));

%% Path setting
data_path = 'data';
folder_name = 'BSD';
ext_name = 'jpg';

imageNames = dir(fullfile(data_path, folder_name, strcat('*.',ext_name)));
imageNames = {imageNames.name}';

nimg = length(imageNames); % number of testing images
% nimg = 2; % small scale test

nalg = 1; % number of testing algorithms
psnr_all = zeros(nimg, nalg); % results of the algs
ssim_all = zeros(nimg, nalg);
psnr_sample = zeros(nimg, 1); % results of the sample
ssim_sample = zeros(nimg, 1);


for i = 1:nimg
    %% Data loading
    im_name = fullfile(data_path,folder_name,imageNames{i});
    X = double(imread(im_name))/255;
    maxP = max(abs(X(:)));
    [n1,n2,n3] = size(X);
    Xn = X;
    
    rhos = 0.1; % corrupted rate
    ind = find(rand(n1*n2,1)<rhos);
    for j = 1:n3
        tmp = X(:,:,j);
        tmp(ind) = rand(length(ind),1);
        Xn(:,:,j) = tmp;
    end
    
    %% Algs setting
    flag_trpca_gamma = 1;

    %% Running
    psnr_list = [];
    ssim_list = [];
    alg_name = {};
    alg_result = {};
    alg_cnt = 1;
    
    %% Sample
    X_psnr_sample = psnr(Xn, X);
    X_ssim_sample = ssim(Xn, X);
    psnr_list(alg_cnt) = X_psnr_sample;
    ssim_list(alg_cnt) = X_ssim_sample;
    alg_name{alg_cnt} = 'Corrupted';
    alg_result{alg_cnt} = Xn;
    alg_cnt = alg_cnt + 1;
    
    %% t-Gamma
    if flag_trpca_gamma
        opts = [];
        opts.gamma = sqrt(min(n1, n2));
        opts.mu = 1e-4;
        opts.tol = 1e-7;
        opts.rho = 1.1;
        opts.max_iter = 500;
        opts.DEBUG = 0;
        opts.max_mu = 1e10;
        lambda = 1/sqrt(max(n1,n2)*n3);
        [X_gamma, S_gamma, err, iter] = trpca_gamma(Xn, lambda, opts);
        X_dif_gamma = X_gamma - X;
        res_gamma = norm(X_dif_gamma(:))/norm(X(:));
        X_psnr_gamma = psnr(X_gamma, X);
        X_ssim_gamma = ssim(X_gamma, X);
        psnr_list(alg_cnt) = X_psnr_gamma;
        ssim_list(alg_cnt) = X_ssim_gamma;
        alg_name{alg_cnt} = 'trpca-t-gamma';
        alg_result{alg_cnt} = X_gamma;
        alg_cnt = alg_cnt + 1;
    end
    
    psnr_sample(i) = psnr_list(1);
    ssim_sample(i) = ssim_list(1);
    psnr_all(i, :) = psnr_list(2:end);
    ssim_all(i, :) = ssim_list(2:end);
    
    %% Result table
    flag_table_report = 1;
    if flag_table_report
        fprintf('%4s', 'metric');
        for j = 1:alg_cnt-1
            fprintf('\t%4s', alg_name{j});
        end
        fprintf('\n')
        fprintf('%4s', 'PSNR');
        for j = 1:alg_cnt-1
            fprintf('\t%.4f', psnr_list(j));
        end
        fprintf('\n')
        fprintf('%4s', 'SSIM');
        for j = 1:alg_cnt-1
            fprintf('\t%.4f', ssim_list(j));
        end
        fprintf('\n')
    end
    
    %% draw
    draw_flag = 1;
    if draw_flag
        figure
        ha = tight_subplot(1, nalg+2, [0 .01],[0 0],[0 0]);
        axes(ha(1));
        imshow(X,'border','tight','initialmagnification','fit');
        title('Original');
        for j = 1:alg_cnt-1
            axes(ha(j+1));
            imshow(alg_result{j},'border','tight','initialmagnification','fit')
            title(alg_name{j});
        end
    end
      
end

%% Compute average
flag_report_avg = 1;
if flag_report_avg
    psnr_avg = mean([psnr_sample psnr_all]);
    ssim_avg = mean([ssim_sample ssim_all]);
    % report table
    disp('Average Results')
    fprintf('%4s', 'metric');
    for j = 1:alg_cnt-1
        fprintf('\t%4s', alg_name{j});
    end
    fprintf('\n')
    fprintf('%4s', 'Avg-PSNR');
    for j = 1:alg_cnt-1
        fprintf('\t%.4f', psnr_avg(j));
    end
    fprintf('\n')
    fprintf('%4s', 'Avg-SSIM');
    for j = 1:alg_cnt-1
        fprintf('\t%.4f', ssim_avg(j));
    end
    fprintf('\n')
end





