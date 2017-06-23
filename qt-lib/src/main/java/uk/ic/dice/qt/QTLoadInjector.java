package uk.ic.dice.qt;

import uk.ic.dice.qt.producer.*;
import uk.ic.dice.qt.spout.*;

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
