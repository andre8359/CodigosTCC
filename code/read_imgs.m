function a = read_imgs(img_num,grayScale)
if(nargin>2)
	grayScale =1;
end

switch img_num
	case 1
		img_name = 'lena.png';
	case 2
		img_name = 'Barbara.png';
	case 3
		img_name = 'mandrill.png';
	case 4
		img_name = 'peppers.png';
	case 5
		img_name = 'Bike1.png';
	case 6
		img_name = 'Bike2.png';
	case 7
		img_name = 'goldhill.png';
	case 8
		img_name = 'Mobcal.png';
	case 9
		img_name = 'Parkrun.png';
	case 10
		img_name = 'Shields.png';
	case 11
		img_name = 'Stockholm.png';
end


a = double(imread(['./imgs/' img_name]));
if size(a,3)==3 && grayScale 
	a = round(mean(a,3));
end