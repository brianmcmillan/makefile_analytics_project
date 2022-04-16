# ~/Documents/GitHub/makefile_analytics_project/config/make/metrics.mk
############################################################################
# Create standard load files                                               #
############################################################################
build/load/metric/metric_sample_001.csv: 
	@echo provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

############################################################################
# Collect Metrics                                                          #
# Append the record_count metric to the metric_sample csv file.            #
# provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value#
############################################################################
# calculate-metrics: test-metric_sample_001.csv record_count-REF_CALENDAR_001.csv

# record_count-REF_CALENDAR_001.csv: TABLENAME=REF_CALENDAR_001
# record_count-REF_CALENDAR_001.csv: metric_sample_001.csv
# 	$(metric-record_count)

# field_count_check-metric_sample_001.csv: EXPECTED=6
# field_count_check-metric_sample_001.csv: metric_sample_001.csv
# 	$(csv_field_count_check)

# number_check-metric_sample_001.csv: COLUMN=6
# number_check-metric_sample_001.csv: metric_sample_001.csv
# 	$(csv_number_check)

# regex_check-metric_sample_001.csv-C3: COLUMN=3
# regex_check-metric_sample_001.csv-C3: REGEX=^[[:space:]\"a-zA-Z0-9\/,.:_-]+$$
# regex_check-metric_sample_001.csv-C3: metric_sample_001.csv
# 	$(csv_regex_check)