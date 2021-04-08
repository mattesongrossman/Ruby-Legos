module Test

  def stackTest # Creates 1 structure with 3 blocks stacked on top of each other
    createStructure(2, 2, 1, "B", "East", "0,0") #Test Block
    createBlock(2,2,2,"Y", "East", "0,0", 1, 1, []) #Test Block
    createBlock(2,2,3,"R", "East", "0,0", 2, 1, []) #Test Block

    # puts @structures
    puts "STACK TEST FUNCTION DETAILS:"
    puts "All Blocks List:"
    puts @allBlocks

    getBaseplate.structures.each do |structure|
      puts "Structure #{structure.getId.to_s}:"
      puts structure
      puts "Structure #{structure.getId.to_s} Blocks:" #String Interpolation
      structure.blocks.each do |block|
        puts block
      end
    end
  end


  def deleteTest # Deletes 2nd block which in turn deletes 3rd block
    createStructure(2, 2, 1, "B", "East", "0,0") #Test Block
    createBlock(2,2,2,"Y", "East", "0,0", 1, 1, []) #Test Block
    createBlock(2,2,3,"R", "East", "0,0", 2, 1, []) #Test Block

    deleteBlock(2)
    # puts @structures
    puts "DELETE TEST FUNCTION DETAILS:"
    puts "All Blocks List:"
    puts @allBlocks

    getBaseplate.structures.each do |structure|
      puts "Structure #{structure.getId.to_s}:"
      puts structure
      puts "Structure #{structure.getId.to_s} Blocks:" #String Interpolation
      structure.blocks.each do |block|
        puts block
      end
    end
  end


  def threeStructuresTest #Creates 3 structures in different places on the board
    #Structure 1
    createStructure(2,2,1, "B", "East", "0,0") #Test Block
    createBlock(2,4,1,"Y", "South", "0,2", 0, 1, []) #Test Block
    createBlock(2,8,2,"R", "East", "1,1", 2, 1, []) #Test Block
    createBlock(2,8,1,"R", "South", "14,1", 0, 1, []) #Test Block
    createBlock(1,4,2,"G", "East", "14,1", 4, 1, []) #Test Block
    #Structure 2
    createStructure(2,2,1, "B", "East", "9,8") #Test Block
    createBlock(1,4,1,"Y", "East", "10,10", 0, 2, []) #Test Block
    createBlock(2,2,1,"R", "East", "11,11", 0, 2, []) #Test Block
    createBlock(2,2,2,"G", "East", "11,11", 7, 2, []) #Test Block
    createBlock(2,8,1,"G", "East", "11,17", 0, 2, []) #Test Block
    #Structure 3
    createStructure(2,2,1, "B", "East", "20,20") #Test Block
    createBlock(2,2,2,"Y", "East", "21,20", 10, 3, []) #Test Block
    createBlock(2,8,3,"R", "East", "22,21", 11, 3, []) #Test Block
    createBlock(1,4,1,"R", "South", "20,16", 0, 3, []) #Test Block
    createBlock(2,2,1,"G", "South", "20,22", 0, 3, []) #Test Block


    # puts @structures
    puts "3 STRUCTURE TEST FUNCTION DETAILS:"
    puts "All Blocks List:"
    puts @allBlocks

    getBaseplate.structures.each do |structure|
      puts "Structure #{structure.getId.to_s}:" #String Interpolation
      puts structure
      puts "Structure #{structure.getId.to_s} Blocks:" #String Interpolation
      structure.blocks.each do |block|
        puts block
      end
    end
  end

end
