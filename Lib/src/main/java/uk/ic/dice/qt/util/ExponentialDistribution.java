package uk.ic.dice.qt.util;
//author: yifan

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Random;


public class ExponentialDistribution {
	
	 
	public static int totalNum=0;
	public static ArrayList<Integer> preExponentialList;
	public static ArrayList<Integer> exponentialList;
	public static Random random;
	
	public static ArrayList<Integer> randomExponentialDistribution(int scale, int range)
	{
		
		random = new Random();
		exponentialList=new ArrayList<Integer>();
		preExponentialList=new ArrayList<Integer>();
		try {
		     for(int i=0; i<range;i++)
		     {
			      int num=(int)(-scale * Math.log(random.nextDouble()));
			      if(!(preExponentialList.contains(num)))
			      {
			    	  preExponentialList.add(num);
			      }
			      
		     }
		    
	         Collections.sort(preExponentialList);
	         
		     for(int i=0; i<preExponentialList.size();i++)
		     {
		    	 totalNum+=preExponentialList.get(i);
			     if(totalNum>=1000) break;
			     exponentialList.add(totalNum);
			  
		     }
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
	   Collections.sort(exponentialList, new Comparator<Integer>() {
       
		@Override
		public int compare(Integer o1, Integer o2) {
			// TODO Auto-generated method stub
			return o1.compareTo(o2);
		}
    });
	   
	   return exponentialList;
  }
}
