function HA = calculateHA(v1, v2)
% 3)C calculating the HA
ydif = sum(abs(v1(:,1)-v2(:,1)))/size(v1,1);
xdif = sum(abs(v1(:,2)-v2(:,2)))/size(v1,1);
HA = ydif+xdif;
end