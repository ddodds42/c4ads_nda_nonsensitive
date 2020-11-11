# Automating Entity Reconciliation (AER)

Welcome to the belly of the beast.

## These 5 steps are a checklist for the trajectory of where AER needs to go for SanctionEx:
### 1] Automate the [Manual Entity Reconciliation Process](https://github.com/LambdaSchool/c4ads-sanctions-explorer-ds/blob/master/Notebooks_and_Data/David_Dodds_Files/Manual_Entity_Resolution.md) (MERP)
Write a script that performs the MERP programatically. The output of this script should replicate the current OFAC SAMS that was created with MERP for a 30 entity subsample, as well as automating testing of the 30 OFAC search results.

### 2] Test search results from EU / UN with 30 entities
Use the AER script to create a 30 entity SAMS for both the UN and EU datasets, and run a search result accuracy test on both. MERP should also be performed on each batch of 30 entities to check the accuracy of the AER scropt when applied to EU and UN data.

### 3] Use more than 30 reconciled entities to test OFAC / EU / UN
Once confident in the accuracy of the AER script, use it to create a 100+ entity SAMS for each of the OFAC, EU, and UN datasets. Use the expanded SAMS to perform another round of search result accuracy tests on the entitiies from each dataset. It is also worth performing MERP one last time on all 300 entities from the expanded SAMS, to tweak the AER script (make sure it's still producing 100% accurate entity reconciliation) before performing AER on the entire dataset.

### 4] Bake AER into the dataset (including reconciliing entities between OFAC / EU / UN)
Use the AER script to reconcile all entities in all 3 data sets. Entities in OFAC may exist in fragments in EU and UN as well. Use AER to unite all entities from all 3 datasets under one primary key per entity. Each single entity primary key should hold under its DB entry all previously fragmented datapoints for that entity.

### 5] Bake AER into future scrapes / imports to the dataset
New updates to the sanctions statuses will inevitably flow in from web scrapers (in the case of OFAC and POE) or new csv's (in the case of EU and UN). Use AER to reconcile all entities in novel data before it enters the database. Also make sure AER connects novel entity data to entities that previously existed in the database, if applicable, especially when new aliases emerge for the same old entities.
