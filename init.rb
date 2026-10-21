# Redmine เลือก font ของ PDF ตามภาษาของ user (en = freesans ซึ่งไม่มีตัวอักษรไทย -> ภาษาไทยเป็นสี่เหลี่ยม)
# plugin นี้เปลี่ยนเป็น freeserif (มีภาษาไทย) ทุกภาษาที่ใช้ font ละติน แทนการแก้ lib/redmine/export/pdf.rb ซึ่งจะหายตอนอัปเกรด
Redmine::Plugin.register :redmine_pdf_thai_font do
  name 'Redmine PDF Thai Font'
  author 'Tanachart Changcharoen'
  description 'Show Thai text correctly in PDF export for users of every Latin-font language (English, etc.)'
  version '1.0.0'
  requires_redmine version_or_higher: '4.2.0'
end

module RedminePdfThaiFont
  FONT = 'freeserif'
  # font ละตินที่ไม่มีตัวอักษรไทย (ภาษาที่ใช้ font CJK เช่น ja/zh/ko ไม่เปลี่ยน ไม่งั้นตัวอักษรของภาษานั้นจะเสีย)
  NO_THAI = %w(freesans freemono dejavusans dejavusansmono)

  def initialize(lang, orientation='P')
    super
    return unless NO_THAI.include?(@font_for_content.to_s.downcase)
    @font_for_content = @monospaced_font_for_content = @font_for_footer = FONT
    set_font(FONT)
    set_header_font([FONT, '', 10])
    set_footer_font([FONT, '', 8])
    set_default_monospaced_font(FONT)
  end
end

Redmine::Export::PDF::ITCPDF.prepend(RedminePdfThaiFont)
