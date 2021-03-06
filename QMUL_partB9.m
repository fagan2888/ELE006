function [ details centre averageColour] = QMUL_partB9( vid )
    %
    %QMUL_part9    Feature Extraction
    %Extracts the features of video and writes to excel file 
    %
    % [details centre averageColour] = QMUL_partB9(vidFrames, frame)
    %
    % INPUT
    % vidFrames - Frames of the video
    %
    % OUTPUT
    % details - An m by 2 matrix of Height and Width of m objects
    % centre - An m by 2 matrix of the centres of m objects
    % averageColour - An m by 3 matrix of the average of each colour
    %                 channel of m objects
    %
    % SOURCES NEEDED
    % QMUL_partA5.m , QMUL_thresholding.m and QMUL_FloodFill.m
  
  tic;
  %%
  %Write the Excel file headers

  writeThis = {'frame', 'object', 'height', 'width', 'centreX', 'centreY', 'averageR','averageG','averageB'};
  xlswrite('question9.xlsx', writeThis,1,'A1');
  writeCounter = 2;
  writeThis = {};
  writeThis = writeThis';

  [row col ch frames] = size(vid);

  %%
  %Get The background frame

  backgroundFrame = QMUL_partA5(vid, 100, 'average');

  %if we want details of whole video
  for frame=1:frames
      %frame
      writeThis(1,1) = {frame};
      %%
      %Get The BW frame

      BWFrame = QMUL_thresholding(backgroundFrame, vid(:,:,:,frame));
      boundedFrame = vid(:,:,:,frame);
      originalFrame = vid(:,:,:,frame);

      %%
      %FloodFill the frame and get bounds

      [cars bounds highes lowes] = QMUL_FloodFill(BWFrame);
      
      [num amount xy] = size(bounds);

      %%
      %Variables to temporarily keep details we will write
      highs = ones(num,2);
      lows = ones(num,2);
      details = ones(num,2);
      centre = ones(num,2);
      averageColour = ones(num,3);

      %%
      %Get the highest and lowest numbers

      for i = 1: num
          writeThis(1,2) = {i};
          highs(i,1) = bounds(i,1,1);
          highs(i,2) = bounds(i,1,2);
          lows(i,1) = bounds(i,1,1);
          lows(i,2) = bounds(i,1,2);
          for j=1:amount
              if bounds(i,j,1) == 0 || bounds(i,j,2) == 0
                  continue;
              end
              
              
              if lows(i,1) > bounds(i,j,1)
                  lows(i,1) = bounds(i,j,1);
              elseif highs(i,1) < bounds(i,j,1)
                  highs(i,1) = bounds(i,j,1);
              end
              
              if lows(i,2) > bounds(i,j,2)
                  lows(i,2) = bounds(i,j,2);
              elseif highs(i,2) < bounds(i,j,2)
                  highs(i,2) = bounds(i,j,2);
              end

              for k=1:3
                boundedFrame(bounds(i,j,1), bounds(i,j,2), k) = 0;
              end
          end
          
          %%
          %Find height, width and centre then write to excel buffer
          height = highs(i,1) - lows(i,1);
          width = highs(i,2) - lows(i,2);
          details(i,:) = [height width];
          writeThis(1,3) = {height};
          writeThis(1,4) = {width};
          centre(i,:) = [ceil(height/2) ceil(width/2)];
          writeThis(1,5) = {centre(i,1)};
          writeThis(1,6) = {centre(i,2)};

          %%
          %Find average of each colour channel within bounding box
          %then write to excel buffer
          xCoords = lows(i,1):highs(i,1);
          yCoords = lows(i,2):highs(i,2);
          for c=1:3
            averageColour(i,c) = mean2(originalFrame(xCoords,yCoords,c));
          end
          writeThis(1,7) = {averageColour(i,1)};
          writeThis(1,8) = {averageColour(i,2)};
          writeThis(1,9) = {averageColour(i,3)};

          %%
          %Do not forget to write in newline so as not to overwrite previous
          next = sprintf('A%d', writeCounter);
          writeCounter = writeCounter + 1;
          xlswrite('question9.xlsx', writeThis,1,next);
      end

      

  end
  toc
end


