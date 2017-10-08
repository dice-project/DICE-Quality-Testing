package com.github.dice_project.qt.util;
//author: yifan

import java.io.InputStream;
import java.util.Properties;

public class PropertiesFromXML {
	
	public Properties getPropertiesFromXML() throws Exception{
		  
		    final Properties props=new Properties();		    
		    InputStream in = (InputStream) getClass().getResourceAsStream("/qtlib-config.xml");
		    props.loadFromXML(in);
		    in.close();
		    
		    return props;
	}

}
