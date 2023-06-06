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
      select(fid, anonymized_id, grp)
    )  %>%
  select(accession, sample_name, anonymized_id, grp) %>%
  mutate(`Included in Elkrief et al` = !sample_name %in% c(473, 480, 482, 499)) %>% 
  mutate(dummy="Group") %>% 
  pivot_wider(names_from = dummy, values_from = grp, values_fn = function(x){paste(x, collapse=",")}) %>% 
  distinct() %>% write.csv("Data/sample_key.csv", row.names = FALSE)
