package com.github.diceproject.qt.loadgen.impl;
//author: yifan

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import com.github.diceproject.qt.util.UniformDistribution;


public class GenerateLoadFromCSVByRate {

	public static FileWriter fw;
	public static BufferedWriter bw;
	public static BufferedReader br;
	public static ArrayList<String> timeAndRateList;
	public static GenerateLoad generateLoad;
	public static Map<String, String> conf;
	public static UniformDistribution uniformDistribution;
	
	
	
	public static int num=1;

	
	public  static ArrayList<String> getRateList(String csvFilePath, String fileNamePath, boolean uniformSlots, boolean exponentialSlots, int parallelism, ArrayList<Integer> exponentialList, int uniformCut) throws Exception {
		timeAndRateList =new ArrayList<String>();
		generateLoad =new GenerateLoad();
		uniformDistribution =new UniformDistribution();
		

		conf = new HashMap<String, String>();
		try {
			
			   br = new BufferedReader(new FileReader(csvFilePath));
		       String str="";
		       int i=0;
		       int time=0;
		       int dataSize=0;
			   while ((str = br.readLine()) != null) {
					String[] row = str.split(",");
					if(i==0)
					{
						i=1;
					}
					else
					{
						time=Integer.parseInt(Pattern.compile("[^0-9]").matcher(row[0]).replaceAll(""));
					    dataSize=Integer.parseInt(Pattern.compile("[^0-9]").matcher(row[1]).replaceAll(""));
						if(uniformSlots)
						{
							num=uniformDistribution.divisionPerSecond(dataSize, uniformCut);
						
							
						    dataSize=dataSize/num;
						    
				
						     conf.put("dataSize", String.valueOf(dataSize));
						     conf.put("pathString", fileNamePath);
							 generateLoad.generateLoadForWords(conf);
							 timeAndRateList.add(time+";"+dataSize+";"+num);
						}
						else if (exponentialSlots) {
							
                             num=exponentialList.size();
						
							
						     dataSize=dataSize/num;
						    
		
						     conf.put("dataSize", String.valueOf(dataSize));
						     conf.put("pathString", fileNamePath);
							 generateLoad.generateLoadForWords(conf);
							 timeAndRateList.add(time+";"+dataSize+";"+num);
							
						}
						else {
							 dataSize=dataSize/parallelism;
							 
							 conf.put("dataSize", String.valueOf(dataSize));
							 conf.put("pathString", fileNamePath);
							 generateLoad.generateLoadForWords(conf);
							 timeAndRateList.add(time+";"+dataSize);
						}
						
					}
				}
		}
		catch (Exception e) {
			// TODO: handle exception
			e.getStackTrace();
		}

		return timeAndRateList;
	}
	
}
