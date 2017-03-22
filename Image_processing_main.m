classdef  Image_processing_main
    
   properties
          Img,positive_processing,Img_hsi,H,S,I,rgb,negative_processing,cmy
          positive_processing_outcome,negative_processing_outcome
   end
   
   methods
       
      function [hsi,H,S,I] = rgb2hsi(obj)
          if ~isempty (obj.cmy)
               input = im2double(obj.cmy);
          else
               input = im2double(obj.Img);
          end
          r = input(:,:,1);
          g = input(:,:,2);
          b = input(:,:,3);
          eps = 0.000001;
          num = 0.5*((r-g)+(r-b));
          den = sqrt((r-g).^2+(r-b).*(g-b));
          theta = acos(num./(den+eps));
          H = theta;
          H(b>g) = 2*pi-H(b>g);
          H = H/(2*pi);
          num = min(min(r,g),b);
          den = r+g+b;
          den(den == 0) = eps;
          S = 1-3.*num./den;
          H(S==0)=0;
          I = (r+g+b)/3;
          hsi = cat(3,H,S,I);
      end
      
      function rgb = hsi2rgb(obj )
          if isempty (obj.negative_processing)
              hsi=obj.positive_processing;
          else
              hsi=obj.negative_processing;
          end
          HV = hsi(:,:,1)*2*pi;
          SV = hsi(:,:,2);
          IV = hsi(:,:,3);
          R = zeros(size(HV));
          G = zeros(size(HV));
          B = zeros(size(HV));
          id = find((0<=HV)&(HV<2*pi/3));
          B(id) = IV(id).*(1-SV(id));
          R(id) = IV(id).*(1+SV(id).*cos(HV(id))./cos(pi/3-HV(id)));
          G(id) = 3*IV(id)-(R(id)+B(id));
          id = find((2*pi/3<=HV)&(HV<4*pi/3));
          R(id) = IV(id).*(1-SV(id));
          G(id) = IV(id).*(1+SV(id).*cos(HV(id)-2*pi/3)./cos(pi-HV(id)));
          B(id) = 3*IV(id)-(R(id)+G(id));
          id = find((4*pi/3<=HV)&(HV<2*pi));
          G(id) = IV(id).*(1-SV(id));
          B(id) = IV(id).*(1+SV(id).*cos(HV(id)-4*pi/3)./cos(5*pi/3-HV(id)));
          R(id) = 3*IV(id)-(G(id)+B(id));
          C = cat(3,R,G,B);
          if isempty (obj.negative_processing)
               rgb = max(min(C,1),0);
               rgb= uint8(rgb*255);
          else
              rgb = max(min(C,1),0);
          end
      end
      
      function cmy=rgb2cmy(obj)
          img = im2double(obj.Img);
          R=img(:,:,1);
          g=img(:,:,2);
          b=img(:,:,3);
          c=1-R;m=1-g;y=1-b;
          cmy=cat(3,c,m,y);
      end
      
      function rgb=cmy2rgb(obj)
          c=obj.rgb(:,:,1);
          m=obj.rgb(:,:,2);
          y=obj.rgb(:,:,3);
          r=1-c;g=1-m;b=1-y;
          C=cat(3,r,g,b);
          rgb = uint8(C*255);
      end
      
   end
   
end