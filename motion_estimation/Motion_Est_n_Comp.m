function [full0to1 dists] = Motion_Est_n_Comp(lo1, lo0, full0, wnd_x, wnd_y, blk_me_x, blk_me_y)

    [mv_x, mv_y, dists] = Motion_Est(round(lo1), round(lo0), [blk_me_x blk_me_y wnd_x wnd_y]);
    full0to1 = Motion_Compensation(full0, mv_x, mv_y, blk_me_x, blk_me_y);
