#!/usr/local/bin/python
# -*- coding: utf-8 -*-
import re
import sys
import csv

lat_lng_rg = re.compile('.*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.]).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.])')

def parse_lat_lng(lat_lng_string):
    """
    Turns the Location column into (lat, lng) floats
    May look like this "(29.98645605, -90.06910049)"
    May have degree symbol "(29.98645605°,-90.06910049°)"
    """
    m = lat_lng_rg.search(lat_lng_string)

    if m:
        return (float(m.group(1)), float(m.group(2)))
    else:
        return (None, None)

def annotate_csv(in_file, out_file):
    """
    Goes row by row through the in_file and
    writes out the row to the out_file with
    the geom column updated with a WKT point
    """

    reader = csv.reader(in_file)
    writer = csv.writer(out_file)

    # Write headers first, add new geometry column
    headers = reader.next()
    writer.writerow(headers)

    for row in reader:
        # WGS84 point, "Location" column, is 2nd to last element
        lat, lng = parse_lat_lng(row[-2])
        if not (-90 < lat < 90 and -180 < lng < 180):
            print "invalid lat/lng coordinates: %s,%s for row id %s" % (lat,lng,row[0])
        else:
            wkt_point = "POINT (%s %s)" % (lng, lat)
            # geom column is the last column
            row[-1] = wkt_point
        writer.writerow(row)

if __name__ == '__main__':

    if len(sys.argv) < 2:
        print "Provide an input and an output csv file"
        print "Example: python location_to_geom.py 311-calls.csv 311-calls-geom.csv"
        sys.exit()

    in_file_path = sys.argv[1]
    out_file_path = sys.argv[2]

    with open(in_file_path, 'rb') as in_file:
        with open(out_file_path, 'wb') as out_file:
            annotate_csv(in_file, out_file)
