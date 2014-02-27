function obj_db = compute2DProperties(labeled_img)
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
        %a_prime = x.^2;
        %b_prime = 2 * x * y;
        %c_prime = y^2;
        
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
        
    end
    
end