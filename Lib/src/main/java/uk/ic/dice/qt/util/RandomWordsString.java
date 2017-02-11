package uk.ic.dice.qt.util;
//author: yifan

public class RandomWordsString {

	public static char getRandomLetter(char pervious) { 
		  char[] a =new char[4];
		  a[0]=(char)('a' + Math.random() * ('z' - 'a' + 1));
		  a[1]=(char)('A' + Math.random() * ('Z' - 'A' + 1));
		  a[2]=',';
		  a[3]='.';
		  if(pervious==','||pervious=='.')
		  {
			  return a[(int)((Math.random())*2)];
		  }
		  else {
			  return a[(int)((Math.random())*4)];
			  
		  }
	}
	
	 public static String createRandomString(int size) {
		   
	      String string="";
	      char pervious=',';
	      for (int i = 0; i<size ;i++) {
	            char ch;
	            ch = getRandomLetter(pervious);
	            pervious=ch;
	            string+=ch; 
	        }
	      return string;
	   }
}
