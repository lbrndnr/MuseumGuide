Pod::Spec.new do |s|
  s.name         = "MuseumGuide"
  s.version      = "0.0.1"
  s.summary      = "A small framework that makes UIImage accessible"

  s.description  = <<-DESC
                   MuseumGuide is a small framework that makes UIImage accessible. It generates accessible labels to describe given images. It does so by extracting the exif payload and doing some basic image processing.
                   DESC

  s.homepage     = "https://github.com/lbrndnr/MuseumGuide"
  s.screenshot  = "https://raw.githubusercontent.com/lbrndnr/MuseumGuide/master/Screenshots/Example.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Laurin Brandner" => "hello@laurinbrandner.ch" }
  s.social_media_url   = "http://twitter.com/lbrndnr"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/lbrndnr/MuseumGuide.git", :tag => s.version }
  s.source_files  = "MuseumGuide/MuseumGuide/*.swift"
  s.frameworks  = "CoreImage", "ImageIO", "CoreGraphics", "AVFoundation"
  s.requires_arc = true
end
