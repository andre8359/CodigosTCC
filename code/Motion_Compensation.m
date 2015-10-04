function comp1 = Motion_Compensation(ref, mv_x, mv_y, blk_x, blk_y)

[H W] = size(ref);
comp1 = ref*0;

for j = 1:blk_y:H
	jj=j:j+blk_y-1;
	for k = 1:blk_x:W
		kk = k:k+blk_x-1;
		comp1(jj,kk) = ref(mv_y(j,k)+1:mv_y(j,k)+blk_y,
							mv_x(j,k)+1:mv_x(j,k)+blk_x);
	end
end
