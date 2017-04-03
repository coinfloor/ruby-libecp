require 'spec_helper'

describe LibEcp do
  let(:libecp) { described_class }

  describe '.gen_uid' do
    subject { libecp.gen_uid(1) }

    it 'generates uid as bytestring and ensures ASCII-8BIT encoding' do
      expect(subject).to eq("\x00\x00\x00\x00\x00\x00\x00\x01")
    end

    it 'ensures right encoding' do
      expect(subject.encoding).to be Encoding::ASCII_8BIT
    end
  end

  describe '.private_key' do
    let(:user_id) { 1 }
    let(:password) { 'password' }
    let(:sha224_hash) { "\xD6i\xB5\"\xC6ea\n\xB6\x99\xA1h\x97V\xA87R\"\xC4\x88/\x15\x86\xD1\x86\xB0\x83\xB0".force_encoding('ASCII-8BIT') }

    subject { libecp.private_key(libecp.gen_uid(user_id), password) }

    it 'generates private key using SHA224' do
      expect(subject).to eq(sha224_hash)
    end

    context 'when providing special characters' do
      let(:user_id) { 128 }  # user_id = 128
      let(:password) { "COPAú€rowentaú€#£ęćżźłów~!@#$%^&*()_+`-=[]{}:\";'<>?,./!\"£eqQWRTYEYUIOPLKJHGFDSAZXCVBNM#£ęćżźłów" }
      let(:sha224_hash) { "\x9C\xC7\xB56D5|\x14\f\x80;\x9AI}2>') \x10\x1C\xC3\\1\xF7\x84\xDE\x01".force_encoding('ASCII-8BIT') }

      it 'ensures proper processing' do
        expect(subject).to eq(sha224_hash)
        expect(subject.encoding).to be Encoding::ASCII_8BIT
      end
    end
  end
end
