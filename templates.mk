# ~/Documents/GitHub/makefile_analytics_project/config/make/templates.mk
############################################################################
# Project templates                                                        #
############################################################################
create-templates: src/templates/README-TEMPLATE.md src/templates/LICENSE.md \
src/templates/AUTHORS.md src/templates/CHANGELOG.md src/templates/NEWS.md \
config/cron/crontab.txt config/datasette/requirements.txt config/datasette/metadata.yaml \
config/datasette/datasette_settings.txt src/templates/header.sql config/sql_ddl/er_relationships.txt \
config/vega/vega_embed_header.viz config/vega/vega_embed_footer.viz config/vega/vega_bar_chart.vega \
config/vega/vega_line_chart.vega config/vega/vega_scatter_chart.vega

src/templates/README-TEMPLATE.md: 
	@echo "# $(PROJECT-NAME)" > $@
	@echo "## Brief Description" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo "  " >> $@
	@echo "## Project Status" >> $@
	@echo "[ ACTIVE | DEPRICATED | NOT ACTIVE ]  " >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Problem Statement" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Who is this for?" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Prerequsites" >> $@
	@echo "[ ] Lorem ipsum dolor sit amet.  " >> $@
	@echo "[ ] Consectetur adipiscing elit.  " >> $@
	@echo "[ ] Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Usage" >> $@
	@echo "1. Lorem ipsum dolor sit amet.  " >> $@
	@echo "2. Consectetur adipiscing elit.  " >> $@
	@echo "3. Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "### First time setup" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo "1. Lorem ipsum dolor sit amet  " >> $@
	@echo "2. Consectetur adipiscing elit  " >> $@
	@echo "3. Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "### Normal operation" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo "1. Lorem ipsum dolor sit amet  " >> $@
	@echo "2. Consectetur adipiscing elit  " >> $@
	@echo "3. Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Images / Screen Shots" >> $@
	@echo "[image caption](some.jpg)" >> $@
	@echo " " >> $@
	@echo "## Support" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Roadmap" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## How you can help" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "----" >> $@
	@echo " " >> $@
	@echo "### License" >> $@
	@echo "[MIT](LICENSE.md)" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

src/templates/LICENSE.md:
	@echo "# MIT License" > $@
	@echo "Copyright (c) $(shell date -u +"%Y") $(BUSINESS-CONTACT-NAME) $(BUSINESS-CONTACT-NAME)" >> $@
	@echo " " >> $@
	@echo "Permission is hereby granted, free of charge, to any person obtaining a copy" >> $@
	@echo "of this software and associated documentation files (the "Software"), to deal" >> $@
	@echo "in the Software without restriction, including without limitation the rights" >> $@
	@echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $@
	@echo "copies of the Software, and to permit persons to whom the Software is" >> $@
	@echo "furnished to do so, subject to the following conditions:" >> $@
	@echo " " >> $@
	@echo "The above copyright notice and this permission notice shall be included in all" >> $@
	@echo "copies or substantial portions of the Software." >> $@
	@echo " " >> $@
	@echo "THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $@
	@echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $@
	@echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $@
	@echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $@
	@echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $@
	@echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE" >> $@
	@echo "SOFTWARE." >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

src/templates/AUTHORS.md:
	@echo "# Authors" > $@
	@echo "| Name | Role | Email | Phone |" >> $@
	@echo "|:--|:--|:--|:--|" >> $@
	@echo "| Prospero | Lead Sorcerer | prince@milan.com | 555-444-3333 |" >> $@
	@echo "| Miranda | Prospero's daughter | princess@milan.com | 555-444-2222 |" >> $@
	@echo "| Caliban | Slave of Prospero | mooncalf@island.net | 555-867-5000 |" >> $@
	@echo "| Ariel | Spirit | spirit@island.net | 555-867-5309 |" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

src/templates/CHANGELOG.md:
	@echo "# Change Log" > $@
	@echo "All notable changes to this project will be documented in this file." >> $@
	@echo "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)," >> $@
	@echo "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)." >> $@
	@echo "" >> $@
	@echo "## [Unreleased]" >> $@
	@echo "- Lorem ipsum dolor sit amet" >> $@
	@echo "" >> $@
	@echo "## [0.0.1] - YYYY-MM-DD" >> $@
	@echo "### Added" >> $@
	@echo "- Lorem ipsum dolor sit amet" >> $@
	@echo "### Changed" >> $@
	@echo "- Lorem ipsum dolor sit amet" >> $@
	@echo "### Removed" >> $@
	@echo "- Lorem ipsum dolor sit amet" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

src/templates/NEWS.md:
	@echo "# News" > $@
	@echo "## YYYY-MM-DD" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "## YYYY-MM-DD" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "## YYYY-MM-DD" >> $@
	@echo "Lorem ipsum incididunt ut labore et dolore magna aliqua. Bibendum arcu vitae." >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/cron/crontab.txt:
	@echo "MAILTO=""" > $@
	@echo "#LOG_ROTATE - Rotate the log file every day." >> $@
	@echo "#@daily /usr/bin/make -C </path/to/project/> -f makefile log_rotate >> </path/to/project>/var/log/cron_log.txt 2>&1" >> $@
	@echo "#Execute the data pipeline every hour" >> $@
	@echo "#*/15 * * * * /usr/bin/make -C </path/to/project/> -f makefile all >> </path/to/project>/var/log/cron_log.txt 2>&1" >> $@
	@echo "#deploy/local manually as needed" >> $@
	@echo "#0 */2 * * * /usr/bin/make -C </path/to/project/> -f makefile deploy/local >> </path/to/project>/var/log/cron_log.txt 2>&1" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/datasette/requirements.txt: 
	@echo datasette==0.61.1 > $@
	@echo datasette-copyable==0.3.1 >> $@
	@echo datasette-vega==0.6.2 >> $@
	@echo datasette-yaml==0.1.1 >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/datasette/datasette_settings.txt: 
	@echo "	{" >> $@
	@echo "	    "default_page_size": 1000," >> $@
	@echo "	    "sql_time_limit_ms": 5000," >> $@
	@echo "	    "max_returned_rows": 5000," >> $@
	@echo "	    "num_sql_threads": 3," >> $@
	@echo "	    "allow_facet": true," >> $@
	@echo "	    "default_facet_size": 10," >> $@
	@echo "	    "facet_time_limit_ms": 1000," >> $@
	@echo "	    "facet_suggest_time_limit_ms": 500," >> $@
	@echo "	    "suggest_facets": true," >> $@
	@echo "	    "allow_download": true," >> $@
	@echo "	    "default_cache_ttl": 5," >> $@
	@echo "	    "default_cache_ttl_hashed": 31536000," >> $@
	@echo "	    "cache_size_kb": 0," >> $@
	@echo "	    "allow_csv_stream": true," >> $@
	@echo "	    "max_csv_mb": 0," >> $@
	@echo "	    "truncate_cells_html": 2048," >> $@
	@echo "	    "force_https_urls": false," >> $@
	@echo "	    "hash_urls": false," >> $@
	@echo "	    "template_debug": false," >> $@
	@echo "	    "base_url": "/"" >> $@
	@echo "	}	" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)
	
config/datasette/metadata.yaml: 
	@echo "title: $(PROJECT-NAME)" > $@
	@echo "about: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo "about_url: https://example.com/" >> $@
	@echo "source: Building Data Products" >> $@
	@echo "source_url: https://example.com/" >> $@
	@echo "description_html: |-" >> $@
	@echo "  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.<br>" >> $@
	@echo "  Lorem ipsum dolor sit amet, consectetur adipiscing elit." >> $@
	@echo "  <p></p>" >> $@
	@echo "  <strong>Contacts:</strong><br>" >> $@
	@echo "  Business Contact: <a href = mailto: "brian@minimumviablearchitecture.com">Brian McMillan</a><br>" >> $@
	@echo "  Technical Contact: <a href = mailto: "me@example.com">Some Person</a>" >> $@
	@echo "license: DbCL" >> $@
	@echo "license_url: https://opendatacommons.org/licenses/dbcl/1-0/" >> $@
	@echo "databases:" >> $@
	@echo "  makefile_analytics_project:" >> $@
	@echo "    tables:" >> $@
	@echo "      REF_CALENDAR_001:" >> $@
	@echo "        description: Basic date dimension table. JOIN on either the date or date_int columns." >> $@
	@echo "        source: REF_CALENDAR_001_create.sql" >> $@
	@echo "        about: Standard reference table with dates between 2020-01-01 and 2024-01-01" >> $@
	@echo "        sort: date_int" >> $@
	@echo "        columns: " >> $@
	@echo "            date: Date in YYYY-MM-DD format." >> $@
	@echo "            date_int: Date in YYYYMMDD format." >> $@
	@echo "            date_julian_day: Numeric date value used to compute the differences between dates." >> $@
	@echo "            date_end_of_year: Date at the end of the year." >> $@
	@echo "            date_end_of_week_smtwtfs: Date at the end of the week. Assumes the week starts on a Sunday and ends on a Saturday." >> $@
	@echo "            days_in_period_month: Number of days in this month." >> $@
	@echo "            days_in_period_week: Number of days in this week." >> $@
	@echo "            year: Year in YYYY format." >> $@
	@echo "            year_month: Month in YYYY-MM format." >> $@
	@echo "            year_week_of_year: Week of the year in YYYY-WW format." >> $@
	@echo "      META_TABLES_001:" >> $@
	@echo "        description: Data catalog table." >> $@
	@echo "        source: META_TABLES_001_create" >> $@
	@echo "        about: Standard reference table with metadata for each table in the database." >> $@
	@echo "        columns: " >> $@
	@echo "            table: The name of the table." >> $@
	@echo "            column: The name of the column." >> $@
	@echo "            total_rows: Total number of rows in the table." >> $@
	@echo "            num_null: Count of NULL records in the column." >> $@
	@echo "            num_blank: Count of empty records in the column." >> $@
	@echo "            num_distinct: Count of distinct records in the column." >> $@
	@echo "            most_common: JSON array of the most common values in the column." >> $@
	@echo "            least_common: JSON array of the least common values in the column." >> $@
	@echo "    queries:" >> $@
	@echo "        end_of_period_lookup:" >> $@
	@echo "          title: End of period date look-up" >> $@
	@echo "          description: Look-up query to assist in aggregating data by the end of year, month, or week date." >> $@
	@echo "          sql:  |-" >> $@
	@echo "            SELECT" >> $@
	@echo "              date," >> $@
	@echo "              date_end_of_week_smtwtfs AS date_end_of_week," >> $@
	@echo "              date_end_of_month," >> $@
	@echo "              date_end_of_year" >> $@
	@echo "            FROM" >> $@
	@echo "              REF_CALENDAR_001" >> $@
	@echo "            ORDER BY" >> $@
	@echo "              date_int ASC" >> $@
	@#sed -i -e 's/{{colon}}/:/g' $@
	@#rm -f $@-e
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

src/templates/header.sql:
	@echo "--path/to/sql/<file_name>_###_<action>.sql" > $@
	@echo "-------------------------------------------------------------------------------" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/sql_ddl/er_relationships_TEMPLATE.txt:
	@echo "<table 1> 1--1 <table 2>" > $@
	@echo "1 - Exactly one" >> $@
	@echo "? - 0 or 1" >> $@
	@echo "* - 0 or more" >> $@
	@echo "+ - 1 or more" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/vega/vega_embed_header.viz:
	@echo " <!DOCTYPE html>" > $@
	@echo "	<html>" >> $@
	@echo "	  <head>" >> $@
	@echo "	    <title>Data Discovery Reporting</title>" >> $@
	@echo "	    <meta charset="utf-8" />" >> $@
	@echo "	    <script src="https://cdn.jsdelivr.net/npm/vega@5.22.1"></script>" >> $@
	@echo "	    <script src="https://cdn.jsdelivr.net/npm/vega-lite@5.2.0"></script>" >> $@
	@echo "	    <script src="https://cdn.jsdelivr.net/npm/vega-embed@6.20.8"></script>" >> $@
	@echo " " >> $@
	@echo "	    <style media="screen">" >> $@
	@echo "	      /* Add space between Vega-Embed links  */" >> $@
	@echo "	      .vega-actions a {" >> $@
	@echo "	        margin-right: 5px;" >> $@
	@echo "	      }" >> $@
	@echo "	    </style>" >> $@
	@echo "	  </head>" >> $@
	@echo "	  <body>" >> $@
	@echo "	    <!-- Container for the visualization -->" >> $@
	@echo "	    <div id="vis"></div>" >> $@
	@echo "	    <script>" >> $@
	@echo "	      // Assign the specification to a local variable vlSpec." >> $@
	@echo "	      var vlSpec = {" >> $@
	@echo "	        $schema: 'https://vega.github.io/schema/vega-lite/v4.json'," >> $@
	@echo "	<!-- Embed Vega-Lite Definition Here -->" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/vega/vega_embed_footer.viz:
	@echo "}" > $@
	@echo "};" >> $@
	@echo " " >> $@
	@echo "// Embed the visualization in the container with id "vis"" >> $@
	@echo "vegaEmbed('#vis', vlSpec);" >> $@
	@echo "</script>" >> $@
	@echo "</body>" >> $@
	@echo "</html>" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/vega/vega_bar_chart.vega:
	@echo "  "mark": "bar"," > $@
	@echo "  "encoding": {" >> $@
	@echo "    "x": {"field": "end_of_week_ssmtwtf", "type": "temporal", "bin": false}," >> $@
	@echo "    "y": {"field": "total_sales_revenue", "type": "quantitative", "bin": false}," >> $@
	@echo "    "tooltip": {"sfield": "_tooltip_summary", "type": "ordinal"}" >> $@
	@echo "  }" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/vega/vega_line_chart.vega:
	@echo "  "mark": "line"," > $@
	@echo "  "encoding": {" >> $@
	@echo "    "x": {"field": "end_of_week_ssmtwtf", "type": "temporal", "bin": false}," >> $@
	@echo "    "y": {"field": "total_sales_revenue", "type": "quantitative", "bin": false}," >> $@
	@echo "    "tooltip": {"field": "_tooltip_summary", "type": "ordinal"}" >> $@
	@echo "  }" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/vega/vega_scatter_chart.vega:
	@echo "  "mark": "circle"," > $@
	@echo "  "encoding": {" >> $@
	@echo "    "x": {"field": "end_of_week_ssmtwtf", "type": "temporal", "bin": false}," >> $@
	@echo "    "y": {"field": "total_sales_revenue", "type": "quantitative", "bin": false}," >> $@
	@echo "    "tooltip": {"field": "_tooltip_summary", "type": "ordinal"}" >> $@
	@echo "  }" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)