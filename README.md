#C4ADS NDA-nonsensitive
Snapshots of my contributions to my internship with the Center For Advanced Defense Studies , such that NDA sensitive content is stripped away.

# SanctionsExplorer - Data Science Contributions

|<h3>Labs 24</h3>| |
|:-:|:-:|
|[David Dodds](mailto:dadodds@umich.edu)|[Jessica Wolfe](mailto:jayellwolfe@gmail.com)|
|[<img src="./Notebooks_and_Data/David_Dodds_Files/images/IMG_4061_cropped_square.jpg"  width = "200" />](https://github.com/ddodds42)|[<img src="./Notebooks_and_Data/David_Dodds_Files/images/jwolfe.JPG"  width = "200" />](https://github.com/JayellWolfe)|
|[<img src="https://github.com/favicon.ico" width="15">](https://github.com/ddodds42) [<img src="https://static.licdn.com/sc/h/al2o9zrvru7aqj8e1x2rzsrca" width="15">](https://www.linkedin.com/in/david-dodds-043014154/)|[<img src="https://github.com/favicon.ico" width="15">](https://github.com/JayellWolfe)|

Feel free to contact any or all of us if you have any questions! You can also contact us on Slack. Ask Patrick or Hammad to add you to the "sanctions_stakeholders" channel of the "Students at Lambda School" slack workspace.

## Project Overview
[The Center for Advanced Defense Studies](https://c4ads.org/) (C4ADS), in collaboration with Lambda School and UC Berkeley's Archer, created *Sanctions Explorer*, a web application that enables users to search through entities (individuals, organizations, vessels, aircaft, etc.) that the US government, EU, or UN have sanctioned. C4ADS wants to improve entity recognition in the database, search result accuracy, analytics, visualizations, search tools for various government agency reports (mainly UN "Panel of Exprets) reports), and more.

Read [Max's article about the purpose motivating the project.](https://maxefremov.com/sanctionsexplorer/)

# So this project just fell in my lap... Where do I even start?
No future iteration of SanctionsExplorer, no matter how sexy it looks, is an improvement upon prior iterations unless its search return accuracy is better than prior iterations. C4ADS has made it clear that their reputation for providing accurate sanctions information to SanctionsExplorer users is of utmost importance. Business decisions made with outdated or inaccurate sanctions information can at best lead to a lost business opportunity (the false positive scenario, in which a SanctionEx user refuses business with another entity that has been removed from sanctions, but SanctionEx did not tell the user that) or at worst severe punishment and loss of legitimacy to SanctionEx users who accidentally do business with currently sanctioned entities (the false negative scenario. The dude was sanctioned, but SanctionEx didn't tell the user).
## I'm sure a whole slew of questions is swirling around in your head about this...
How could a search engine not return the contents of its database with 100% accuracy? How are you even measuring accuracy? How hard could it be to push accuracy to its utopian pinnacle?
# This is where Entity Reconciliation enters stage right.
The reason that accuracy is distorted in the flow from database to front page is that, aside from the messiness and nullness of much of the scraped data, most of these individuals are actively trying to evade international law, and are therefore constantly trying to evade their own data fingerprint. When you actually look at the data, this looks like 15 passports... 8 addresses in 4 distinct nations... 30 aliases... *all belonging to the same person*. And these sanctioned entities can appear in the database potentially dozens of times, in rows scattered at any index position, with each row containing only a fragment of the full data belonging to that same multi-misrepresented person.
## Entity Reconciliation is the process by which all disperate entries (rows) of the same entity are identified and united under a single primary key...
So that every single data point buried in the database... *which is verifiably known to belong to that entity*... is actually retrieved and shown to a user when the entiy is searched by any of their 60 bajillion names and / or criminal enterprise partners.

During the course of Labs24, we performed Manual Entity Reconciliation (MER) in SQL to create a Search Accuracy Meter Stick (SAMS).
The SAMS, at this point, is an excel spreadsheet listing 30 quasi-randomly selected entities. I attampted to evenly distribute these 30 entities among the 4 entity types (individuals, organizations, vessels, and aircraft) and select from no more than one nation per entity type, so that the subsample would not be linguistically biased by the dominance of Iran and North Korea (testing diverse lingual distortions translated into English may be important for future fuzzy search functionality). 

Those entities were then reconciled manually to add all available datapoints on each of those 30 to the SAMS. Once documented in the SAMS, those datapoints were then compared to datapoints returned be the in-app search results for an accuracy score.

MER enabled us to make judgement calls about datapoints based on our own geopolitical knowledge, and witness / correct for data inconsistencies that the OFAC dataset tossed our way to try to trick us. But it is very time consuming. This is why your next steps for the Data Science work on Sanction Explorer will be to write scripts and algorithms to make the same judgements a geopolitically knowledgeable human would make during MER, but faster and more programattically.

# Automated Entity Reconciliation (AER)
To preserve the integrity of search results SanctionEx returns to users, the integrity of business decisions made by SanctionEx users, and the reputation of C4ADS as the provider of this resource, you must strive to reconcile every entity in the database. To do this in a timely, efficient manner, you will need to perform AER on the data.

For more details on getting started with this, jump over to [my folder within the repo](https://github.com/ddodds42/C4ADS_nda_nonviolating/blob/main/AER.md) and peep the README.md.
