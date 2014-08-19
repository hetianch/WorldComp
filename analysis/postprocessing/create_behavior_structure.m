function [ behavior ] = create_behavior_structure(multifly_scores,chase_scores,trx,closetfly_anglerange)
%This function is used to create behavior structure from python prediction
%scores. This function read in python prediction scores and write to
%behavior structure.
%behavior.frames=frames
%behavior.flyID= flyID
%behavior.multifly= 1 if multi
%behavior.color=Y if female
%behavior.chase=1 if chase
behavior=[];
flynumber= size(trx,2);
frame_count=0;
for i = 1: flynumber
    behavior(i).frames=(trx(i).firstframe:1:trx(i).endframe)';
    behavior(i).fly=trx(i).id;
    behavior(i).multifly=multifly_scores(frame_count+1 : frame_count+trx(i).nframes);
    behavior(i).chase=chase_scores(frame_count+1 : frame_count+trx(i).nframes);
    frame_count=frame_count+trx(i).nframes;
    behavior(i).color=trx(i).color;
    behavior(i).closetfly_min30to30=closetfly_anglerange{i}';
end

