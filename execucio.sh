#!/bin/bash

echo "Execucio iniciada"

config_file="Settings_simulacio.txt"
absolut_path="/home/wrf-chem/Desktop/FARSITE4/CASE_Jonquera"

echo "Definicio fitxers"

end_day=("24")
weather=("$absolut_path/Input/GIS_themes/Temp_min.wtr" "$absolut_path/Input/GIS_themes/Temp_mitjana.wtr" "$absolut_path/Input/GIS_themes/Temp_sup.wtr")

winds=("$absolut_path/Input/GIS_themes/Jonquera2_45_6_30m.atm" "$absolut_path/Input/GIS_themes/Jonquera2_45_21_30m.atm" "$absolut_path/Input/GIS_themes/Jonquera2_45_33_30m.atm")

output_absolut='/home/wrf-chem/Desktop/FARSITE4/CASE_Jonquera/Output'


function update_and_run {
  local weather_file=$1
  local wind_file=$2
  local end_day=$3
  local output_base=$4

  echo "Actualizando configuración para:"
  echo "Weather file: $weather_file"
  echo "Wind file: $wind_file"
  echo "End day: $end_day"
  echo "Output base: $output_base"

  # Modificar el archivo usando sed
  sed -i "s|^weatherFile0=.*|weatherFile0=$weather_file|" "$config_file"
  sed -i "s|^windFile0=.*|windFile0=$wind_file|" "$config_file"
  sed -i "s|^EndDay=.*|EndDay=$end_day|" "$config_file"
  sed -i "s|^RasterFileName=.*|RasterFileName=${output_base}/jonquera|" "$config_file"
  sed -i "s|^VectorFileName=.*|VectorFileName=${output_base}/jonquera.VCT|" "$config_file"
  sed -i "s|^shapefile=.*|shapefile=${output_base}/jonquera.shp|" "$config_file"
  mkdir -p ${output_base}
  # Ejecutar FARSITE
  echo "Ejecutando FARSITE con configuración:"
  ./farsite4P -i "$config_file" -f 4
}

for temp in "${weather[@]}"; do
  temp_name=$(basename "$temp" .wtr)
  for wind in "${winds[@]}"; do
    wind_name=$(basename "$wind" .atm)
    for days in "${end_day[@]}"; do
      output_path="${output_absolut}/${days}/${temp_name}${wind_name}"

      echo "update settings"
      update_and_run "$temp" "$wind" "$days" "$output_path"
    done
  done
done
