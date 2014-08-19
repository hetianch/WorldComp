function [ behavior_with_gender ] = impute_gender( behavior,female_str,male_str,interval )
%This function is used to get gender from blobcolor.
%we assign gender according to the most color between 'merge' (at lest
%#interval
%frame)

% 1 female,0 male, -1 unknown;

behavior_with_gender=behavior;
flynumber= size(behavior,2);
for i = 1: flynumber
    %find most frequent color between 'merge'. Only do this for interval >
    %#interval frames
    multiIdx=find(behavior(i).multifly);
    for j = 1: length(multiIdx)-1
        %initialize values
        color_impute=behavior(i).color;
        female= -1*ones(size(behavior(i).color,1),1);
        
        if multiIdx(j+1)-multiIdx(j)<interval
            continue;
        else %calculate color mode

            single_frame_color=color_impute(multiIdx(j)+1:multiIdx(j+1)-1);
            [unique_strings, ~, string_map]=unique(single_frame_color);
            most_common_color=unique_strings(mode(string_map)); 
            nframes=multiIdx(j+1)-1-multiIdx(j);
            color_impute(multiIdx(j)+1:multiIdx(j+1)-1)=repmat(most_common_color,1,nframes);
        end   
        %Then we need to handle that the multiIdx doesn't start from 1 or doesn't end at the end frame:
        if multiIdx(1)> interval
        %Ex: multiFly=(0,0,1,1,0,0)
        %    multiIdx=(3,4)
            single_frame_color=color_impute(1:multiIdx(1)-1);
            [unique_strings, ~, string_map]=unique(single_frame_color);
            most_common_color=unique_strings(mode(string_map)); 
            nframes=multiIdx(1)-1;
            color_impute(1:multiIdx(1)-1)=repmat(most_common_color,1,nframes);
        end

        if size(behavior(i).frames,2)-multiIdx(end)>interval
            single_frame_color=color_impute(multiIdx(end)+1:size(behavior(i).frames,2));
            [unique_strings, ~, string_map]=unique(single_frame_color);
            most_common_color=unique_strings(mode(string_map)); 
            nframes=size(behavior(i).frames,2)-multiIdx(end);
            color_impute(multiIdx(end)+1:size(behavior(i).frames,2))=repmat(most_common_color,1,nframes);
        end

    end
    %give 1 to female 0 to male
    female_idx=find(ismember(color_impute,female_str));
    male_idx=find(ismember(color_impute,male_str));
    female(female_idx)=1;
    female(male_idx)=0;
    behavior_with_gender(i).female=female;
end

