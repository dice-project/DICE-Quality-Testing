package com.github.diceproject.qt.loadgen.impl;
//author: yifan

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;


public class GenerateLoadFromTxtByVolume {
	
	public static FileWriter fw;
	public static BufferedWriter bw;
	public static BufferedReader br;
	public static FileReader fileReader;
	public static Map<Integer, String> getfileMap;
	public static GenerateLoad generateLoad;
	public static Map<String, String> conf;
	
	public static Map<Integer, String> getLoadMap(String txtFilePath, String fileNamePath)
	{
		try {
			 conf =new HashMap<String, String>();
			 generateLoad =new GenerateLoad();
			 getfileMap =new TreeMap<Integer, String>();
		     fileReader = new FileReader(txtFilePath);
		     br = new BufferedReader(fileReader);
		     String str;
		     while((str = br.readLine())!=null)
		     {
		    	 String[] strings=str.split("@");
		    	 int key= Integer.parseInt(strings[0]);
		    	 int dataSize=Integer.parseInt(strings[1]);
		    	
		    	 conf.put("dataSize", String.valueOf(dataSize));
				 conf.put("pathString", fileNamePath);
				 generateLoad.generateLoadForWords(conf);
		    	 getfileMap.put(key, fileNamePath);
		     }
		     
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return getfileMap;		
	}
}
