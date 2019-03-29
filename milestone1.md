

## Question
Identify the question that your team in interested in answering with the survey.

#### Topic of Research:
* Does hours of sleep/study/lectures influence retention level of MDS material?

#### Confounding Factors (Other Questions)
* Hours spent on average studying (per week)
* Hours spent on average sleeping (per week)
* Attendance in Lectures, Labs, Office Hours

#### Respondent Information
* Student/Alumni/TA/Instructor

#### Aspects of the _UBC Office of Research Ethics document on Using Online Surveys_ that are relevant to our proposed survey.  
* __Current law__ :    
>As per FIPPA , any public body must ensure any personal information in its custody should be stored and accessed only in Canada. As per the FIPPA, "personal information" is any data which can directly identify an individual also someone’s personal opinions about something is considered “personal information” if the information is linked or could possibly be linked to the individual. Also, an IP address constitutes indirectly identifying information. 

>If and only if, __we are not collecting any personal information in our survey, then we are free to use whatever online survey tool we prefer__ as long as the survey is completely anonymous – i.e. the online survey tool we are using has the capability to switch off the IP tracking feature (online survey tools collect this information from users as a matter of course).


* __What our survey is collecting__  
>Our survey is collecting non-personal information, like how many hours spent on average studying per week, hours spent sleeping. Both these information even if combined with other quassi data cannot identify any individual. As hours spent studying and sleeping is not unique to any individual . Other information we are collecting is regarding the attendance in lectures, labs and office hours. Which will be collected as generalized information. Like, regular, irregular etc. Hence, that will make the non personal information even more anonymized. We are not collecting any student id or email address so no IP address can be stored by the online survey. The anonymous responses will not be published .

* __How the survey results are analyzed__  
  
> The survey questions are divided into two groups. One group is designed to capture the features of the interests such as average hours of sleep and average hours spent on studying per week. The other group is the collection of questions that will measure the retention of the knowledge from the UBC MDS program. 
>
> Linear regression will be performed to examine the correlation between the features and the target. An alternative approach will be categorizing the retention measure and use multiclass classification such as [SVC](https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html#sklearn.svm.SVC) or [Logistic Regression](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html#sklearn.linear_model.LogisticRegression) (setting multi_class=”multinomial”). 
>
> For linear models, the assumption is that there is an interaction between hours of sleep and hours of studying. For example, a student will have less time to sleep if he or she spends more time to study. ANOVA will be used to determine whether the interaction is significant. 
>
>Reference : https://scikit-learn.org/stable/modules/multiclass.html

* __Where do we stand according to FIPPA__    
>According to FIPPA, the data we are collecting is not personal information, so we can use any online survey tool(Highlighted in bold in second paragraph under 'Current Law'). Our selected survey tool also has the capacity to switch-off IP tracking. 

>We will create our survey using SurveyMonkey – www.surveymonkey.com , as we are not collecting any personal information also Survey monkey facilitates anonymous responses. Below is the link which states the anonymous response feature of Survey Monkey :   
Anonymous Response by Survey Monkey : _https://help.surveymonkey.com/articles/en_US/kb/How-do-I-make-surveys-anonymous_

