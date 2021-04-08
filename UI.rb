require_relative 'XML'

module UI
#---------------------------------------------------
    def menu

      puts
      puts "Game Menu:"
      print "Add Block/Structure = 1, Move Structure = 2, Delete Block = 3, Save = 4: "
      choice = gets.chomp
      case choice
      when "1"
        creation
      when "2"
        move
      when "3"
        delete
      when "4"
        save
      else
        puts "Invalid Response, Re-do"
        menu
      end

    end
#---------------------------------------------------
    def creation

      makeBlock = true
      uplinks = []
      downlinks = []

      while makeBlock
        puts "Add New Structure? (Y or N)"
        structure = gets.chomp
            if structure != "Y"
              puts "Enter Structure ID that you are attaching the block to: "
              attachToID = gets.chomp.to_i
              puts "If attaching to a specific block, enter block ID (Enter No if not) "
              attachToBlockID = gets.chomp
            else
              attachToID = "placeholder"
            end
        puts "Which Size Block?(2x2, 1x4, 2x4, 2x8)" # (1: 2x2, 2: 1x4, 3: 2x4, 4:2x8)
        type = gets.chomp
        length = type[0]
        width = type[2]
        puts "What Color(R,G,B,Y)"
        color = gets.chomp
        puts "Orientation (South or East)"
        orientation = gets.chomp
        puts "Location (e.g 0,0 / 5,5)"
        location = gets.chomp

        # In Baseplate, Line 44
        isNewStructure(structure, length, width, level, color, orientation, location, attachToBlockID, attachToID, uplinks, downlinks)

        puts "Add Another Block? (Y or N)"
        nextBlock = gets.chomp
        if nextBlock != "Y"
          makeBlock = false
          menu
        end
      end

    end

#---------------------------------------------------
    def move

        puts "Enter Structure ID that you would like to move"
        structureId = gets.chomp.to_i
        puts "How many spaces horizontally would you like to move?(-5 is 5 left)"
        deltaX = gets.chomp
        puts "How many spaces vertically would you like to move? (-5 is 5 up)"
        deltaY = gets.chomp

        baseplate = getBaseplate
        baseplate.moveStructure(structureId, deltaX, deltaY)
        menu

    end

#---------------------------------------------------
    def delete
      puts "Enter Block ID that you would like to delete"
      blockId = gets.chomp.to_i
      deleteBlock(blockId)
      menu
    end

#---------------------------------------------------
    def save
      baseplate = getBaseplate
      traverseBaseplateForXML(baseplate)
    end

end
