require 'optparse'
require 'jcode'
Version  = '0.1b'
PGCONFIG = {}
OptionParser.new do |opts|
  opts.program_name = "STR2BIN"
  opts.version      = "0.1b"
  opts.banner       = "STR2BIN: ������ŋL�q���ꂽ16�i��\�\\�����o�C�i���[�f�[�^�ɕϊ����܂�\n"
                      " �N����:\n"
                      "   STR2BIN -iINPUT.dat -oOUTPUT.dat\n"
                      " �I�v�V����:"
  opts.on('-i','--infile INFILE',   '�i�K�{�j���͌��t�@�C�������w�肵�܂�') {|v| PGCONFIG[:i] = v}
  opts.on('-o','--outfile OUTFILE', '�i�K�{�j�o�͐�t�@�C�������w�肵�܂�') {|v| PGCONFIG[:o] = v}
  opts.on('-l','--licence',         '���C�Z���X����\�����܂�') do
    print <<EOD

Copyright (C)2008 Ayumu Aizawa All right reserved.

- ���̃v���O�����͖��ۏ؂ł�
- ���̃v���O�����𒘍�҂̋��������ς��邱�Ƃ��ւ��܂�
- ���̃v���O�����𒘍�҂̋������Еz���邱�Ƃ��ւ��܂�
- ���̃v���O�����𗘗p�������ɂ�鑹�Q�ɂ��Ē���҂͈�؂̐ӔC�𕉂��܂���
EOD
exit
  end
  opts.parse!(ARGV)
end

CHAR2BIN = {
  :x00 => "\x00", :x01 => "\x01", :x02 => "\x02", :x03 => "\x03", :x04 => "\x04", :x05 => "\x05", :x06 => "\x06", :x07 => "\x07",
  :x08 => "\x08", :x09 => "\x09", :x0a => "\x0a", :x0b => "\x0b", :x0c => "\x0c", :x0d => "\x0d", :x0e => "\x0e", :x0f => "\x0f",
  :x10 => "\x10", :x11 => "\x11", :x12 => "\x12", :x13 => "\x13", :x14 => "\x14", :x15 => "\x15", :x16 => "\x16", :x17 => "\x17",
  :x18 => "\x18", :x19 => "\x19", :x1a => "\x1a", :x1b => "\x1b", :x1c => "\x1c", :x1d => "\x1d", :x1e => "\x1e", :x1f => "\x1f",
  :x20 => "\x20", :x21 => "\x21", :x22 => "\x22", :x23 => "\x23", :x24 => "\x24", :x25 => "\x25", :x26 => "\x26", :x27 => "\x27",
  :x28 => "\x28", :x29 => "\x29", :x2a => "\x2a", :x2b => "\x2b", :x2c => "\x2c", :x2d => "\x2d", :x2e => "\x2e", :x2f => "\x2f",
  :x30 => "\x30", :x31 => "\x31", :x32 => "\x32", :x33 => "\x33", :x34 => "\x34", :x35 => "\x35", :x36 => "\x36", :x37 => "\x37",
  :x38 => "\x38", :x39 => "\x39", :x3a => "\x3a", :x3b => "\x3b", :x3c => "\x3c", :x3d => "\x3d", :x3e => "\x3e", :x3f => "\x3f",
  :x40 => "\x40", :x41 => "\x41", :x42 => "\x42", :x43 => "\x43", :x44 => "\x44", :x45 => "\x45", :x46 => "\x46", :x47 => "\x47",
  :x48 => "\x48", :x49 => "\x49", :x4a => "\x4a", :x4b => "\x4b", :x4c => "\x4c", :x4d => "\x4d", :x4e => "\x4e", :x4f => "\x4f",
  :x50 => "\x50", :x51 => "\x51", :x52 => "\x52", :x53 => "\x53", :x54 => "\x54", :x55 => "\x55", :x56 => "\x56", :x57 => "\x57",
  :x58 => "\x58", :x59 => "\x59", :x5a => "\x5a", :x5b => "\x5b", :x5c => "\x5c", :x5d => "\x5d", :x5e => "\x5e", :x5f => "\x5f",
  :x60 => "\x60", :x61 => "\x61", :x62 => "\x62", :x63 => "\x63", :x64 => "\x64", :x65 => "\x65", :x66 => "\x66", :x67 => "\x67",
  :x68 => "\x68", :x69 => "\x69", :x6a => "\x6a", :x6b => "\x6b", :x6c => "\x6c", :x6d => "\x6d", :x6e => "\x6e", :x6f => "\x6f",
  :x70 => "\x70", :x71 => "\x71", :x72 => "\x72", :x73 => "\x73", :x74 => "\x74", :x75 => "\x75", :x76 => "\x76", :x77 => "\x77",
  :x78 => "\x78", :x79 => "\x79", :x7a => "\x7a", :x7b => "\x7b", :x7c => "\x7c", :x7d => "\x7d", :x7e => "\x7e", :x7f => "\x7f",
  :x80 => "\x80", :x81 => "\x81", :x82 => "\x82", :x83 => "\x83", :x84 => "\x84", :x85 => "\x85", :x86 => "\x86", :x87 => "\x87",
  :x88 => "\x88", :x89 => "\x89", :x8a => "\x8a", :x8b => "\x8b", :x8c => "\x8c", :x8d => "\x8d", :x8e => "\x8e", :x8f => "\x8f",
  :x90 => "\x90", :x91 => "\x91", :x92 => "\x92", :x93 => "\x93", :x94 => "\x94", :x95 => "\x95", :x96 => "\x96", :x97 => "\x97",
  :x98 => "\x98", :x99 => "\x99", :x9a => "\x9a", :x9b => "\x9b", :x9c => "\x9c", :x9d => "\x9d", :x9e => "\x9e", :x9f => "\x9f",
  :xa0 => "\xa0", :xa1 => "\xa1", :xa2 => "\xa2", :xa3 => "\xa3", :xa4 => "\xa4", :xa5 => "\xa5", :xa6 => "\xa6", :xa7 => "\xa7",
  :xa8 => "\xa8", :xa9 => "\xa9", :xaa => "\xaa", :xab => "\xab", :xac => "\xac", :xad => "\xad", :xae => "\xae", :xaf => "\xaf",
  :xb0 => "\xb0", :xb1 => "\xb1", :xb2 => "\xb2", :xb3 => "\xb3", :xb4 => "\xb4", :xb5 => "\xb5", :xb6 => "\xb6", :xb7 => "\xb7",
  :xb8 => "\xb8", :xb9 => "\xb9", :xba => "\xba", :xbb => "\xbb", :xbc => "\xbc", :xbd => "\xbd", :xbe => "\xbe", :xbf => "\xbf",
  :xc0 => "\xc0", :xc1 => "\xc1", :xc2 => "\xc2", :xc3 => "\xc3", :xc4 => "\xc4", :xc5 => "\xc5", :xc6 => "\xc6", :xc7 => "\xc7",
  :xc8 => "\xc8", :xc9 => "\xc9", :xca => "\xca", :xcb => "\xcb", :xcc => "\xcc", :xcd => "\xcd", :xce => "\xce", :xcf => "\xcf",
  :xd0 => "\xd0", :xd1 => "\xd1", :xd2 => "\xd2", :xd3 => "\xd3", :xd4 => "\xd4", :xd5 => "\xd5", :xd6 => "\xd6", :xd7 => "\xd7",
  :xd8 => "\xd8", :xd9 => "\xd9", :xda => "\xda", :xdb => "\xdb", :xdc => "\xdc", :xdd => "\xdd", :xde => "\xde", :xdf => "\xdf",
  :xe0 => "\xe0", :xe1 => "\xe1", :xe2 => "\xe2", :xe3 => "\xe3", :xe4 => "\xe4", :xe5 => "\xe5", :xe6 => "\xe6", :xe7 => "\xe7",
  :xe8 => "\xe8", :xe9 => "\xe9", :xea => "\xea", :xeb => "\xeb", :xec => "\xec", :xed => "\xed", :xee => "\xee", :xef => "\xef",
  :xf0 => "\xf0", :xf1 => "\xf1", :xf2 => "\xf2", :xf3 => "\xf3", :xf4 => "\xf4", :xf5 => "\xf5", :xf6 => "\xf6", :xf7 => "\xf7",
  :xf8 => "\xf8", :xf9 => "\xf9", :xfa => "\xfa", :xfb => "\xfb", :xfc => "\xfc", :xfd => "\xfd", :xfe => "\xfe", :xff => "\xff" }

tmp   = [nil,nil]
ix    = 0
ofile = File.open(PGCONFIG[:o],'wb')
File.open(PGCONFIG[:i],'r') do |ifile|
  ifile.each do |line|
    line.chomp!
    line.each_char do |c|
      tmp[ix] = c
      if ix == 0 then
        ix = 1
      else
        ix = 0
        ofile.write CHAR2BIN[:"x#{tmp.join.downcase}"]
        tmp = [nil,nil]
      end
    end
  end
end
ofile.write CHAR2BIN[:"x#{tmp[0].downcase}0"] if tmp[0]
ofile.close
