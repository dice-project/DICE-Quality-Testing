package com.github.dice_project.qt.util;
//author: yifan

import java.util.Random;

public class RandomBinary {
	
	 public static char[] binString=new char[]{'0','1'};
	 public  static Random random;

     public static String randomBinaryString(int length){  
    	 random =new Random();
    	 
    	 String str="";
    	 while(length!=0)
    	 {
    		 str+=binString[random.nextInt(2)];
    		 length--;
    	 }
    	 
    	 return str;
     }

}
