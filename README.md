# COVID-vaccination

The primary aim of this study is to provide a recommendation for the next three population groups to target vaccine prioritization in England.

- The rationale for the recommendations will be approached by coupling hospitalization and mortality driven data modelling using R, in support of understanding disease propagation and burden.

Data for the purpose of this analysis was extracted from the ONS, NHS England and CHIME tool PHE website through web scraping. Data pertaining to the relevant variables and defined time period were filtered and loaded into specific data frames. 

Hospitalization rates according to age group and region, mortality rates according to age group, region and deprivation decile, positive cases by regions and vaccination uptake by residents and staff and older adult care homes were plotted using bar charts and line plots. Each graph included the time period specific to that data, the trends for each group and the source of the data. These graphs were used to assess the disease burden and vaccination uptake in various sub-populations, and recommend the three groups to be prioritized for the next phase of the vaccination campaign.

The graph plotting hospitalization rates stratified by age group and regions shows that the rates have been declining overall since vaccination rollout earlier this year (Figure 1). Despite the overall decline, hospital activity still continues to be highest among those in older age groups. Among the regions, North West and West Midlands are seeing a rise in hospital activity since May this year.

<img src="/imgs/Fig-1.png" alt="Figure 1"/>

Figure 1: Hospitalization rates in England, by age group and regions.



<img src="/imgs/Fig-2.png" alt="Figure 2"/> 

Figure 2: Percent population testing positive in England, by regions.



To further understand the rising hospital activity within certain regions as seen in Figure 1, the percentage of positive cases were plotted in a graph as well (Figure 2). It can be observed that there is a steep rise in cases in the North West region which explains the rise in hospitalizations in the region as well. Similarly, West Midlands has also seen a rise in cases, although not as stark as seen in the North West region.

<img src="/imgs/Fig-3.png" alt="Figure 3"/> 

Figure 3: Mortality rates in England, by age group and regions.

Compared to hospitalizations, mortality has reduced significantly across all age groups including among older individuals (Figure 3). Similar trend was observed across all regions, with North West and London seeing a marginal increase in rates in June. In addition, mortality rates by deprivation decile shows a similar declining trend and a strong association between increasing deprivation status and higher mortality rates, with those most deprived having consistently higher mortality rates compared to other groups (Figure 4).

<img src="/imgs/Fig-4.png" alt="Figure 4"/> 

Figure 4: Mortality rates in England, by deprivation decile.

Since overall hospital activity and mortality is higher among the older age groups, and the JCVI identified residents in care homes for older adults and their carers as the first group for receiving the vaccine, vaccination rates among this group by regions, were plotted in a graph (Figure 5). It can be observed that less than 75% of the staff in care homes across all regions have received their second dose of vaccination.

<img src="/imgs/Fig-5.png" alt="Figure 5"/>

Figure 5: Percent residents and staff vaccinated with both doses in care homes across England.

