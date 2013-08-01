function Rxyz = rotationMatrixFromRxRyRz(v)
[Rx ,Ry, Rz] = RxRyRz(v);
Rxyz=Rx*Ry*Rz;
end