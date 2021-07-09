---
title: Analyzing Who's Hiring Data on HackerNews with Interactive Python
layout: post
date: '2021-07-01 23:56:12'
tag:
- blog
category: blog
author: blaine
description: desc
---

HackerNews has a monthly [thread](https://news.ycombinator.com/item?id=27699704) where employers can post job listings.  [Interactive Mode in Visual Studio](https://code.visualstudio.com/docs/python/jupyter-support-py) is something I recently discovered that puts a notebook inside Visual Studio.  Here, I'm going to put those two things together to use Interactive Mode to lightly analyze job postings on HN.

The Python Notebook in git  [github.com/iblaine/hn-whoshiring-analysis](https://github.com/iblaine/hn-whoshiring-analysis).

![]({{ 'assets/images/projects/hn-analysis-walkthrough.gif' | relative_url }})

**Some questions we will be able to answer with this analysis...**
* How has the popularity of "Data Engineer" changed over time?
* How has "remote" factored into job descriptions since covid?
* What companies have been posting the most to HN Who's Hiring threads over time?

**Interactive Mode in Visual Studio**<br>
[Interactive Mode in Visual Studio](https://code.visualstudio.com/docs/python/jupyter-support-py) is a notebook built into your IDE.  A line with<br>
`# %%`<br>
creates a new cell for operations.  That is it.  Each `# %%` is a cell that can be run individually or put into debug mode.

**Rough requirements for this analysis...**
* Collect every HN posts post from Jan 2013 to July 2021.  (comes out to 103 HN threads & ~67,493 job postings)
* Collect header for each post (first line of every post) and parse it as company_name, location, job_title, salary
* Search entire text for keywords, count if the keyword is found in an item, count the frequency of a keyword in a post

**Definitions**
* post = An HN Who's Hiring post, that gets created on the first of every month.
* item = When a user creates a new message in a post, we call that an item.  A post contains many items.
* cell = A block of code created with `# %%`.
* cnt_total = 1 if the keyword is found in an item.
* cnt_unique = number of times a keyword is found in an item.

**General process for this notebook**
1. Collect every HN Who's Hiring posts.  Here we use pull up a Google search page for what should be the HN post for a given month.  Selenium is used for the scraping.
2. For every post on HN, get every item in that post.  This is time consuming.
3. Parse collected data into a dict.
4. Save dict to a file on disk.
5. Demormalize data into a pandas dataframe.
6. Analyze data.

**Notes for this notebook**
* There are 2 types of cells in this notebook, those for testing marked `# skip / debug` and the rest needed to do the things.
* I added `sys.exit(1)` to avoid running every cell all at once.  Feel free to remove that as needed.
* Data was collected from 2013-01-01 to 2021-07-01.
* Google search results are used to find historical HN posts because that seemed convenient at the time.

**Analysis...**
* Number of items in an HN Who's Hiring post by month.
![]({{ 'assets/images/projects/graph-hnwhoshiring-by-month.png' | relative_url }})
* How has the popularity of "Data Engineer" changed over time?
![]({{ 'assets/images/projects/graph-dataengineer-by-month.png' | relative_url }})
* How has "remote" factored into job descriptions since covid?
![]({{ 'assets/images/projects/graph-remote-by-month.png' | relative_url }})
* Which companies post the most?
Threads for: [March 2013](https://news.ycombinator.com/item?id=5304169) & [July 2021](https://news.ycombinator.com/item?id=27699704)
![]({{ 'assets/images/projects/data-top-posters.png' | relative_url }})


**Conclusions**
* Interactive mode in Visual Studio is a nice tool.  Probably not ideal for enterprise work, but it's convenient and easy to use for quick analysis.
* "remote" is showing up more frequently post covid.  No real surprise there but interesting none the less.
* As of 2018, Data Engineering became a real job, and its popularity is increasing.
* Apple is a frequent poster while other FANG companies are not (the dirty source data may be a root cause).
