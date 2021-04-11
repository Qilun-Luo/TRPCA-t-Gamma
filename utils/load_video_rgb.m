function [X, height, width] = load_video_rgb(data_path, file_name, ext_name, show_flag)

    imageNames = dir(fullfile(data_path, file_name, strcat('*.',ext_name)));
    imageNames = {imageNames.name}';
    [height, width, dims] = size(imread(fullfile(data_path, file_name, imageNames{1})));
    nframes = length(imageNames);
    X = zeros(height*width, dims, nframes);
    figure
    for i = 1:length(imageNames)
       img = imread(fullfile(data_path,file_name,imageNames{i}));
       if(show_flag)
           imshow(img)
       end
       X(:, :, i) = reshape(img, [height*width, dims]);
    end
    
end