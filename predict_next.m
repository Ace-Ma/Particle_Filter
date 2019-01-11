function [predict_x, predict_y] = predict_next(Frame_information, prev_frames, loop)

x1 = round(Frame_information(loop).x);   
y1 = round(Frame_information(loop).y);

predict_x = 0;
predict_y = 0;

if (loop < prev_frames + 1)
    for i = 1 : (loop - 1)
        x2 = round(Frame_information(loop - i).x);
        mx = x1 - x2;
        predict_x = predict_x + mx / i;

        y2 = round(Frame_information(loop - i).y);
        my = y1 - y2;
        predict_y = predict_y + my / i;
    end
    predict_x = predict_x / (loop - 1);
    predict_y = predict_y / (loop - 1);
    
else
    for i = 1 : prev_frames
        x2 = round(Frame_information(loop - i).x);
        mx = x1 - x2;
        predict_x = predict_x + mx / i;

        y2 = round(Frame_information(loop - i).y);
        my = y1 - y2;
        predict_y = predict_y + my / i;
    end
    predict_x = predict_x / prev_frames;
    predict_y = predict_y / prev_frames;
end

    
    