package com.github.dice_project.qt;

import com.github.dice_project.qt.producer.*;
import com.github.dice_project.qt.spout.*;

public class QTLoadInjector {

	 public QTLoadInjector() {  
     }  

	 public RateSpout getRateSpout() {  
         return new RateSpout();  
     }  

	 public RateSpout getRateSpout(String filePath) {  
         return new RateSpout(filePath);  
     }  

	 public RateProducer getRateProducer() {  
         return new RateProducer();  
     }  

}
