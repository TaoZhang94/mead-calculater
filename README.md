# mead-calculater
An iOS based application

Spec

To brew mead (a traditional honey-based alcoholic drink), brewers combine water, honey and yeast. The amount of honey governs the final alcohol content. Therefore, mead brewers need to consider the target alcohol level when calculating how much honey to add.

This is readily available in imperial measurements, but not so common in metric.

Task
The goal is to produce an app that will take allow the user to enter two values:

Water volume (initially in gallons)
Honey weight (initially in pounds)
Using those two values, it will calculate the percentage of alcohol in the final drink once fermentation is complete.

alcohol = (pounds of honey / gallons water) * 5
Using this formula, 1 pound of honey in one gallon of water will create a 5% alcohol drink, while 15 pounds of honey in 5 gallons of water provides 15% alcohol.

In addition, it should cacluate the specific gravity. Each pound of honey increases the specific gravity of the must (the honey/water mixture) by 35 points. Water has a specifc gravity of 1. One pound of honey added to one gallon of water gives a specific gravity of 1.035. Thus the formula becomes:

specific gravity = 1 + ((pounds of honey / gallons water) * 0.035)
Finally, when brewing is complete the specific gravity will be 1. However, if not all of the honey is converted to alcohol the final specific gravity will be different. If, for example, you employ a 12% alcohol tolerance yeast, not all of the honey will be converted.

Therefore, if you start with 3 pounds of honey to one gallon of water, you would expect to start with a specific gravity of 1.105, produce a mead with an alcohol volume of 15%, and end with a specific gravity of 1. But if the yeast has a 12% alcohol tolerance, not all of the honey will be converted to alcohol, and the final specific gravity will be ( (1.105 - 1) / 15) * (15 - 12) + 1, or 1.021, or alternatively

final specific gravity = ((specific gravity - 1) / alcohol) * (alcohol - yeast tollerance) + 1 
