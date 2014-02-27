function [obj_db, out_img] = compute2DProperties(orig_img, labeled_img)
    n = max(labeled_img(:));
    obj_db = zeros(6, n); 
    
    %for each object
    for i=1:n
        %get pixel indices for object
        [x,y] = find(labeled_img == i);
        %compute area (discrete, number of pixels)
        A = length([x y]);
        
        %row 1 object label
        obj_db(1, i) = i;
        
        %row 2 row position of center
        x_bar = sum(x) / A;
        obj_db(2, i) = x_bar;
        
        %row 3 column position of center
        y_bar = sum(y) / A;
        obj_db(3, i) = y_bar;
       
        %row 5 the orientation 
        a = sum((x - x_bar).^2);
        b = 2 * sum((x - x_bar) .* (y - y_bar));
        c = sum((y - y_bar).^2);
        
        theta = atan2(b, a - c) / 2;
        
        obj_db(5, i) = theta;
        
        %row 4 the minimum moment of inertia
        E_min = a*sin(theta)^2 - b*sin(theta)*cos(theta) + c*cos(theta)^2;
        obj_db(4, i) = E_min;
        
        %row 6 the roundness
        theta2 = theta + pi / 2;
        E_max = a*sin(theta2)^2 - b*sin(theta2)*cos(theta2) + c*cos(theta2)^2;
        obj_db(6, i) = E_min / E_max;

        %additional row 7 for boundingbox area
        x1 = min(x);
        x2 = max(x);
        y1 = min(y);
        y2 = max(y);

        box_area = (x2 - x1) * (y2 - y1);
        obj_db(7, i) = box_area;

        %additional row 8 for extent
        extent = box_area / A;
        obj_db(8, i) = extent;
        
    end

    %annotate image
    fig = figure();
    imshow(orig_img);
    hold on; plot(obj_db(3,:), obj_db(2,:),  'ws', 'MarkerFaceColor', [1 0 0]);

    line_length = 50;
    for j=1:n
        theta_j = obj_db(5,j);
        x_1 = obj_db(2,j);
        y_1 = obj_db(3,j);
        x_2 = x_1 + cos(theta_j) * line_length;
        y_2 = y_1 + sin(theta_j) * line_length;
        %hold on;
        plot([y_1 y_2], [x_1 x_2]);
    end

    out_img = saveAnnotatedImg(fig);  
    delete(fig);

end

function annotated_img = saveAnnotatedImg(fh)
    figure(fh); % Shift the focus back to the figure fh

    % The figure needs to be undocked
    set(fh, 'WindowStyle', 'normal');

    % The following two lines just to make the figure true size to the
    % displayed image. The reason will become clear later.
    img = getimage(fh);
    truesize(fh, [size(img, 1), size(img, 2)]);

    % getframe does a screen capture of the figure window, as a result, the
    % displayed figure has to be in true size. 
    frame = getframe(fh);
    frame = getframe(fh);
    pause(0.5); 
    % Because getframe tries to perform a screen capture. it somehow 
    % has some platform depend issues. we should calling
    % getframe twice in a row and adding a pause afterwards make getframe work
    % as expected. This is just a walkaround. 
    annotated_img = frame.cdata; 
end