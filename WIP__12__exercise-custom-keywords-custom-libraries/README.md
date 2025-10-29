# Exercise 12 - Create Custom Keywords

Welcome to **Exercise 12**. Everything you need to know about creating Custom Keywords.

# Purpose

The purpose of this exercise is to learn how Custom Keywords are created and used.

# Prerequisite(s)

- Access to a Copado Robotic Testing Organization is required
- Access to a Project
- Robot created

# Learning Objectives

- Create Custom Keywords by Grouping keywords
- Update Custom Keywords with Argument for any test data
- Create Custom Keyword / Library using python

# Create Custom Keywords by Grouping keywords

Custom Keywords allow for making your test more readable.

1. Create a new empty suite **exercise 12 custom keywords custom libraries**

2. Create a folder in the root named **12__exercise-custom-keywords-custom-libraries**

3. In folder **12__exercise-custom-keywords-custom-libraries**, create file custom-keywords.robot and copy the contents from here [custom-keywords.robot](custom-keywords.robot)

4. View and review **Test Case Exercise 12 - Custom Keywords - Step 1 Grouping and it's Custom Keywords** written in the keywords table below the test cases.

5. Run the test cases in live testing

# Update Custom Keywords with Argument for any test data

Custom Keywords allow for re-using automated assets that were created before. Add arguments to it to pass any test data to it.

1. Open suite **exercise 12 custom keywords custom libraries**

2. Open folder in the root named **12__exercise-custom-keywords-custom-libraries**

3. Open custom-keywords.robot

4. View and review Test Case **Exercise 12 - Custom Keywords - Step 2 Replace values with arguments** and it's Custom Keywords written in the keywords table below the test cases.

5. Run the test cases in live testing

# Create Custom Keyword / Library using python

Custom Keywords written with a python library allows for more technical implementations leveraging from python libaries.

1. Open suite **exercise 12 custom keywords custom libraries**

2. Open folder in the root named **12__exercise-custom-keywords-custom-libraries**

3. In folder **12__exercise-custom-keywords-custom-libraries**, create file custom-lib_keywords.robot and copy the contents from here [custom-lib-keywords.robot](custom-lib-keywords.robot)

4. In the root folder create a folder named **libraries**

5. In folder **resources**, create file CustomLib.py and copy the contents from here [CustomLib.py](../libraries/CustomLib.py)

6. Run the test case in **custom-lib-keywords.robot** using live testing