---
title: Data Engineers need to be better at Systems Design
layout: post
date: '2019-04-30 09:48:55'
tag:
- blog
category: blog
author: blaine
description: desc
---

Systems Design in Data Engineering is becoming increasingly important. As the data industry becomes increasingly complex, the cost to build frameworks is increasing, as well as the need for good systems design skills.  These examples have been taken from LinkedIn, Airbnb, and Chegg.

**First, some horror stories to demonstrate when Data Engineering goes wrong.**

**2,000 line ETL job in Python**

This ETL job was written entirely in python to ingest data, transform it, and write to several tables. It was difficult to maintain and understand. No one wanted to touch this process for fear of permanently breaking it. This ETL slowly grew out of control over the years. To avoid this problem, the ETL process should have stuck to the principle that a single process should have a single purpose.

**The magical ETL tool**

This ETL tool was written in house with good intentions but eventually had to be replaced. This tool could ingest an event steam, structure unstructured data into automatically generated tables, then create pseudo facts and dimensions. It was impressively feature rich but also complex and too closely coupled with a specific database. It began to fail as the needs of the business outgrew the primary goals of the tool. To avoid this problem, it should have been split into multiple services.

**Using the wrong tool for the wrong job**

This data pipeline was feature rich and built with too many tools. It included a complex tech stack of Informatica, Informatica Cloud, SQL, MS SQL stored procedures & Powershell. Informatica was used only as a dependency manager, which was a red flag. The original developers were under pressure to deliver, they picked technologies they were unfamiliar with, then used them incorrectly. The framework created facts with attributes and dimensions with measures. Technologies were used for the wrong reasons and design patterns were broken.

**How could these problems have been avoided?**
* The Single Responsibility Principle should be followed for nodes within data pipelines
* ETL processes should be Idempotent
* Scope creep should be recognized as it happens
* Avoid committing code in bulk. Small commits speed up the process to find problems and make deployments easier to digest.

**Data Engineering is now Software Engineering**

Data Warehouse Architectures used to be built by a collection of a few dozen large software vendors like SAP, Business Objects, Cognos, Informatica, Oracle and Teradata. Frameworks were the software you purchased, with Data Engineers building scripts to take care of the long tail of requirements. Todays industry is more complex. There are hundreds of solutions to pick from between Amazon, Google, Apache and others. Companies build their own frameworks from scratch and tailor them to the tools they prefer. Scripts are no longer enough to successfully use today tools. Data Engineers need to be proficient at Systems Design.

**How can Data Engineers make the shift to think like Software Engineers?**

* For systems design, brush up using an online course in Software Design and Architecture
* For industry knowledge, listen to podcasts and read blogs such as Data Engineering Weekly and SF Data Weekly
* For general coding, practices on Leet Code. In algorithms, Data Engineers should be able to solve all easy challenges, most medium challenges, and some hard challenges.

To be fair, some of these problems listed above were caused by me, fixed by me or refactored by me. No one wants to learn from mistakes but it's better than making the same mistake twice.

[https://www.linkedin.com/pulse/data-engineers-need-better-systems-design-blaine-elliott/](https://www.linkedin.com/pulse/data-engineers-need-better-systems-design-blaine-elliott/)
