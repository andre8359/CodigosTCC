function B = DCT_Blk_Resize(A, blk_in, blk_out)
% Função: a_new = DCT_Blk_Resize(A, blk_in, blk_out)
%
%     Muda o tamanho da imagem A, de duas dimensões.
%     Esta é dividida em blocos de tamanho blk_in x blk_in,
%     que são alterados para blocos de tamanho blk_out x blk_out.
%     A mudança de tamanho do bloco é feita com base na DCT.
%
%     Por exemplo, se A tem tamanho 576 x 720, a chamada
%          B = DCT_Blk_Resize(A, 8, 3)
%     cria uma imagem B de tamanho 216 x 270 (576/8*3 x 720/8*3).
%
%     Já a chamada (com a mesma imagem A)
%          B = DCT_Blk_Resize(A, 8, 12)
%     cria uma imagem B de tamanho 864 x 1080 (576/8*12 x 720/8*12).

resize_mtx = (dctmtx(blk_out)')*eye(blk_out,blk_in)*dctmtx(blk_in)*sqrt(blk_out/blk_in);

% Metodo mais devagar
% B = kron(eye(size(A,1)/blk_in), resize_mtx)*A*kron(eye(size(A,2)/blk_in), resize_mtx');

% Metodo mais rapido
B = mtimes(mtimes(sparse(kron(eye(size(A,1)/blk_in), resize_mtx)),A),sparse(kron(eye(size(A,2)/blk_in), resize_mtx')));