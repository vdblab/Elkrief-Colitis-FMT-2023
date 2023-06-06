# This main body of this script is not publicly released.  It describes the preparation of metadata which involves protected health information.  
# If you have any questions about how the resulting data objects were created, please contact watersn@mskcc.org




#Here we write out a key relating the NCBI accessions, sample names, and annonymous ids

read.csv("Data/ncbi_accessions.csv") %>%
  bind_rows(data.frame(accession=c("-", "-"), sample_name=c("480", "482"))) %>% 
  mutate(fid = gsub("[._]", "", toupper(sample_name))) %>%
  left_join(
    bind_rows(
      sample_data(mpa_phy_colitis) %>% as_tibble() %>%mutate(grp = case),
      sample_data(mpa_phy_fmt) %>% as_tibble() %>% mutate(anonymized_id=as.character(MRN), grp = "FMT")
    ) %>%
      mutate(fid = gsub("[._]", "", toupper(.sample))) %>%
      select(fid, anonymized_id, Comments,  grp, rel_date_colitis, dfmt1, dfmt2)
    )  %>%
  select(accession, sample_name, anonymized_id, Comments, grp, rel_date_colitis, dfmt1, dfmt2) %>%
  mutate(dfmt1 = as.character(dfmt1), dfmt2=as.character(dfmt2)) %>% 
  group_by(sample_name) %>%
  arrange(desc(rel_date_colitis)) %>% 
  fill(rel_date_colitis) %>% 
  arrange(desc(dfmt1)) %>% 
  fill(dfmt1) %>% 
  arrange(desc(dfmt2)) %>% 
  fill(dfmt2) %>% 
  arrange(desc(Comments)) %>% 
  fill(Comments) %>% 
  mutate(`Included in Elkrief et al` = !sample_name %in% c(473, 480, 482, 499)) %>% 
  mutate(dummy="Group") %>% 
  rename("Alternative ID"=Comments,
         "Days relative to symptom onset"=rel_date_colitis,
         "Days relative to first fmt" = dfmt1,
  "Days relative to second fmt" = dfmt2 ) %>% 
  #  rename("Day relative to FMT(s)" =drfmts) %>% 
  pivot_wider(names_from = dummy, values_from = grp, values_fn = function(x){paste(x, collapse=",")}) %>% 
  distinct() %>% 
  arrange(Group) %>% 
  write.csv("Data/sample_key.csv", row.names = FALSE, na = "-") 
