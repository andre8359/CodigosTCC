function [ImComp] = compensation(ImRef,vector,bSize,wSize)

    ImComp = double(zeros(size(ImRef)));

    nBlocks = length(vector);

    for k=1:nBlocks
        ImComp(vector(k,1):vector(k,1)+bSize,vector(k,2):vector(k,2)+bSize) = ImRef(vector(k,1):vector(k,1)+bSize,vector(k,2):vector(k,2)+bSize);
    endfor

endfunction

