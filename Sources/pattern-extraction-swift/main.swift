let pe = PatternExtractor()

pe.applyToOne("swift_files/optional.swift", debug: true)
pe.applyToAll("swift_files/files/", "./out_data.json", "./all_keys.txt")


// pe.applyToAll("/media/gibran/Extreme%20SSD/Pattern_files/files/", "./out_data.json", "./all_keys.txt")
// pe.applyToAll("/media/gibran/Extreme%20SSD/Pattern_files/files20_1/", "./out_data_1.json", "./all_keys_1.txt")
// pe.applyToAll("/media/gibran/Extreme%20SSD/Pattern_files/files20_5/", "./out_data_5.json", "./all_keys_5.txt")
