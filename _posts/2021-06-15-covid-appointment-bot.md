---
title: The Anatomy of a Covid Appointment Bot
layout: post
date: '2021-06-15 20:22:11'
projects: true
hidden: true
Description: Anatomy of building a covid appointment bot.
---

When covid vaccine appointments were initially rolled out, they were difficult to book, requiring users to navigate confusing forms, refresh pages and pray for openings.  To ease the frustration for nearby friends & family, I created a python script to automate the steps to find covid appointments.  Things snowballed from there into this twitter bot.  The bot ran for 3 months, generated 12,349 tweets, 106,353 clicks and cost $1.25/day. 

**TL;DR;**  I created a twitter bot to help people find available covid appointments, it served a purpose by minimizing the pain of finding appointments and maintaining accurate searches required constant maintenance.

![]({{ 'assets/images/projects/covid-vaxster-the-cure.png' | relative_url }})

The general business logic to find a covid appointment was relatively simple.  Look for a covid appointment, collect available appointment data, then post a tweet if necessary.
![]({{ 'assets/images/projects/covid-vaxster-logic.png' | relative_url }})

**Technical Notes**

* A persistent Amazon EC2 instance was used.
* Terraform was used to simplify deployments and give me an opportunity to learn terraform.  Initially I thought I'd spin up a container for each search, which would have removed most limits on scaling, but I never got beyond searching ~50 clinics at a time.
* Searching was done using Python + [selenium](https://github.com/SeleniumHQ/selenium/).
* A poor man's CI/CD was implemented such that development was done on my mac, pushed to git, then the EC2 instance pulled down changes every hour.
```
from sys import platform
prod = True if platform == "linux" else False # dev = my mac, prod = AWS
if prod == False:
    <use mac libraries, see chrome windows>
elif prod == True:
    <use EC2 libraries, headless chrome>
```
This tiny feature made my life much easier, so I'm pointing it out here.  There was a constant need to debug scraping logic and this hack cut down the effort needed to deploy the many incremental updates.
* Clinics were added via YAML using the following format...
```
state:
    california:                                                                                                         # Name of the state
        santa_barbara:                                                                                                  # Name of the county
            costco:                                                                                                     # Name of the clinic
                twitter_name: "Costco"                                                                                  # Name to use in a tweet
                status: "active"                                                                                        # Can be active/inactive
                url: "https://book.appointment-plus.com/d133yng2/#/book-appointment/select-a-location?_qk=lbvsv9hv4u"   # Target URL to begin a search
                cuttly_url: "https://cutt.ly/0vwl8qL"                                                                   # URL to use in a tweet
                city: "santa_maria"                                                                                     # Name of city where clinic is located
                data:                                                                                                   # Information to help the selenium actions
                    id: 477                                                                                             # Misc info needed for this particular clinic
                    selectEmployeeButton: 1097                                                                          # Misc info needed for this particular clinic
```
In this case we're searching for a Costco clinic.  A posted tweet would look something like...
[![]({{ 'assets/images/projects/covid-vaxster-tweet.png' | relative_url }})](https://twitter.com/CovidVaxster/status/1396707760612560897)
* The Twitter API was used to expose search results via [@CovidVaxster](https://twitter.com/covidvaxster).  More on why I settle on twitter instead of a website below...
* My original idea was to present the data on a website, but the reality is this bot was difficult to scale.  Daily maintenance was often required, sometimes several hours at a time.  I instead focused my efforts on creating accurate searches for the 3 nearest counties in my area: San Luis Obispo, Santa Barbara, & Ventura.
* Pagination was done on several clinics to collect the number of available appointment slots.  This way I could give users some sense of timeliness to create an appointment.  Where possible I added logic to paginate through sites, which also added to maintenance costs.
* Traffic monitoring was done through [cutt.ly](https://cutt.ly/).  If a user clicked a link in a tweet, then [cutt.ly](https://cutt.ly/) recorded a click.  This way I could get a sense of whether or not these tweets were being used.  To date I believe the tweets were used, at least 100k times.  Based on UserAgent analysis, it seems like 40% of the traffic was bot activity.
* Twitter Tags were used to search for appointments by city.  Search for ["#vaxster #santabarbara"](https://twitter.com/search?q=%23vaxster%20%23santabarbara) and you'll see the most recent available appointments BUT twitters spam filter has removed most tweets.  The tags did reference all tweets in the past...   `¯\_(ツ)_/¯`

**Vaxstter Code**

Vaxster code to manage the search logic + Helper code to manage Terraform & twitter...
```
Vaxster code
.
├── clinic.py                           Manages generic business logic
├── clinic_libs                         Collection of selenium scripts designed to navigate individual clinics
│   ├── __init__.py
│   ├── costco.py                       Selenium steps to check costco
│   ├── cvs.py                          Selenium steps to check cvs
│   ├── goleta_valley_cottage_frame.py  Selenium steps to check a local hospital v1
│   ├── goleta_valley_cottage_v1.py     Selenium steps to check a local hospital v2, needed after the hospital refactored some links
│   ├── mhealthcheckin_v1.py            Selenium steps to check albertsons/ralphs/savon v1
│   ├── mhealthcheckin_v2.py            Selenium steps to check albertsons/ralphs/savon v2, needed after mhealthcheckin refactored their UI
│   ├── santa_barbara_medcenter.py      Selenium steps to check a local clinic in Santa Barbara
│   ├── slocounty_ca_gov.py             Selenium steps to check San Luis Obispo
│   └── walgreens.py                    Selenium steps to check walgreens
├── config.yml                          YAML file for clinic information
├── county.py                           Manages counties, forks parallel selenium threads
├── requirements.txt
├── state.py                            Intended to manage multiple states but I never managed to move beyond California
└── vaxster.py                          Mostly reads YAML settings then kicks off states.py

Helper code
.
├── collect_stats.py                    Collect click stats from cutt.ly, post results to twitter
├── terraform
│    ├── main.tf
│    ├── outputs.tf
│    ├── provider.tf
│    ├── user_data.tpl                   Commands to set up a new EC2 instance: add AWS creds, install chrome driver, clone git repo, etc.
│    └── variables.tf
└── twitter_helper.py                   Create tweets using the twitter API
```


**The evolution of clinic searches**

Clinics went through some not so obvious changes over time, where demand and supply fluctuated dramatically.  Here's a brief description of how that went.
* <u>Initial Rollout</u><br />
January 2021 - February 15th, 2021<br />
Clinics began to allow the public to book their own appointments.  Period of high demand with limited vaccine appointment availability.  This period probably marked the point where this bot delivered the most value.  There was little information on how to book an appointment, let alone find availability.
* <u>The Winter Storm</u><br />
February 15th, 2021 - Feb 28th, 2021<br />
During this period, a [massive winter storm](https://en.wikipedia.org/wiki/February_13%E2%80%9317,_2021_North_American_winter_storm) hit the midwest and impacted the vaccine supply chain.  Many existing appointments were cancelled and new appointments were difficult to find.  I disabled most searches during the this time because supply was so low.
* <u>High Availability / High Demand</u><br />
March 2021 - April 20021<br />
This period marked a lot of activity where appointments were widely available and in high demand.  Supply chain problems slowly went away and clinics made needed improvements to their booking processes, which also meant constant updates were needed to keep up with website updates.
* <u>High Availability / Low Demand</u><br />
This period marked the beginning of the end of the need for a vaccine bot.  Vaccine supply chain problems were mostly solved by now.  There was a period for a few days where activity dropped significantly, due to several clinics updating their websites at around the same time.  As time went on, the workflow for clinics grew in complexity, and so did updates.  Over time it became increasingly difficult to keep up with updates, and necessary updates became increasingly costly.

![]({{ 'assets/images/projects/covid-vaxster-timeline.png' | relative_url }})

**Maintenance**

Maintenance was the biggest surprise.  At best, every new clinic was a few lines in a YAML file.  At worst, every new clinic was a new python class.  To expand on that, here's a generalization of the different types of clinics

* <u>Required Login or Captcha</u><br />
This included any clinic that required a login or a captcha to search for appointments. I excluded these clinics as to ‘do no evil’ on the interwebz. Any clinic requiring a captcha to search appointments was not meant to be searched.
* <u>Nationwide Clinics</u><br />
This included CVS, Ralphs, Albertsons, & RiteAid.  The nice thing about these clinics was once a selenium script was created for one clinic, the logic could be repurposed for many clinics.
* <u>Hospital Chains</u><br />
Local hospital chains we're pretty valuable, such that they had consistently reliable appointment information.
* <u>Urgent Care Clinics</u><br />
This included privately owned urgent care clinics.  The supply on these clinics was very low, but consistent.  They were hidden gems of appointments that showed up for a few days at a time.
* <u>Mass Vaccination Sites</u><br />
This includes one off mass vaccination sites.  The web interfaces were very subjective, such that I could put a few hours into scraping them, get a lot of appointments for a short amount of time, then never be able to reused that code again.

Keeping searching running and able to deliver accurate appointment data was an ongoing chore.  Part of me thinks the govt dropped the ball by not rolling out a nationwide covid appointment booking website, but that now seems like a near impossible task.


**Lessons learned**

* Scaling a search engine across clinics is exponentially difficult.  Every clinic, county, and state, may have their own way of managing covid appointments.
* Terraform is convenient, but figuring out VPCs, SGs, and IAM roles is a chore.
* Twitter is full of spam.  40% of my clicks seem to have been generated by bots.
