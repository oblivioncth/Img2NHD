img = imread(uigetfile('*'));
save = uiputfile('*.txt');
img = double(~img);
HEX = cell(8,128);

%Makes image into array, each 128 values is a page
for n = 1:8
    UB = 8*n;
    LB = UB-7;
    for i = 1:128
        %BIN = flipud(img(LB:UB,i)).';
        BIN = img(LB:UB,i).';
        HEX{9-n,i} = ['0x' binaryVectorToHex(BIN)];
    end
end

%Formats the image array into 16x64 for a better view in CC studio
k = 0;
j = 1;
for n = 1:64
    for i=1:16
        Line2(n,i) = HEX(j,i+(k*16));
    end
    k = k + 1;
    if(k == 8)
        k = 0;
        j = j +1;
    end
end


fID = fopen( save, 'wt' );
Line1 = 'unsigned const char image[] = {\n';
fprintf(fID,Line1);


for n = 1:64
    for i = 1:16
      if(n == 64 && i == 16)
          fprintf(fID,[char(Line2(n,i)), ' ']);
      else
        fprintf(fID,[char(Line2(n,i)), ', ']);
      end
    end
    fprintf(fID,'\n');
end

fprintf(fID,'}; ');
