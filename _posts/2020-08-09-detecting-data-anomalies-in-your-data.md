---
title: Detecting Data Anomalies In Your Data
layout: post
date: '2020-08-09 08:09:00'
tag:
- blog
category: blog
author: blaine
description: desc
---

This project is still in an alpha phase...and I do hope it gets to a point where this can be shared, used, poked at, prodded, and improved.

**What?**
The Data Anomaly Detection Tool("DAD Tool") is a tool that can assess data for abnormalities at scale.

**Why?**
Newly generated data can be difficult to trust.  Every situation is unique and some organizations are going to struggle more than others.  Generally speaking, an organization that consumes a lot of unstructured data is going go have a more challenging time trusting the data it consumes.  With that in mind, we want tools that can improve our ability to trust our data.

**How?**
The DAD Too) was created using python, Flask, and AWS...for the most part.

**What else?**
Here's a deck that was created to describe the tool: [https://www.slideshare.net/iblaine/using-airflow-for-tools-development](https://www.slideshare.net/iblaine/using-airflow-for-tools-development)

What's interesting about the DAD Tool is how the architecture uses lightweight Python classes for the math behind the statistics, takes advantage of databases to do the heavy lifting of transporting data and uses Airflow as part of the backend.  All that is a longer conversation, but basically the DAD Tool aggregates statistical requirements, leverages Airflow as an outsourced orchestration tool, and simplifies the execution of tests for users.  With a few clicks, new tests can be added to assess every column of every table in a schema.