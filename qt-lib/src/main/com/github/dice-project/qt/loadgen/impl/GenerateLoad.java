package com.github.dice-project.qt.loadgen.impl;
//author: yifan

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Map;

import com.github.dice-project.qt.loadgen.LoadGeneratorInterface;
import com.github.dice-project.qt.util.ExtractDevision;
import com.github.dice-project.qt.util.RandomBinary;
import com.github.dice-project.qt.util.RandomWordsString;


public class GenerateLoad implements LoadGeneratorInterface {
	public static ExtractDevision extractDevision;
	public static RandomWordsString randomWordsString;
	public static RandomBinary randomBinary;
	
	public static FileWriter fw;
	public static BufferedWriter bw;

	@Override
	public void generateLoadForWords(Map<String, String> conf) {
		// TODO Auto-generated method stub
		try {
			extractDevision =new ExtractDevision();
			randomWordsString =new RandomWordsString();
			
			int dataSize=Integer.parseInt(conf.get("dataSize").toString());
			String pathString=conf.get("pathString").toString();
			
			int stringSize= extractDevision.exactDevision(dataSize);		
			String str=randomWordsString.createRandomString(stringSize);
		    int num=dataSize/stringSize;	
			File file=new File(pathString);
			if (!file.exists()) {
			   file.createNewFile();
		    }
			  fw = new FileWriter(file.getAbsoluteFile());
			  bw = new BufferedWriter(fw);
			
				  for(int i=0;i<num;i++)
				  {
					  bw.append(str);
					  
				  }
			  bw.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


	@Override
	public void generateLoadForBinary(Map conf) {
		// TODO Auto-generated method stub
		try {
			randomBinary=new RandomBinary();
			
			String pathString=conf.get("pathString").toString();
			int num= Integer.parseInt(conf.get("num").toString());
			int length = Integer.parseInt(conf.get("length").toString());
			File file=new File(pathString);
			if (!file.exists()) {
			   file.createNewFile();
		    }
			  fw = new FileWriter(file.getAbsoluteFile());
			  bw = new BufferedWriter(fw);
			
				  for(int i=0;i<num;i++)
				  {
					  bw.append(randomBinary.randomBinaryString(length)+";");
				  }
			  bw.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
