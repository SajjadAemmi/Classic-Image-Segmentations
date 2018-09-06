function out = SnakeImp(A,X,lambda,I,Fext_x,Fext_y)

iFext_x = interp2(Fext_x, X(:,1), X(:,2), 'bilinear');
iFext_x(isnan(iFext_x))=0;
iFext_y = interp2(Fext_y, X(:,1), X(:,2), 'bilinear');
iFext_y(isnan(iFext_y))=0;

iFext = [iFext_x , iFext_y];
out = (inv(I - lambda * A)) * (X + (lambda * iFext));

end