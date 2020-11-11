# Manual Entity Resolution Process  (MERP)
## For the develoopment of a Search Accuracy "Meter-Stick" (SAMS)
- Entities in the scraped OFAC database appear in many rows, with many different aliases and addresses, but without a standard primary key identifier.
- Therefore, we need some way to resolve entities by primary key for accuracy checking of search results (with a pseudo-random, representative subsample of entities), the development of a SAMS
- Eventually this entity resolution process will be deployed in the search tool itself, so that the entity card search results returns the most up-to-date information for an entity _within the current dataset_. I.e., aliases with more accurate or up-to-date information about a perp are not being missed in an entity card search result.
- Note that this precludes "most up-to-date" data points that are so new that they have not yet been funneled into the database (datapoints still floating out in cyberspace). We need to first make sure that just the information contained in the database is returning to the user the most accurate and up-to-date version _of itself_.
- I am documenting my MERP here with the hopes of automating it. It is a fun process; like detective work... but it is very time consuming.
-Entity resolution must be automated so that it can be more rapid, separate from potential human error (while somehow maintaining the same human sense for such things as mispellings, geographic prior knowledge, linguistic attributes, etc.), and reproducible on new data.
- Automated Entity Resolution (AER) will eventually allow for search accuracy improvement in newly scraped OFAC data, EU, UN, and POE block-text data.


# 4 phases for deploying a SAMS with MERP
- ## Phase 1: Selecting 30+ random entities.
- ## Phase 2: MER - find all hidden rows of each of your 30 entities.
- ## Phase 3: MER for SAMS creation - capture datpoints from all observations of each entity
- ## Phase 4: Using the SAMS to gauge the accuracy of current in-app searches.

# TLDR: just the named steps and phases:


# Explanatory detour, because you might already be confused.
## What is entity resolution? Why do we need it for this project? What is the point? What is an SAMS, and how will it be used?
A breif story about KOMID, the Korea Mining Development Trading Corporation, might help illustrate the problem.

![Korea Mining Development Trading Corporation](/Notebooks_and_Data/David_Dodds_Files/images/KOMID.jfif)

KOMID is a corporation that funnels minerals between Russia and North Korea against international sanction law. North Korea is sanctioned from this type of trade because they would rather use the minerals to build uranium bombs and propaganda stadiums than agro-machinery or a decent electric grid for their people.  When I was selecting representative subsample of entities, I wanted to include an individual from  from North Korea, because North Korea was one of the top 5 most common nationalities for entities of type individual. Upon randomly selecting an index position filtered from "individuals" of "North Korean" national origin, an individual named Kim Kyu was drawn; the External Affairs Officer of KOMID.

Since Kim Kyu's name was selected, he will be used as one of the 30 Entities in the SAMS. This means that I must find all occurences of Kim Kyu in the database, no matter what alias they are listed under, and use all of those rows to infer what datapoints should be displayed on a search of Kim Kyu, which might not currently be displayed at present.

![Kyu Kim amplify app search result](/Notebooks_and_Data/David_Dodds_Files/images/Kyu_Kim.JPG)

This entity card, returned by a search of the old amplify app, only contains 16 data points, and no aliases. A more thorough prodding of the database, fom the backend using SQL, yeilds 2 other rows named 'Kyu Kim', which connects him to the aliases "Ho-'Kyu Kim" and "Ho-Gyu Kim". By searching those two new aliases, another alias, "Aleksei Park", presumably a nickname given to hi by Russian business associates, and a secondary residence in southeast Siberia were found. When searching by that new alias and place of residence, more rows of Kyu Kim, Ho-Gyu and Aleksei Park were discovered which linked him to another mining corporation, the Korea Ryonbong Corporation.

By the time all of these aliases, residencies, and corporations were accounted for in a thorough data-hunt for Kyu Kim, a total of 18 instances of this indivudual were found in the dataset, all with differing sanctions statuses and dates. This is a huge problem because the breach of accuracy caused when the search result does not factor for all 18 observations of 'Kim Kyu' could lead to costly trading mistakes and international sanctions violations for companies using our inaccurate search result, including fines, criminal charges, and sanctions on misled users themselves!

In the case of the entity card search result pictured above, this is 70.83% accurate because of all of the missing data points. The 29% margin for inaccurate business decisions could be disastrous for a user. This is especially true of the aliases and the second corporation that it does not display.

Therefore, the SAMS has 30 such entities to use for cross-referencing search results with the holistic picture hidden throughout the database, so that an accuracy check of the search results are not totally biased by a single North Korean individual. The 30 entities rendomly selected to be holistically recorded in the SAMS are 10 individuals, 10 organizations, 5 vessels, and 5 aircraft. Half of entities selected from each of those 4 classes come from the 15 most sanctioned nations (the North Koreans, Iranians, etc.) and the other 15 entities are not affiliated with those most sanctioned nations, so that the subsample in the SAMS would be somewhat internationally representative.

But in order for an individual, aircraft, vessel, or organization in the SAMS to be ready for quality assurance of the search results, that entity has to be resolved manually, as I described with Kim Kyu above, so that no instances or datapoints of that individual are left unknown, unexamined, and unpresented by the search.

At some point, this entity resolution (MER) must be automated.

# Back to the regularly scheduled programming.
All sql query text can be found in c4ads-sanctions-explorer-ds/Notebooks_and_Data/David_Dodds_Files/MER_SQL_query_backup.txt OR the most recent console.sql file. They are specific to the ofac data at the time of writing this, but can hopefully be morphed easily for similar queries in new OFAC data, EU, UN, and eventually POE.

## Phase 1: Selecting 30+ random entities.
Selection of a repressentative, pseudo-random subsample of (a minimum of 30) entities to perform MER on.

### 1.1) Understand & interpret the data type in each column
Use this information to find which column contains entity types.

![Understand the features](/Notebooks_and_Data/David_Dodds_Files/images/sql_1_1.JPG)

### 1.2) Find which entity types are included in the dataset, and how many of each.
Used this output to determine the entity_type distribution of my subsample of 30: 10 individuals, 10 organizations ("entity" in the entity type column), 5 aircraft, and 5 vessels.

![Entity Class Distribution](/Notebooks_and_Data/David_Dodds_Files/images/sql_1_2.JPG)

### 1.3) Deterine which columns contain nationhood data for each entity type.
In this particular table, the column aircraft_operator has nationality information for the greatest number of aircraft. Included in the select statement are many other columns that may contain nationality information for a given entity_type. You just have to toggle through the columns one at a time for each entity_type to figure out which column contains the most nationality information for each entity_type. For individuals, organizations, and vessels, those columns happened to be "addres", "address" and both "vessel_flag" columns, respectively.


![Entity Nationality Columns](/Notebooks_and_Data/David_Dodds_Files/images/sql_1_3.JPG)

### 1.4) Count the frequency of each nation by entity_type
Using the best column(s) from 1.3, which are descriptive of the most entities' nationhood, group the nations by frequency of occurence for each entity type to determine which nations are most representative of sanctioned entities. In the example image below, manual googling of some of the airlines was necessary to determine their nationality.

![Entity Nationality Distribution](/Notebooks_and_Data/David_Dodds_Files/images/sql_1_4.JPG)

### 1.5) Allocate nations to entity slots for the random selection.
Once I googled the ambiguous airline names, I found that the two most common nationalities of sanctioned aircraft were Iranian and North Korean, wiht Ukrainian a close third. So of the five slots for aircraft in my list of 30 entities, I made sure to allocate one to a randomly selected Iranian aircraft, and a second to a randomly selected North Korean aircraft. The last three slots for aircraft are deignated to aircraft that are not Iranian or North Korean. The same slot allocation process was performed for the other 3 entity types by querying for their most common nationalities.

![Entity Nationality Slot Allocation](/Notebooks_and_Data/David_Dodds_Files/images/xl_1_5.JPG)

### 1.6) Randomly select entities designated a nationality.
For the slots with specified nations, sort out the entities of that nation using the preferred column from step 1.3. When the sql console shows you how many entities of that type and nation are in the dataset, set a random number generator to that number, x, so it will generate a random number between 1 and x. I just used the "Pretty Random" free app by Foxbytes on my phone. With the random number, n, that your generator produces, jump down to the nth result in the same query, and record its index position in your allocation list. Repeat this once for each designated nation of each entity type.

![Random Selection Known Nationhood](/Notebooks_and_Data/David_Dodds_Files/images/sql_1_6.JPG)

![Record Random Selection Known Nationhood](/Notebooks_and_Data/David_Dodds_Files/images/xl_1_6.JPG)

### 1.7) Randomly select entities NOT FROM those designated a nationality.
Repeat step 1.6, except exclude the nations that are pre-designated. And, upon randomly drawing a new nation, exclude that nation from subsequent draws if possible.

![Random Selection Unknown Nationhood](/Notebooks_and_Data/David_Dodds_Files/images/sql_1_7.JPG)

![Record Random Selection Unknown Nationhood](/Notebooks_and_Data/David_Dodds_Files/images/xl_1_7.JPG)


## Phase 2: MER - find all hidden rows of each of your 30 entities.
MER to find all hidden observations (index positions) of each same-entity in the dataset.

### 2.1) Align 30+ entities into a single spreadsheet for reference and recording newfound rows.
Record nationhood and entity name as well.

![new sheet for rowfinding](/Notebooks_and_Data/David_Dodds_Files/images/xl_2_1.JPG)

### 2.2) Record which columns contain info for the entity being investigated.
In the image below, I will show you from beginning to end the process for the dude in row 9, Dawood Ebrahim. I already manually reconciled the previous 6 incividuals. Dawood Ebrahim just happens to be where I left off when I decided to start documenting this processs. Anyhow, EDawg is now in the SAMS for examination because one of his columns, 41,888, was randomly selected. So find his observation in the database, and scroll right to FIND AND RECORD the names of every column that have some useful information for finding other instances of EDAwg. A column that just says "Pakistan", as in his nationality, might not be useful for MER, because there's thousands of other sanctioned entities from Pakistan. Use your common sense here. Record the useful columns in a notepad on the side.

![useful columns in query](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_2.JPG)

![useful columns in notepad](/Notebooks_and_Data/David_Dodds_Files/images/txt_2_2.JPG)

### 2.3) Copy that new identifying info from the query result into the notepad.

![identifying info in notepad](/Notebooks_and_Data/David_Dodds_Files/images/txt_2_3.JPG)

### 2.4) Move this index position into a WHERE NOT IN clause so you won't keep bumping into it in future queries.
You're hunting for novel rows. Bumping into the same ol' has-been already-found rows will get irritating quick.

![exclude found rows](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_4.JPG)

### 2.5) Start hunting with the value from the leftmost column.
Keep in mind that the target we're hunting for here are new index positions that **CORROBORABLY** belong to the same person. This is where you will see the "blob from outer space" begin to grow. Scroll right and examine the hidden columns for values that match what you copied into the notepad. Have the notepad open on the side so your eyes can dart back and forth.

![new finds](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_5.JPG)

![another new find](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_5_0.JPG)

### 2.6) Record the newly found index positions, stage them for cross-examination.

![cross examination staging](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_6.JPG)

![cross examination staging in notepad](/Notebooks_and_Data/David_Dodds_Files/images/txt_2_6.JPG)

### 2.7) Grab any new info from the newfound rows.
Stash it into the notepad. It can be used to find more hidden instances of the same person.

![cross examination query](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_7.JPG)

![cross examination new info](/Notebooks_and_Data/David_Dodds_Files/images/txt_2_7.JPG)

### 2.8) Exclude newfound rows and search a new query.
At this point, we're still going to be hovering in the initial name columns, writing searches with yet unused names / alias, until the name colummns stop finding new instances of our perp. This is where the number of new rows can balloon rapidly.

![new info query](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_8.JPG)

### 2.9) Repeat steps 2.2-2.8 with new info from new rows that emerge.
Eventually, you will reach marginal diminishing returns with the datapoints available in the name columns. At that point, begin to move to rightward columns, such as address, pob, dob, passports and national registrys, and eventually the affiliation columns.

### 2.10) Beware Cross-Pollinating columns.
There are 117 columns, but the vast majority fall braodly into 10 categories: names & aliases, location & nationality, title & affiliation, birth data, PINs (Personal ID Numbers), sanctions & laws, BINs (Business ID Numbers), Contact Info, Manufacture Specifications, and VINs (Vehicle ID Numbers). Searching columns within the same category is complicated by the "cross-polination" of similar columns. For example, names listed in the notorious "aka" (also known as) column can also be found in the columns "last_name", "first_name", "entity_name", "fka" (formerly known as), "nka" (now known as) and even "comments", as any of these columns also contain data pertaining to the name of the entity. The same nauseating phenomenon is true for the other category, A truly exhaustive reconciliation would check all available datapoints against every relevant column.

### 2.11) Dealing with aliases.
The OR queries in the image below, when unmuted, help for finding alias strings in the many cross-polinating name columns. The LOWER clause checks all strings in the given column as i they were all lower case, eliminating the need for case-sensitivity. The % signs in the string comprehension allow the search to be agnostic to leading or trailing characters, and the underscores in the string comprehension allow for flexibility of variant misspllings. The underscore tells the search to find the surrounding characters in context no matter what character might be where the underscor is, which is particularly useful if you're unsure whether the name is hyphenated, spaces, or apostrophed, or in the case of interchangeable phonemes / vowels. This logic can be applied to other cross-polinating columns.

![alias queries](/Notebooks_and_Data/David_Dodds_Files/images/sql_2_11.JPG)

### 2.12) Concluding an entity.
Fortunately, most entities have data points in only about a dozen colummns, rather than all 117. You will find unambiguous marginal diminishing returns by the time you reach the rightward columns. There will come a point when searches of the rightmost columns yeild no new rows. Once you have found all of the index positions of that entity, copy them into your record-keeping spreadsheet. It may be tedious for each entity, but the hope is that this MERP documentation can help us automate that.

![record all found indices](/Notebooks_and_Data/David_Dodds_Files/images/xl_2_12.JPG)

## Phase 3: MER for SAMS creation - capture datapoints from all observations of each entity
MER on all newly found index positions for each same-entity to determine which of it's datapoints are most accurate, up-to-date, and inclusive of previously hidden index positions. (Finishing this phase concludes the actual creation of the SAMS)

### 3.1) Create a folder for the query outputs.
I used Datagrip for this analysis. Datagrip allows you to download the query results into a spreadsheet, which will be helpful for reconciling features of each entity. Create a folder to house these spreadsheets.

### 3.2) Query the known rows of an entity.
Copy and paste that entity's known index positions, which you captured in your spreadsheet during phase 2, into your sql console.

![copy query over](/Notebooks_and_Data/David_Dodds_Files/images/sql_3_2.JPG)

### 3.3) Download the query.

![download known rows](/Notebooks_and_Data/David_Dodds_Files/images/sql_3_3.JPG)

### 3.4) Record available datapoints.
Capture datapoints that can coincide, as well as datapoints that change over time. The search results must reflect the recency of the database. The first screen capture is the raw download of the query of that entity. The second screenshot is that same entity's data reconciled in the recording spreadsheet (30entities.xlsx).

![record available datapoints](/Notebooks_and_Data/David_Dodds_Files/images/xl_3_4.JPG)

![reconciled attributes](/Notebooks_and_Data/David_Dodds_Files/images/xl_3_4_1.JPG)

### 3.5) Reconciling conflicting attributes.
Conflicting datapoints may exist for the same entity. For example, it is common for the feature column "additional_santions_information" to claim in seperate rows that the same entity is both "Subject to Secondary Santions" and "Not subject to secondary sanctions". In a conflicting scenario like this, the sanction status on the most recent entry (sorted by date) would be the attribute that stands as the most current and accurate datapoint for that conflictable attribute. Some attributes are inclusive rather than conflicting. For instance, multiple passports, addresses, telephone numbers, aliases: record every distinct one as a datapoint that must be returned by the in-app searches. These people are on the lamb and hide behind fake identities. Any one of them can be used to flag them at a bank or airport. It's up to your discernment to understand the meaning of each column and conclude whether it contains conflictable-type or inclusive-type datapoints.

![conflicting or inclusive](/Notebooks_and_Data/David_Dodds_Files/images/sql_3_5.JPG)

### 3.6) Repetitive datapoints: action, aka, et cetera.
Some columns contain data that is congruent to data contained in similar columns. For instance, the many aliases of a sanctioned entity could be in the 'aka' column, the 'fka' column, 'nka' column, 'entity_name' column, 'first_name' column, or 'last_name' column. The search results must reconcile redundant information scattered between such columns, but must include all unique values scattered between such columns. Know which columns contain such congruent data for MER. As a start, [ofac_columns.xlsx](https://github.com/LambdaSchool/c4ads-sanctions-explorer-ds/blob/master/Notebooks_and_Data/David_Dodds_Files/ofac_columns.xlsx) annotates which columns in the OFAC database contain nationhood data for entries of each type of entity.

## Phase 4: Using the SAMS to gauge the accuracy of current in-app searches.

Use your manually reconciled entities, which you've recorded in the SAMS excel sheet, to compare it to SanctionExplorer search results. Measure and record those results.

### 4.1) Search the entity in SanctionExplorer by their most commonly occurring name / alias.
The most common alias may not yeild a search result. It's rare, but in that case just keep hunting using other next most common aliases until a search yeilds an entity card. If the entity is not found after hunting with all aliases, then record the search accuracy for that entity as 0%. If you do find an entity card in a search result, click it to open it and evaluate.

![find in SanctionEx](/Notebooks_and_Data/David_Dodds_Files/images/SanctEx_4_1.JPG)

### 4.2) Corroborate that the entity card is the same person as the entity-in-question on the SAMS.
ELABORATE HERE

### 4.3) Reconcile datapoints between the search result and the SAMS. Count total correct vs. total datapoints.
ELABORATE HERE

### 4.4) Record the accuracy % in the SAMS
ELABORATE HERE

### 4.5) Repeat for all entities in the SAMS for a comprehensive Search Accuracy Measurement.
ELABORATE HERE

### 4.6) Use Manually Reconciled SAMS to measure the accuracy of AER scripts.
ELABORATE HERE
