// ignore: constant_identifier_names
const ABOUT_APP = """
CADI AI is a demo-application that uses the technology Artificial Intelligence (AI). It looks at the pictures of cashew trees and then informs the user whether the Cashew tree suffers from:
 pest infection, 
 disease or 
 abiotic stress. 
KaraAgro AI developed CADI AI for the initiatives “Market-Oriented Value Chains for Jobs & Growth in the ECOWAS Region (MOVE/Comcashew)” and FAIR Forward - Artificial Intelligence for All 
Both initiatives are implemented by the Deutsche Gesellschaft für Internationale Zusammenarbeit (GIZ) on behalf of the German Federal Ministry for Economic Cooperation and Development (BMZ). 
    
CADI AI shall support farmers as an early warning system to quickly identify problems in their cashew farms and to keep their crops healthier and more yielding.
Please note that the application will not tell you which particular disease or pest a cashew tree suffers from or how to treat it. 

As with any application that uses AI: 
Please treat the results with caution because this system can produce wrong results. It is recommended to verify the diagnoses, for example, by seeking advice from a trained agronomist or extension officer before acting upon the diagnoses of the application. 

If you have any problem with the application or feedback, please reach out to support@karaagro.com. Your feedback would be very helpful to further improve the application.

If you want to know more about how CADI was developed, please have a look at KaraAgro’s GitHub.




""";

// ignore: constant_identifier_names
const CONFIDENCE_VALUES_EXPLAINER = """
The numbers displayed below represent how confident the AI system
is that the image has a certain crop stress (Abiotic, Diseased or Pest).

An output of 0.68 for a crop stress means that the system is 68% confident that the crop stress is present.
""";

// ignore: constant_identifier_names
const SCANNING_REQUIREMENTS = """
CADI AI supports only jpeg images taken from drones. Images from other sources must have geo-coordinates on them before inferencing can be done otherwise, they will be ignored.
""";
