function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
	[db2, img2] = compute2DProperties(orig_img, labeled_img);

	n1 = size(obj_db, 2); %get number of cols
	n2 = size(db2, 2); %get number of cols

	matches = [];
	fig = figure();
	imshow(orig_img);
	line_length = 50;
	hold on;

	for i=1:n1
		for j=1:n2
			% check for roundness
			roundness1 = obj_db(6, i);
			roundness2 = db2(6, j);

			if(abs(roundness1 - roundness2) < 0.03)
				plot(db2(3,j), db2(2,j), 'ws', 'MarkerFaceColor', [1 0 0]);
     			theta_j = db2(5,j);
		        x_1 = db2(2,j);
		        y_1 = db2(3,j);
		        x_2 = x_1 + cos(theta_j) * line_length;
		        y_2 = y_1 + sin(theta_j) * line_length;
		        plot([y_1 y_2], [x_1 x_2]);
			end
		end
	end
 	output_img = saveAnnotatedImg(fig);
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