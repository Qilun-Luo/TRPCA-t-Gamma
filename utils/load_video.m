function X = load_video(data_path, file_name, ext_name, show_flag)

    imageNames = dir(fullfile(data_path, file_name, strcat('*.',ext_name)));
    imageNames = {imageNames.name}';
    [height, width, ~] = size(imread(fullfile(data_path, file_name, imageNames{1})));
    nframes = length(imageNames);
    X = zeros(height, width, nframes);
    figure
    for i = 1:length(imageNames)
       img = rgb2gray(uint8(imread(fullfile(data_path,file_name,imageNames{i}))));
       if(show_flag)
           imshow(img)
       end
       X(:, :, i) = img;
    end
    
end