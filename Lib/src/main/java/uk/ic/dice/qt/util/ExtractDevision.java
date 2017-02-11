package uk.ic.dice.qt.util;
//author: yifan

import java.util.ArrayList;
import java.util.List;

public class ExtractDevision {
	
public  static  Integer  exactDevision(int num){
        
        List<Integer> integers=new ArrayList<Integer>();
             for(int i=2;i<num/2;i++){
                 if(num%i==0){
                     integers.add(i);
                 }
             }
             if(integers.size()==0) return 1;
             else   return integers.get(integers.size()-1);
           
        }

}
