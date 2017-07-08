package com.github.dice-project.qt.util;
//author: yifan

public class UniformDistribution {
	
	public static int num=1;
	
	public static int divisionPerSecond(int dataSize, int uniformCut)
	{
		for(int i=1;i<=uniformCut;i++)
		{
			if(dataSize%i==0&&1000%i==0)
			{
				num=i;
			}
		}
		return num;
	}

}
