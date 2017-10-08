package com.github.diceproject.qt;

import com.github.diceproject.qt.producer.*;
import com.github.diceproject.qt.spout.*;

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
