#Sort pictures and videos by file creation dates into different folders
#DM 08/2017

require 'fileutils'
require 'exifr/jpeg'

#Creates "temp" folder in "Képek"
Dir.chdir("D:\Képek")
unless Dir.exist?("temp")
    Dir.mkdir("temp")
end

#The target folder where the pics will be sorted
Dir.chdir("D:\Képek")
target_dir=Dir.pwd


#Setting the working dir to "temp"
Dir.chdir("D:\Képek\temp")
working_dir=Dir.pwd
contents = Dir.entries(working_dir).count-2
count_moved=0


#Munkamappában megkeresi az összes fájlt, mappákat létrehozza
#év / hónap / nap alapján, áthelyezi a megfelelő helyre a képeket
# a létrehozás dátuma alapján
Dir.glob("*"){|pic|

	#If the picture is JPEG and contains exif information use date_time_original,
	#since it is more accurate
	if pic.end_with?('jpg','jpeg','JPG','JPEG')
		if EXIFR::JPEG.new(pic).exif?
			dates = EXIFR::JPEG.new(pic).date_time.to_s
		else
			dates = File.stat(pic).mtime.to_s
		end
	else
		dates = File.stat(pic).mtime.to_s
	end

    #Év / hónap / nap kinyerése változókba a mappákhoz
    year = dates.byteslice(0,4)
    month = dates.byteslice(5,2)
    day = year + '_' + month + '_' + dates.byteslice(8,2)

    #Mappák elkészítése a fájlnevek alapján
    unless Dir.exist?(File.join(target_dir,year))
        Dir.chdir(File.join(target_dir))
        Dir.mkdir(year)
    end

    unless Dir.exist?(File.join(target_dir,year,month))
        Dir.chdir(File.join(target_dir,year))
        Dir.mkdir(month)
    end

    unless Dir.exist?(File.join(target_dir,year,month,day))
        Dir.chdir(File.join(target_dir,year,month))
        Dir.mkdir(day)
    end
    Dir.chdir(working_dir)


    #putting the pics to the folders
    FileUtils.mv(File.join(working_dir,pic),File.join(target_dir,year,month,day), :force => true)
    count_moved += 1
    puts pic+" moved"

    #Ha ugyanannyit helyezett át, mint ahány fájl volt a temp mappában
    if count_moved == contents
        puts " No data lost"
        puts "  #{count_moved} files were moved"
    end
}
