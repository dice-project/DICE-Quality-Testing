package com.github.dice-project.qt.util;
//author: yifan

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.github.dice-project.qt.util.PropertiesFromXML;


public class LoadConfigProperties {

       private PropertiesFromXML propsFromXML;
	private Properties props;
	private Map<String, Object> confSpout;
       public Class<?> spoutClass;

	private LoadConfigProperties() {

        try {
        	
		propsFromXML =new PropertiesFromXML();
		props=propsFromXML.getPropertiesFromXML();

		confSpout=new HashMap<String, Object>();

		confSpout.put("spout", "spout");

		spoutClass = Class.forName(props.getProperty("spout.type"));
		confSpout.put("filePathList", props.getProperty("file.name"));
		confSpout.put("uniformDivided", props.getProperty("spout.uniformDivided"));
		confSpout.put("parallelism", props.getProperty("spout.parallelism"));
		confSpout.put("exponentialDivided", props.getProperty("spout.exponentialDivided"));
		confSpout.put("exponentialScale", props.getProperty("spout.exponentialScale"));
		confSpout.put("exponentialRange", props.getProperty("spout.exponentialRange"));
		confSpout.put("uniformCut", props.getProperty("spout.uniformCut"));

        } 
           catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	
	public static LoadConfigProperties createLoadConfigProperties() {
		return new LoadConfigProperties();
	}

	public Map<String, Object> getConfSpout() {

		return confSpout;

	}

	public Properties getProps() {

		return props;

	}

       public int getParallelism() {
		
               return Integer.valueOf(props.getProperty("spout.parallelism"));
	}

       public Class<?> getSpoutClass() {

		return spoutClass;

	}
}

