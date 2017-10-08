package com.github.dice_project.qt.logs;
//author: yifan

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

public class ExtractDataFromLog {

	/**
	 * @param args
	 */
	private static FileReader fileReader;
	private static BufferedReader br;
	private static BufferedWriter bw;
	private static FileWriter fw;
	private static BufferedWriter bw1;
	private static FileWriter fw2;
	private static BufferedWriter bw2;
	private static FileWriter fw1;
	private static Map dataMap;
	private static Map dataSizeMap;
	
	public static Map<String, String> ExtractData(File file1, File file2, File extractDatafile, String spoutName, String[] logPathList) {
		// TODO Auto-generated method stub
		 try {
		        if (!file1.exists()) {
		         file1.createNewFile();
		        }
		        fw1 = new FileWriter(file1.getAbsoluteFile());
		        bw1 = new BufferedWriter(fw1); 
		        
		        if (!file2.exists()) {
		         file2.createNewFile();
		        }
		        fw2 = new FileWriter(file2.getAbsoluteFile());
		        bw2 = new BufferedWriter(fw2); 
		        
		        dataMap = new TreeMap<Date, String>();
		        dataSizeMap =new TreeMap<Date, Long>();
		        int i=0; 
		        while(i<logPathList.length)
		        {
		        	    fileReader = new FileReader(logPathList[i]);
		        	    i++;
				        br = new BufferedReader(fileReader);
				        String str;
		                int index=0;
		                
		                DateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				        while ((str = br.readLine()) != null) {	
				        	index=str.lastIndexOf("Emitting: spout default [");
				        	if(index!=-1)
				        	{
				        		String timeStampString=str.substring(0, 19);
				        		
				        		Date dt1 = df.parse(timeStampString);
				        		String timeStampStringForFile=timeStampString.replace(":", "-");
				 		        int length=str.length();
				 		        String aimString=str.substring(index+25, length-1);
				 		       if(dataMap.containsKey(dt1))
		                       {
				 		    	   String fileNameString=dataMap.get(dt1).toString();
								   FileWriter fw = new FileWriter(fileNameString,true);
				 			       bw = new BufferedWriter(fw); 
				 			       bw.append(aimString+"\r\n");
				 			      bw.close();
				 			       
				 			       long newSize= Long.valueOf(dataSizeMap.get(dt1).toString());
				 		    	   newSize+=aimString.length();
				 		    	   dataSizeMap.put(dt1, newSize);  
		                       }
				 		       else {				 			       
				 			       if (!extractDatafile.exists()) {
				 			    	  extractDatafile.createNewFile();
				 			       }
				 			       FileWriter fw = new FileWriter(extractDatafile.getAbsoluteFile());
				 			       bw = new BufferedWriter(fw);  
		                       	   dataMap.put(dt1, "/home/vagrant/"+timeStampStringForFile+".txt");
		                       	   
		                       	   bw.append(aimString+"\r\n");
		                       	bw.close();
		                       	   
		                       	   long size=aimString.length();
		                       	   dataSizeMap.put(dt1,size );
							   }
				 		       
				        	}
				        }
				       
		        }
		        dataMap=sortMapByKey(dataMap);
		        dataSizeMap=sortMapByKey1(dataSizeMap);
		        
		        Iterator<Map.Entry<Date, Long>> entries = dataSizeMap.entrySet().iterator();  
		        while (entries.hasNext()) {       
		            Map.Entry<Date, Long> entry = entries.next();  
		            bw1.append(entry.getKey() + "       " + entry.getValue()+"\r\n");   
		        } 
                
		        Iterator<Map.Entry<Date, String>> entries1 = dataMap.entrySet().iterator();  
		        while (entries1.hasNext()) {  	          
		            Map.Entry<Date, String> entry = entries1.next();    
		            bw2.append( entry.getKey() + "        " + entry.getValue()+"\r\n");       
		        } 
		        bw1.close();
		        bw2.close();
		        
		    }
		 catch (Exception e) {
			// TODO: handle exception
			 e.printStackTrace();
		}
		return dataMap;
	}
	
	 public static Map<Date, String> sortMapByKey(Map<Date, String> map) {  
         if (map == null || map.isEmpty()) {  
             return null;  
         }  
         Map<Date, String> sortMap = new TreeMap<Date, String>(new Comparator<Date>(){

			public int compare(Date o1, Date o2) {
				// TODO Auto-generated method stub
				return o1.compareTo(o2);
			} 
         });  
         sortMap.putAll(map);  
         return sortMap;  
     }  
	 public static Map<Date, Long> sortMapByKey1(Map<Date, Long> map) {  
         if (map == null || map.isEmpty()) {  
             return null;  
         }  
         Map<Date, Long> sortMap = new TreeMap<Date, Long>(new Comparator<Date>(){

			public int compare(Date o1, Date o2) {
				// TODO Auto-generated method stub
				return o1.compareTo(o2);
			} 
         });  
         sortMap.putAll(map);  
         return sortMap;  
     }  
}
