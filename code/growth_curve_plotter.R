# This function plots the growth curves
# As input, it takes: strain name, file with formatted growth data, ouput pdf file
# and treshold (in hours) at which growth curves will be trimmed
growth_curves <- function(strain, input, output, trim){ 
# read files
strain_name <- strain
growth_data <- input
growth_output_file <- output
trim_at_time <- trim # measurements until [input] hours
growth_annotation <- "data/growth/formatted/plate_layout.txt"
blank_wells <- c("blank_1","blank_2","blank_3") # specify blank wells
blank_wells_ST <- c("blank_ST1","blank_ST2","blank_ST3") # specify blank wells for MRS-AC-ST
# read the file with measurements
d <- read_tsv(growth_data) %>%
  filter(time <= trim_at_time)
# calculate mean blank measurements (MRS-AC-Lac without added cells)
blank_d <- d %>%
  select(all_of(blank_wells)) %>%
  rowMeans()
# calculate mean blank measurements for ST blank (MRS-AC-ST without added cells)
blank_ST <- d %>%
  select(all_of(blank_wells_ST)) %>%
  rowMeans()
# subtract blank measurements and round OD600 values to 3 digits
d_bl <- d %>%
  mutate(across(-c(time, blank_ST1, blank_ST2, blank_ST3, ST1, ST2, ST3), ~ .x - blank_d)) %>%
  mutate(across(c(blank_ST1, blank_ST2, blank_ST3, ST1, ST2, ST3), ~ .x - blank_ST)) %>%
  mutate(across(2:last_col(), ~ round(.x, 3)))

# read the file with plate annotation
ann <- read_tsv(growth_annotation)
d_bl_long <- d_bl %>%
  gather(., well, od, -time)
# create annotated table
d_bl_long_ann <- left_join(d_bl_long, ann, by="well") %>%
  filter(carbon_source != "blank") %>%
  filter(carbon_source != "blank_ST") %>%
  mutate(across(carbon_source, factor, levels = c("No substrate",
                                                  "D-glucose (Glc)",
                                                  "D-galactose (Gal)",
                                                  "D-fructose (Fru)",
                                                  "D-mannose (Man)",
                                                  "D-xylose (Xyl)",
                                                  "L-arabinose (Ara)",
                                                  "D-ribose (Rib)",
                                                  "N-acetyl-D-glucosamine (GlcNAc)",
                                                  "N-acetyl-D-galactosamine (GalNAc)",
                                                  "N-acetyl-D-mannosamine (ManNAc)",
                                                  "N-acetylneuraminic acid (Neu5Ac)",
                                                  "D-glucuronate (GlcA)",
                                                  "D-galacturonate (GalA)",
                                                  "D-gluconate (Gco)",
                                                  "Myo-inositol (Ino)",
                                                  "D-mannitol (Mtl)",
                                                  "D-sorbitol (Stl)",
                                                  "Maltose (Mal)",
                                                  "Maltotriose (MOS)",
                                                  "Panose (IMO)",
                                                  "Isomaltotriose (IMO)",
                                                  "Melezitose (Mlz)",
                                                  "Cellobiose (BglOS)",
                                                  "Gentiobiose (BglOS)",
                                                  "Laminaritriose (BglOS)",
                                                  "Sophorose (BglOS)",
                                                  "Melibiose (Mel)",
                                                  "Raffinose (RFO)",
                                                  "Lactose (Lac)",
                                                  "Sucrose (Scr)",
                                                  "Fructooligosaccharide DP=3 (scFOS)",
                                                  "Chicory fructooligosaccharides (lcFOS)",
                                                  "Mannotriose (bMnOS)",
                                                  "Xylotriose (XOS)",
                                                  "Arabinotriose (aAOS)",
                                                  "Lacto-N-tetraose (LNT)",
                                                  "Lacto-N-neotetraose (LNnT)",
                                                  "2'-fucosyllactose (2'FL)",
                                                  "3'-sialyllactose (SHMO)",
                                                  "6'-sialyllactose (SHMO)",
                                                  "Potato soluble starch (ST)",
                                                  "Pullulan (PUL)",
                                                  "Gum arabic from acacia tree (GA)",
                                                  "Konjac glucomannan (bMAN)",
                                                  "Wheat flour arabinoxylan (AX)",
                                                  "Sugar beet arabinan (AR)",
                                                  "Tamarind xyloglucan (XGL)")))

# calculate the mean OD600_max value and set thresholds based on this value
mean_max_OD <- mean(head(sort(d_bl_long_ann$od,decreasing=TRUE), n=30))
# threshold for no growth (10% of OD600_max)
growth_limit <- 0.1 * mean_max_OD 
# threshold for weak growth (25% of OD600_max)
weak_growth_limit <- 0.25 * mean_max_OD 

# calculate mean OD and standard deviation for each carbon source and time
growth_summary <- d_bl_long_ann %>%
  group_by(carbon_source, time) %>%
  summarise(
    mean_od = mean(od),
    sd_od = sd(od),
    n = n()
  )
# calculate lower and upper confidence intervals
confidence_level <- 0.95  # set the desired confidence level (e.g., 95%)
z_value <- qnorm((1 + confidence_level) / 2)  # calculate the z-value based on the confidence level
growth_summary <- growth_summary %>%
  mutate(
    lower_ci = mean_od - z_value * (sd_od / sqrt(n)),
    upper_ci = mean_od + z_value * (sd_od / sqrt(n))
  )

# plot growth curves
filtered_summary <- growth_summary[!is.na(growth_summary$mean_od), ]
curves <- ggplot(filtered_summary, aes(x = time, y = mean_od)) +
  # add line
  geom_line() +
  # add confidence interval
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.2) +
  scale_x_continuous(limits=c(0, trim_at_time),
                     breaks=c(0, trim_at_time*0.25, trim_at_time*0.5, trim_at_time*0.75, trim_at_time)) +
  # add threshold for no growth
  geom_hline(yintercept=growth_limit , linetype="dashed", color = "red", linewidth=0.2) +
  # add threshold for weak growth
  geom_hline(yintercept=weak_growth_limit, linetype="dashed", color = "#F48326", linewidth=0.2) +
  ggtitle(strain_name) +
  xlab("Time (h)") +
  ylab("OD600") +
  facet_wrap(~ carbon_source, scales="fixed", ncol = 6) +
  theme_bw() + 
  theme(
    strip.text = element_text(size = 5) 
  )
# save pdf
ggsave(filename = growth_output_file, plot = curves, width = 210, height = 297, units = "mm", dpi = 300)
print(curves)
}