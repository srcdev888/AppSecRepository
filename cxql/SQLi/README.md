# Quick elimination of SQL Injection using CxAudit UI
* Author:   Pedric Kng  
* Updated:  06 Jan 2021

This exercise [AccountDao.cs](AccountDao.cs) illustrates 4 scenarios using CxAudit quick add functionality;
1. Parameters not sanitized leading to a SQL injection
2. Parameters are sanitized using prepared statements
3. Sanitization method not recognized not CxSAST; add to sanitizers
4. Interactive input not detected; add to interactive inputs

***

*Step1: Open CxAudit > New Local Project > [Select folder containing AccountDao.cs]*
![Load Project](1.LoadProject.png)

*Step2: Query > CSharp > Cx > CSharp_High_Risk > SQL_Injection*
![Execute Scan](2.ExecuteScan.png)

*Step3: Review the results*

- True Postive: Parameters are not been sanitized and feeded into a SQL statement
![Parameters not sanitized leading to a SQL injection](3.ParamsNotSanitized.png)

- No results because parameters are been sanitized using prepared statements
![Parameters are sanitized using prepared statements](4.SanitizedParam.png)

- False Postive: Proprietary sanitizers 'mySuperclean' are not been recognized by CxSAST
![Sanitization method not recognized not CxSAST; add to sanitizers](5.ProprietarySanitizer.png)

- False Negative: Parameter are not been recognized by CxSAST
![Interactive input not detected; add to interactive inputs](6.ParamNotRecognized.png)

*Step4: Adding the proprietary sanitizer to address false-positive*
    
1. View SQL Injection query
![](5.1.ViewSQLQuery.png)

2. Atomic query 'Find_SQL_Sanitize'
    ![](5.2.ViewSQLQuery2.png)

3. Add the proprietary sanitizer 'mySuperclean' to 'Find_SQL_Sanitize'.
    ![](5.3.Add_Find_SQL_Sanitize.png)
4. Extended query
    ![](5.4.ExtendedQuery.png)

5. Execute SQL_Injection query to see false-positive result been removed
    ![](5.5.FPRemoved.png)

*Step5: Adding the non-recognized input to address false-negative*
1. View Atomic query 'Find_Interactive_Inputs'
    ![](6.1.Find_Interactive_Inputs.png)
2. Add the inputs to 'Find_Interactive_Inputs'.
    ![](6.2.Add_Interactive_Inputs.png)

3. Extended query
    ![](6.3.ExtendedQuery.png)
4. Execute SQL_Injection query to see false-negative result been added
    ![](6.4.FNAddressed.png)
  
