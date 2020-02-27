% f = radialpolyFrac(r,p,q,a)
%   r = radius
%   p = order
%   q = repetition

function rad = radialpoly(r,p,q)
rad = zeros(size(r));                     
for s = 0:(p-abs(q))/2
  c = (-1)^s*factorial(p-s)/(factorial(s)*factorial((p+abs(q))/2-s)*factorial((p-abs(q))/2-s));
  rad = rad + c*r.^(p-2*s);
end
%rad = rad * sqrt(a);

