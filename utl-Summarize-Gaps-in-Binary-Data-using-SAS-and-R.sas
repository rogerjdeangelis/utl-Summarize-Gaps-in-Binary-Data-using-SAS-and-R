Why sas is more maintainable than R                                                                                 
                                                                                                                    
Summarize Gaps in Binary Data using R                                                                               
                                                                                                                    
   Problem:                                                                                                         
      If                                                                                                            
         A B C D E F G                                                                                              
         0 1 1 1 0 1 0                                                                                              
                                                                                                                    
      Then sumarize as                                                                                              
                                                                                                                    
        Count                                                                                                       
         Ones    Range                                                                                              
                                                                                                                    
          3      B-D                                                                                                
          1      F-F                                                                                                
                                                                                                                    
     Two Processes                                                                                                  
                                                                                                                    
          a. SAS                                                                                                    
          b. R  (see posted solution on end)                                                                        
                                                                                                                    
                                                                                                                    
github                                                                                                              
https://tinyurl.com/yyn5qqc8                                                                                        
https://github.com/rogerjdeangelis/utl-Summarize-Gaps-in-Binary-Data-using-SAS-and-R                                
                                                                                                                    
stackoverflow r                                                                                                     
https://tinyurl.com/y3xjlxus                                                                                        
https://stackoverflow.com/questions/58174314/summarize-gaps-in-binary-data-using-r#comment102733162_58174642        
                                                                                                                    
                                                                                                                    
                                                                                                                    
* There maybe a somewhat cleaner R solution using run length encoding;                                              
* but I had trouble with the many lists the rle generates;                                                          
* It would be greate if RLE could output a dataframe;                                                               
                                                                                                                    
*_                   _                                                                                              
(_)_ __  _ __  _   _| |_                                                                                            
| | '_ \| '_ \| | | | __|                                                                                           
| | | | | |_) | |_| | |_                                                                                            
|_|_| |_| .__/ \__,_|\__|                                                                                           
        |_|                                                                                                         
;                                                                                                                   
                                                                                                                    
                                                                                                                    
options validvarname=upcase;                                                                                        
libname sd1 "d:/sd1";                                                                                               
data sd1.have;                                                                                                      
 input                                                                                                              
A B C D E F G H I J K L M N;                                                                                        
cards4;                                                                                                             
0 0 0 0 1 1 1 0 1 1 0 0 1 0                                                                                         
1 1 1 1 1 1 1 1 1 0 0 0 0 0                                                                                         
0 0 0 0 0 0 0 1 1 1 1 1 0 0                                                                                         
0 0 0 0 0 0 0 0 0 0 0 0 0 1                                                                                         
0 0 0 0 0 0 0 0 0 0 0 0 0 0                                                                                         
;;;;                                                                                                                
run;quit;                                                                                                           
                                                                                                                    
                                                  Count                                                             
SD1.HAVE total obs=5               | Rules  Rows  Ones                                                              
                                   |                                                                                
 Obs A B C D E F G H I J K L M N   |                                                                                
                                   |                                                                                
  1          1 1 1   1 1     1     | E-G     1     3                                                                
                                     I-J     1     2                                                                
                                     M-M     1     1                                                                
                                                                                                                    
  2  1 1 1 1 1 1 1 1 1             | A-I     2     9                                                                
  3                1 1 1 1 1       | H-L     3     5                                                                
  4                            1   | N-N     4     1                                                                
                                                                                                                    
*            _               _                                                                                      
  ___  _   _| |_ _ __  _   _| |_                                                                                    
 / _ \| | | | __| '_ \| | | | __|                                                                                   
| (_) | |_| | |_| |_) | |_| | |_                                                                                    
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                   
                |_|                                                                                                 
;                                                                                                                   
                                                                                                                    
                                                                                                                    
Up to 40 obs from WANT total obs=6                                                                                  
                                                                                                                    
Obs    GRPONE    ROW    ONES                                                                                        
                                                                                                                    
 1      E-G       1       3                                                                                         
 2      I-J       1       2                                                                                         
 3      M-M       1       1                                                                                         
 4      A-I       2       9                                                                                         
 5      H-L       3       5                                                                                         
 6      N-N       4       1                                                                                         
                                                                                                                    
*                                                                                                                   
 _ __  _ __ ___   ___ ___  ___ ___                                                                                  
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                                 
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                 
| .__/|_|  \___/ \___\___||___/___/                                                                                 
|_|                                                                                                                 
;                                                                                                                   
                                                                                                                    
data want (where=(grpOne ne ""));                                                                                   
                                                                                                                    
  length grpOne $100;                                                                                               
  retain grpOne;                                                                                                    
                                                                                                                    
  set have;                                                                                                         
                                                                                                                    
  * add a 0 to the end of the array to force ouput;                                                                 
  O=0;                                                                                                              
                                                                                                                    
  array nums _numeric_;                                                                                             
                                                                                                                    
  row=_n_;                                                                                                          
                                                                                                                    
  do over nums;                                                                                                     
                                                                                                                    
    select (nums);                                                                                                  
                                                                                                                    
      when (1) grpOne=cats(grpOne,vname(nums));                                                                     
      when (0) do;                                                                                                  
           ones=length(grpOne);                                                                                     
           grpOne=catx('-',substr(grpOne,1,1),substr(grpOne,length(grpOne)));                                       
           output;                                                                                                  
           grpOne="";                                                                                               
      end;                                                                                                          
                                                                                                                    
      otherwise;                                                                                                    
    end;                                                                                                            
  end;                                                                                                              
                                                                                                                    
  grpOne="";                                                                                                        
  keep row ones grpOne;                                                                                             
                                                                                                                    
run;quit;                                                                                                           
                                                                                                                    
*                       _           _                                                                               
 _ __   _ __   ___  ___| |_ ___  __| |                                                                              
| '__| | '_ \ / _ \/ __| __/ _ \/ _` |                                                                              
| |    | |_) | (_) \__ \ ||  __/ (_| |                                                                              
|_|    | .__/ \___/|___/\__\___|\__,_|                                                                              
       |_|                                                                                                          
;                                                                                                                   
                                                                                                                    
                                                                                                                    
library(tidyverse)                                                                                                  
df %>%                                                                                                              
  rowid_to_column() %>%                                                                                             
  gather(col, val, -rowid) %>%                                                                                      
  group_by(rowid) %>%                                                                                               
  # This counts the number of times a new streak starts                                                             
  mutate(grp_num = cumsum(val != lag(val, default = -99))) %>%                                                      
  filter(val == 1) %>%                                                                                              
  group_by(rowid, grp_num) %>%                                                                                      
  summarise(num_1s = n(),                                                                                           
            range = paste0(first(col), "-", last(col)))                                                             
                                                                                                                    
library(data.table)                                                                                                 
melt(setDT(df1, keep.rownames = TRUE), id.var = 'rn')[,                                                             
   grp := rleid(value), rn][value == 1, .(NumberOfOnes = .N,                                                        
    Range = paste(range(as.character(variable)), collapse="-")),                                                    
      .(grp, rn)][,  grp := NULL][order(rn)]                                                                        
                                                                                                                    
                                                                                                                    
do.call(rbind, apply(df1, 1, function(x) {                                                                          
       rl <- rle(x)                                                                                                 
       i1 <- rl$values == 1                                                                                         
       l1 <- rl$lengths[i1]                                                                                         
       nm1 <- tapply(names(x), rep(seq_along(rl$values), rl$lengths),                                               
          FUN = function(y) paste(range(y), collapse="-"))[i1]                                                      
       data.frame(NumberOfOnes = l1, Range = nm1)}))                                                                
                                                                                                                    
                                                                                                                    
                                                                                                                    
