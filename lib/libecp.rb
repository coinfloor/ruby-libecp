# encoding: UTF-8
require "base64"
require "ffi"
require "openssl"
require "securerandom"

module LibEcp
  extend FFI::Library

  # Load the C++ shared library libecp.so
  ffi_lib Gem.find_files("libecp.so")[0]

  # Attached methods from the libecp C++ library
  attach_function :ecp_pubkey_u8, [:pointer, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :size_t], :void
  attach_function :ecp_sign_u8, [:pointer, :pointer, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :size_t], :void
  attach_function :ecp_verify_u8, [:buffer_in, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :buffer_in, :size_t], :bool

  # Get the byte string of a, G, p and n
  p = "\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFE\xFF\xFF\xE5m".force_encoding("ASCII-8BIT")
  a = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".force_encoding("ASCII-8BIT")
  g = "\x00\xA1E[3M\xF0\x99\xDF0\xFC(\xA1i\xA4g\xE9\xE4pu\xA9\x0F~e\x0E\xB6\xB7\xA4\\\x00~\b\x9F\xED\x7F\xBA4B\x82\xCA\xFB\xD6\xF7\xE3\x19\xF7\xC0\xB0\xBDY\xE2\xCAK\xDBUma\xA5\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01".force_encoding("ASCII-8BIT")
  n = "\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xDC\xE8\xD2\xECa\x84\xCA\xF0\xA9qv\x9F\xB1\xF7".force_encoding("ASCII-8BIT")

  # Create the buffers
  @@pb = FFI::MemoryPointer.new(:char, 29)
  @@pb.put_bytes(0, p)
  @@ab = FFI::MemoryPointer.new(:char, 29)
  @@ab.put_bytes(0, a)
  @@gb = FFI::MemoryPointer.new(:char, 29*3)
  @@gb.put_bytes(0, g)
  @@nb = FFI::MemoryPointer.new(:char, 29)
  @@nb.put_bytes(0, n)

  def self.gen_nonce
    SecureRandom.random_bytes(16)
  end

  # Generates user id as a bytestring
  def self.gen_uid(user_id)
    (user_id >> 56 & 0xFF).chr + (user_id >> 48 & 0xFF).chr + (user_id >> 40 & 0xFF).chr + (user_id >> 32 & 0xFF).chr + (user_id >> 24 & 0xFF).chr + (user_id >> 16 & 0xFF).chr + (user_id >> 8 & 0xFF).chr + (user_id & 0xFF).chr
  end

  # Generates users private key, Arguments: user id bytestring (from gen_uid), password String
  def self.private_key(uid, pass)
    OpenSSL::Digest.digest("SHA224", uid + pass)
  end

  # Generates public key from private key
  def self.gen_pub(priv_key)
    qbuf = FFI::MemoryPointer.new(:char, 29*3)
    zbuf = FFI::MemoryPointer.new(:char, 29)
    zbuf.put_bytes(1, priv_key)
    LibEcp::ecp_pubkey_u8 qbuf, @@pb, @@ab, @@gb, zbuf, 29

    [Base64.encode64(qbuf.get_bytes(1, 28)).rstrip, Base64.encode64(qbuf.get_bytes(30, 28)).rstrip]
  end

  # Arguments: user id, server nonce, client nonce, users private key.
  # Returns an array with the two coordinates that is the signature.
  def self.sign(user_id, snonce, cnonce, priv_key)
    rbuf = FFI::MemoryPointer.new(:char, 29)
    sbuf = FFI::MemoryPointer.new(:char, 29)
    dbuf = FFI::MemoryPointer.new(:char, 29)
    dbuf.put_bytes(1, priv_key)
    zbuf = FFI::MemoryPointer.new(:char, 29)
    zbuf.put_bytes(1, OpenSSL::Digest.digest("SHA224", user_id + snonce + cnonce))
    LibEcp::ecp_sign_u8 rbuf, sbuf, @@pb, @@ab, @@gb, @@nb, dbuf, zbuf, 29

    [rbuf.get_bytes(1, 28), sbuf.get_bytes(1, 28)]
  end
end
