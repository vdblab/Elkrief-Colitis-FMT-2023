# This main body of this script is not publicly released.  It describes the preparation of metadata which involves protected health information.  
# If you have any questions about how the resulting data objects were created, please contact watersn@mskcc.org




#Here we write out a key relating the NCBI accessions, sample names, and annonymous ids

# read.csv("Data/ncbi_accessions.csv") %>%
#   mutate(fid = gsub("[._]", "", toupper(sample_name))) %>%
#   left_join(
#     bind_rows(
#       sample_data(mpa_phy_colitis) %>% as_tibble(),
#       sample_data(mpa_phy_fmt) %>% as_tibble() %>% mutate(anonymized_id=as.character(MRN))
#     ) %>%
#       mutate(fid = gsub("[._]", "", toupper(.sample))) %>%
#       select(fid, anonymized_id)
#     )  %>% 
#   select(accession, sample_name, anonymized_id) %>%
#   distinct() %>% write.csv("Data/sample_key.csv", row.names = FALSE)
