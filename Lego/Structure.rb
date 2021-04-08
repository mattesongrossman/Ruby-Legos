require_relative 'Block'

class Structure

  @@autoId = 1
  attr_accessor :id, :blocks

  def initialize
    @id = @@autoId
    @blocks = []
    incrementId
  end

#---------------------------------------------------
  def getStructure
    return self
  end

#---------------------------------------------------
  def getId
    return @id
  end

#---------------------------------------------------
  def incrementId
      @@autoId += 1
  end

#---------------------------------------------------
  def getBlocks
    return @blocks
  end
#---------------------------------------------------
  def addBlock(block)
    @blocks.push(block)
  end

#---------------------------------------------------
  def moveStructure(deltaX, deltaY)
    puts "Structure #{getId} Moving..."
    #FORMULA CHANGED TO WORK AT BLOCK LEVEL DIRECTLY SINCE THE STRUCTURE LEVEL HAS A TOUGHER TRAVERSAL
    #       puts @blocks
    # @blocks.each {|block|
    #   block.moveBlock(deltaX, deltaY)
    #  }
  end

#---------------------------------------------------
  def blockRemove(block)
    # puts @blocks.uniq!
    getBlocks.delete(block)
  end

#---------------------------------------------------

end
