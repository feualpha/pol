RSpec.describe Pol do
  it "has a version number" do
    expect(Pol::VERSION).not_to be nil
  end

  describe '#initialize' do
    it { expect{ Pol.new }.to raise_error(Pol::CreateBlockNotSupplayed)}
    it { expect{ Pol.new{ Object.new } }.not_to raise_error}
  end

  describe '#with_pool' do
    let(:pooled_obj) { double('pooled_object') }
    let(:pooled_block) { double('pooled_block', new: pooled_obj) }
    let(:queue) { Queue.new }

    before do
      allow_any_instance_of(Pol).to receive(:queue).and_return(queue)
    end

    subject { Pol.new { pooled_block.new } }

    it 'yield with object crated from create block' do
      expect(queue).to be_empty

      subject.with_pool do |pooled_object|
        expect(pooled_object).to eq (pooled_obj)
      end

      expect(queue).not_to be_empty
    end

    context 'pool not empty' do
      let(:queue) do
        q = Queue.new
        q << pooled_obj
        q
      end
      
      it 'not yield create block' do
        expect(subject).not_to receive(:create_block)
        subject.with_pool
      end
    end
  end
end
