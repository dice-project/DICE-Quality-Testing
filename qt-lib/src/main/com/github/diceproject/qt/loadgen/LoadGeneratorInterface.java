package com.github.diceproject.qt.loadgen;
// author: yifan

import java.util.Map;

public interface LoadGeneratorInterface {
	
	public void generateLoadForWords(Map<String, String> conf);
	
	public void generateLoadForBinary(Map<String, String> conf);	

}
