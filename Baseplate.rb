require_relative 'Structure'
require_relative 'Block'
require_relative 'Test'
require_relative 'UI'

class Baseplate  < Block
  include UI
  include Test
  attr_accessor :type, :id, :pegMatrix, :structures, :allBlocks, :color, :level, :width, :length, :height

#-----------CONSTRUCTOR-----------------------------
  def initialize
  super(length, width, level, color)
  @type = "BasePlate"
  @color = "Red"
  @length = 24
  @width = 24
  @level = 0
  @height = 0
  @structures = []
  @allBlocks = []
  createGameBoard
  # stackTest #See Tests File for details
  # deleteTest #See Tests File for details
  threeStructuresTest #See Tests File for details
  menu # INCLUDED FROM UI
  printBoard
  end

#---------------------------------------------------
  def getBaseplate
    return self
  end

#---------------------------------------------------
  def getStructures
    return @structures
  end

#---------------------------------------------------
  def getAllBlocks
    return @allBlocks
  end

#---------------------------------------------------
  def findStructureByID(id)
    getStructures.each {|structure|
      if structure.getId == id.to_i
        return structure
      end }
  end

#---------------------------------------------------
  def findBlockByID(id)
    getAllBlocks.each {|block|
      if block.getId == id.to_i
        # puts block
        return block
      end }
  end
#---------------------------------------------------
  def findBlockByIndex(id)
    index = 0
    getAllBlocks.each {|block|
      if block.getId == id.to_i
        return index
      else
        index += 1
      end }
  end

#---------------------------------------------------
  def getPegMatrix
    return @pegMatrix
  end

#---------------------------------------------------
  def createGameBoard
    @pegMatrix = Array.new(@length) { Array.new(@width) }
    getPegMatrix.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        getPegMatrix[row_idx][col_idx] = '-'
      end
    end
  end

#---------------------------------------------------
  def isNewStructure(structure, length, width, level, color, orientation, fromPoint, attachToBlockID, attachToID, uplinks, downlinks)

    if structure != "Y"
      if attachToBlockID == "No"
      #Find up and down links
      createBlock(length, width, 1, color, orientation, fromPoint, attachToBlockID, attachToID, getBaseplate)
      else
      adjlevel = findBlockByID(attachToBlockID.to_i).getlevel + 1
      #Find up and down links
      createBlock(length, width, adjlevel, color, orientation, fromPoint, attachToBlockID, attachToID, downlinks)
      end
    else
      createStructure(length, width, 1, color, orientation, fromPoint)
    end

  end

#---------------------------------------------------
    def createStructure(length, width, level, color, orientation, fromPoint)
      attachToBlockID = 0
      uplinks = []
      downlinks = [getBaseplate]
      createStructure = Structure.new
      getStructures.push(createStructure)
      # puts @structures
      createBlock(length, width, level, color, orientation, fromPoint, attachToBlockID, createStructure.getId, downlinks)

    end

#---------------------------------------------------
    def createBlock(length, width, level, color, orientation, fromPoint, attachToBlockID, attachToID, downlinks)
      if level == 1
         addBlock = AttachedBlock.new(length, width, level, color, orientation, fromPoint, attachToBlockID, attachToID, [getBaseplate])
      else
         addBlock = AttachedBlock.new(length, width, level, color, orientation, fromPoint, attachToBlockID, attachToID, downlinks)
      end
      structureFind = findStructureByID(attachToID)
      if addBlock.getlevel == 1 # Only add blocks attached to baseplate to structure block list, all others are recorded in uplinks/downlinks
          structureFind.addBlock(addBlock)
          # puts addBlock
      end
      # addBlockToBoard(addBlock) # Method will need to change to more accurately show blocks
      getAllBlocks.push(addBlock)
      findAndSetUpAndDownLinks(addBlock)
      # regenerateStructureList

    end

#---------------------------------------------------
    def findAndSetUpAndDownLinks(newBlock)
        getAllBlocks.each do |block|
          intersectX = []
          intersectY = []
          intersectX = newBlock.toPoint["rangeX"] & block.toPoint["rangeX"]
          intersectY = newBlock.toPoint["rangeY"] & block.toPoint["rangeY"]
          if newBlock.getlevel - block.getlevel == 1 && newBlock.getId != block.getId && newBlock.getAttachToID == block.getAttachToID
            if intersectX.size != 0 && intersectY.size != 0
              # UNCOMMENT TO SEE WHERE UPLINKS/DOWNLINKS FORM
              # puts "id: #{newBlock.id} newBlock point: #{newBlock.fromPoint} downlink below"
              # puts "id: #{block.id} Block point: #{block.fromPoint} uplink above"
              newBlock.getDownlinks.push(block)
              block.getUplinks.push(newBlock)
            end
          end

        end
      regenerateStructureList
    end

#---------------------------------------------------
    def moveStructure(structureId, deltaX, deltaY)

      # CHANGED TO REFLECT EASIER APPROACH
      structMove = findStructureByID(structureId)
      structMove.moveStructure(deltaX.to_i, deltaY.to_i)

      getAllBlocks.each do |block| # EASIER TO CHANGE AT ALL BLOCKS LEVEL
        if block.getAttachToID == structureId
            block.moveBlock(deltaX, deltaY)
        end
      end
      regenerateStructureList
    end
#---------------------------------------------------
    def deleteBlock(id)
      block = findBlockByID(id)
      findStructureByID(block.getAttachToID).blockRemove(block) #This will remove blocks at higher levels
      block.disconnect(block)
      regenerateStructureList
    end

#---------------------------------------------------
    def regenerateStructureList
      getAllBlocks.clear
      getBaseplate.structures.each do |structure|
        # puts structure
        addToAllBlocks(structure)
      end
      getAllBlocks.uniq!
      getAllBlocks.sort! { |a, b|  a.getId <=> b.getId } # Sorts array by ID
      # getAllBlocks.each { |chr| puts chr.getId } #Test
      generateBlocksToBoard
    end
#---------------------------------------------------
    def addToAllBlocks(array)
      # puts array.class.name
      if array.class.name == "Structure"
        array.blocks.each do |block|
          getAllBlocks.push(block)
           if block.getUplinks.size > 0
             addToAllBlocks(block.getUplinks)
           end
        end
      else
        array.each do |block|
          getAllBlocks.push(block)
           if block.getUplinks.size > 0
             addToAllBlocks(block.getUplinks)
           end
        end
      end

    end

#---------------------------------------------------
    def generateBlocksToBoard
      begin
        getPegMatrix.each_with_index do |row, row_idx|
          row.each_with_index do |col, col_idx|
            getPegMatrix[row_idx][col_idx] = '-'
          end
        end
        # puts block.toPoint
        getAllBlocks.each do |block|
          # puts block.toPoint
          block.toPoint["rangeX"].each do |y|
            block.toPoint["rangeY"].each do |x|
              getPegMatrix[x][y] = block.color
            end
          end
        end
      rescue
        puts
        puts "WARNING: Possible out of range on block move or placement"
      end
        # printBoard
    end

#---------------------------------------------------
    def printUplinksAndDownlinks
      getAllBlocks.each do |block|
        puts "Block #{block.getId} Downlinks: "
        puts block.getDownlinks
        puts "Block #{block.getId} Uplinks: "
        puts block.getUplinks
      end
    end

#---------------------------------------------------
    def printBoard

      puts ""
      rowNumb = 0
      colNumb = 0

      # ADD COLUMN NUMBERS
      while colNumb < 24 do
        if colNumb == 0
          print "   "
          print colNumb
        else
          print "  "
          print colNumb
        end
        colNumb += 1
      end

      # LOOP
      getPegMatrix.each_with_index do |row, row_idx|
         # ADD ROW NUMBERS
         puts ""
         print rowNumb
         if rowNumb < 10
           print "  "
         else
           print " "
         end
        rowNumb += 1

        row.each_with_index do |col, col_idx|
          print getPegMatrix[row_idx][col_idx] #PRINT
          # SPACING
          if col_idx < 10
            print "  "
          else
            print "   "
          end

        end #END OF 2nd loop
      end #END OF 1st loop
      puts ""

      #OUTPUTS ALL BLOCKS AND STRUCTURES INCLUDING WHICH BLOCKS ARE IN THE STRUCTURE
      # puts "All Blocks List:"
      # puts @allBlocks
      #
      # getBaseplate.structures.each do |structure|
      #   puts "Structure #{structure.getId.to_s}:"
      #   puts structure
      #   puts "Structure #{structure.getId.to_s} Blocks:" #String Interpolation
      #   structure.blocks.each do |block|
      #     puts block
      #   end
      # end

      # printUplinksAndDownlinks

    end
#---------------------------------------------------
  end
