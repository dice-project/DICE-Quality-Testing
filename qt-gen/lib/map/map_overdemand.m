function phi = map_overdemand(MAP)

t = map_mean(MAP);
EX = expm(MAP{1}*t);

phi = map_pie(MAP) * EX * map_embedded(MAP) * EX * e(length(MAP{1})) / (map_pie(MAP) * EX * e(length(MAP{1})));

end