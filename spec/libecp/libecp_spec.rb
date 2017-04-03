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

    let(:data) { libecp.gen_uid(user_id) + password.force_encoding('ASCII-8BIT') }
    let(:hash) { OpenSSL::Digest.digest('SHA224', data) }

    subject { libecp.private_key(libecp.gen_uid(user_id), password) }

    it 'generates private key using SHA224' do
      expect(subject).to eq(hash)
    end

    context 'when providing special characters' do
      let(:user_id) { 128 }  # user_id = 128
      let(:password) { "COPAú€rowentaú€#£ęćżźłów~!@#$%^&*()_+`-=[]{}:\";'<>?,./!\"£eqQWRTYEYUIOPLKJHGFDSAZXCVBNM#£ęćżźłów" }

      it 'ensures proper processing' do
        expect(subject).to eq(hash)
        expect(subject.encoding).to be Encoding::ASCII_8BIT
      end
    end
  end
end