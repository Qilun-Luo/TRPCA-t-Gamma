%% Test for Background Modeling - Qualitative
clear
close all

addpath('utils')
addpath(genpath('algs\'));

%% load data
data_path = 'data\BM-Qualitative';
file_name_list = {'hall', 'MovedObject', 'Escalator', 'Lobby'};

for test_num = 1:1
% for test_num = 1:length(file_name_list)
    file_name = file_name_list{test_num};
    mat_file = strcat('data\BM-Qualitative-Mat\', file_name);
    ext_name = 'bmp';
    show_flag = 1;
    if ~exist(strcat(mat_file, '_rgb.mat'), 'file')
        [X, height, width] = load_video_rgb(data_path, file_name, ext_name, show_flag);
        save(strcat(mat_file, '_rgb.mat'), 'X', 'height', 'width');
    else
        load(strcat(mat_file, '_rgb.mat'));
    end
    [height_width, dims, nframes] = size(X);
    sel_num = 200;
    sel_step = floor(nframes/sel_num);
    X = X(:,:,1:sel_step:sel_step*sel_num);
    [height_width, dims, nframes] = size(X);

    %% Algorithm settings
    flag_trpca_gamma = 1;

    %% t-Gamma
    if flag_trpca_gamma
        x = permute(X, [1,3,2]);
        [n1,n2,n3] = size(x);
        lambda = 1/sqrt(max(n1,n2)*n3);
        opts = [];
        opts.DEBUG = 1;
        opts.rho = 1.1;
        opts.mu = 1e-4;
        opts.gamma = n3/sqrt(min(n1, n2));
        [L, S, err, iter] = trpca_gamma(x, lambda, opts);
        L = permute(L, [1,3,2]);
        S = permute(S, [1,3,2]);
        L_trpca_gamma = reshape(L, [height_width, dims, nframes]);
        S_trpca_gamma = reshape(S, [height_width, dims, nframes]);

        flag_result_show = 1;
        if flag_result_show
            figure
            for i = 1:nframes
                subplot(1,2,1)
                imshow(uint8(reshape(L_trpca_gamma(:, :, i), [height, width, dims])))
                subplot(1,2,2)
                imshow(uint8(reshape(S_trpca_gamma(:, :, i), [height, width, dims])))
                pause(0.05)
            end
        end
    end
    
end


