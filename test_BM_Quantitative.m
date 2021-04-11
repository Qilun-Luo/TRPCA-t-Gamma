%% Test for Background Modeling - Quantitative

clear
close all

addpath('utils')
addpath(genpath('algs\'));

%% load data
cate_list = {
    'baseline'
};
file_list = {
    {'highway', 'pedestrians', 'PETS2006'}
};
range_list = {
    {[900, 1000], [900, 1000], [900, 1000]}
};


%% algorithm run
flag_trpca_gamma = 1;

%% main
for c = 1:length(cate_list)
    for f = 1:length(file_list{c})
        category = cate_list{c};
        idxFrom = range_list{c}{f}(1);
        idxTo = range_list{c}{f}(2);

        file_name = file_list{c}{f};

        data_path = 'data\dataset2014\dataset';
        dataset_name = strcat(category, '\', file_name, '\input\');


        output_path = 'data\dataset2014\results\';
        output_folder = strcat(category, '\', file_name, '\');

        mat_file = strcat('data\quantitative\', file_name, '_', num2str(idxFrom), '_', num2str(idxTo));
        ext_name = 'jpg';
        show_flag = 1;
        if ~exist(strcat(mat_file, '_rgb.mat'), 'file')
            [X, height, width, imageNames] = load_video_for_quantitative(data_path, dataset_name, ext_name, show_flag, idxFrom, idxTo);
            save(strcat(mat_file, '_rgb.mat'), 'X', 'height', 'width', 'imageNames');
        else
            load(strcat(mat_file, '_rgb.mat'));
        end
        [height_width, dims, nframes] = size(X);

        %% t-Gamma
        if flag_trpca_gamma
            x = permute(X, [1,3,2]);
            [n1,n2,n3] = size(x);
            lambda = 1/sqrt(max(n1,n2)*n3);
            opts = [];
            opts.DEBUG = 0;
            opts.rho = 1.1;
            opts.mu = 1*1e-5;
            opts.gamma = n3/sqrt(min(n1, n2));
            [L, S, err, iter] = trpca_gamma(x, lambda, opts);
            L = permute(L, [1,3,2]);
            S = permute(S, [1,3,2]);
            L_trpca_gamma = reshape(L, [height_width, dims, nframes]);
            S_trpca_gamma = reshape(S, [height_width, dims, nframes]);
            figure
            for i = 1:nframes
                subplot(1,3,1)
                imshow(uint8(reshape(L_trpca_gamma(:, :, i), [height, width, dims])))
                subplot(1,3,2)
                S_trpca_gamma_frame = reshape(S_trpca_gamma(:, :, i), [height, width, dims]);
                imshow(uint8(S_trpca_gamma_frame));
                subplot(1,3,3)
                Tmask_trpca_gamma = medfilt2(double(hard_threshold(mean(S_trpca_gamma_frame,3))),[5 5]);
                imshow(Tmask_trpca_gamma)
                save_path = strcat(output_path, output_folder, 't_gamma');
                if ~exist(save_path, 'dir')
                    mkdir(save_path);
                end
                imwrite(Tmask_trpca_gamma, strcat(save_path, '\b', imageNames{i}));
                pause(0.05)
            end
        end
        
        
        %% compute quantitative measures
        extension = '.jpg';
        range = [idxFrom, idxTo];
        alg_name = [];
        if flag_trpca_gamma
            alg_name = [alg_name, {'t_gamma'}];
        end

        videoPath = strcat(data_path, '\', category, '\', file_name);
        binaryFolder = strcat(output_path, category, '\', file_name, '\');
        fprintf('===================================================\n')
        fprintf('Category: %s\tDateset: %s\n', category, file_name)
        fprintf('Alg_name\tRecall\tPrecision\tFMeasure\n')
        for i = 1:length(alg_name)
            [confusionMatrix, stats] = compute_measures(videoPath, strcat(binaryFolder, alg_name{i}), range, extension);
            fprintf('%s\t%.4f\t%.4f\t%.4f\n', alg_name{i}, stats(1), stats(6), stats(7))
        end
        
    end
end



