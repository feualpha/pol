require "pol/version"
# simple yet complicated object pooling
# can be unbounded or not
# can be lazy initalization or not
#
class Pol
  attr_accessor :queue
  attr_accessor :clear_block
  attr_accessor :create_block
  protected :queue

  class Error < StandardError; end
  class CreateBlockNotSupplayed < Error
    def initialize
      super('create block not supplayed')
    end
  end

  def initialize(&block)
    raise CreateBlockNotSupplayed unless block
    self.queue = create_queue
    self.create_block = block
  end

  def with_pool
    begin
      pooled_obj =  pick_from_pool
      yield(pooled_obj) if block_given?
    ensure
      put_to_pool(pooled_obj)
    end
  end

  def set_clear_block(&block)
    self.clear_block = block
  end

  def clear_pool
    if self.clear_block.nil?
      self.queue.clear
      true
    else
      cleared_queue = self.queue
      self.queue = create_queue

      while !cleared_queue.empty?
        cleared_obj = cleared_queue.pop(true)
        self.clear_block.call(cleared_obj)
      end
      true
    end
  end

  private

  def create_queue
    Queue.new
  end

  def pick_from_pool
    begin
      self.queue.pop(true)
    rescue ThreadError
      create_block.call
    end
  end

  def put_to_pool(obj)
    self.queue.push(obj)
  end
end
