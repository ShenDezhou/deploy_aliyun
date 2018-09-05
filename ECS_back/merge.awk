BEGIN {str="";n=0}
ARGIND==1 {
      if (NF<7) {
          if(n+NF>7){
            print str $0
            n=0
            str=""  
          }
          else{
            gsub(/\r/,"",$0)
            str=str $0
            n=n+NF
          }
          
      }
      else {
          gsub(/\r/,"",$0)
          print $0
      }
} 
