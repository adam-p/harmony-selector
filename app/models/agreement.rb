class Agreement < ActiveRecord::Base

  def format_method
      fmt = self.method.split(",")
      if fmt.length > 1
        fmt[-1] = "or " + fmt[-1]
      end
      if fmt.length == 2
        return fmt.join(" ")
      else
        return fmt.join(", ")
      end
  end

  def format_license(raw)
      if raw == ''
        return ''
      end

      rawlist = raw.split(",")
      fmt = []
      rawlist.each do |l|
        license = License.find_by_spdx(l)
        fmt.push(license.name)
      end
      if fmt.length > 1
        fmt[-1] = "or " + fmt[-1]
      end
      if fmt.length == 2
        return fmt.join(" ")
      else
        return fmt.join(", ")
      end
  end

  def format_outbound
    return self.format_license(self.outbound)
  end

  def format_media
    return self.format_license(self.media)
  end

  def filename_pdf(entity)
    if entity
      filename = self.projectname + "-Entity.pdf"
    else
      filename = self.projectname + "-Individual.pdf"
    end
    return filename
  end

  def format_shortmark(entity)

    if self.option == 2
      option = "-LIST"
    elsif self.option == 3
      option = "-OSI"
    elsif self.option == 4
      option = "-FSF"
    elsif self.option == 5
      option = "-ANY"
    else
      option = ''
    end

    if entity
      person = "-E"
    else
      person = "-I"
    end

    shortmark = "HA-" + self.grant.upcase + person + option
    return shortmark
  end

  def format_pdf(entity)
      pdf = Prawn::Document.new(:margin => [60, 60, 60, 60])
      pdf.font "Times-Roman"
      #pdf.font-size 10


      pdf.create_stamp("footer") {
          pdf.draw_text(
                  "Harmony (" + self.format_shortmark(entity) + ") Version " + self.version,
                  :size => 8,
                  :at => [pdf.bounds.left, pdf.bounds.bottom - 10])
      }

      title = self.projectname

      if entity
        title += " Entity"
        affiliates = " or Your Affiliates"
      else
        title += " Individual"
        affiliates = ""
      end

      title += " Contributor "

      if self.grant == "cla"
        title += "License"
      elsif self.grant == "caa"
        title += "Assignment"
      end
      title += " Agreement"
      
      pdf.text title, :style => :bold, :align => :center
      pdf.move_down 10
      pdf.text "Thank you for your interest in contributing to " + self.projectname + " (\"We\" or \"Us\")."
      pdf.move_down 10
      pdf.text "This contributor agreement (\"Agreement\") documents the rights granted by contributors to Us. To make this document effective, please sign it and send it to Us by " + self.format_method + ", following the instructions at " + self.submission + ". This is a legally binding document, so please read it carefully before agreeing to it. The Agreement may cover more than one software project managed by Us."

      pdf.move_down 10
      pdf.text "1. Definitions", :style => :bold

      pdf.indent(20) do #definitions
          pdf.move_down 10
          if entity
              pdf.text "\"You\" means any Legal Entity on behalf of whom a Contribution has been received by Us. \"Legal Entity\" means an entity which is not a natural person. \"Affiliates\" means other Legal Entities that control, are controlled by, or under common control with that Legal Entity. For the purposes of this definition, \"control\" means (i) the power, direct or indirect, to cause the direction or management of such Legal Entity, whether by contract or otherwise, (ii) ownership of fifty percent (50%) or more of the outstanding shares or securities which vote to elect the management or other persons who direct such Legal Entity or (iii) beneficial ownership of such entity."
          else
              pdf.text "\"You\" means the individual who Submits a Contribution to Us."
          end


          pdf.move_down 10
          pdf.text "\"Contribution\" means any work of authorship that is Submitted by You to Us in which You own or assert ownership of the Copyright. If You do not own the Copyright in the entire work of authorship, please follow the instructions in " + self.nonowner + "."

          pdf.move_down 10
          pdf.text "\"Copyright\" means all rights protecting works of authorship owned or controlled by You" + affiliates + ", including copyright, moral and neighboring rights, as appropriate, for the full term of their existence including any extensions by You."

          pdf.move_down 10
          pdf.text "\"Material\" means the work of authorship which is made available by Us to third parties. When this Agreement covers more than one software project, the Material means the work of authorship to which the Contribution was Submitted. After You Submit the Contribution, it may be included in the Material."

          pdf.move_down 10
          pdf.text "\"Submit\"  means any form of electronic, verbal, or written communication sent to Us or our representatives, including but not limited to electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, Us for the purpose of discussing and improving the Material, but excluding communication that is conspicuously marked or otherwise designated in writing by You as \"Not a Contribution.\""

          pdf.move_down 10
          pdf.text "\"Submission Date\" means the date on which You Submit a Contribution to Us."

          pdf.move_down 10
          pdf.text "\"Effective Date\" means the date You execute this Agreement or the date You first Submit a Contribution to Us, whichever is earlier."

          pdf.move_down 10
          pdf.text "\"Media\" means any portion of a Contribution which is not software."

      end #definitions

      pdf.move_down 10
      pdf.text "2. Grant of Rights", :style => :bold

      pdf.move_down 10
      if self.grant == "cla"
      pdf.text "2.1 Copyright License"

      pdf.move_down 10
      pdf.text "(a) You retain ownership of the Copyright in Your Contribution and have the same rights to use or license the Contribution which You would have had without entering into the Agreement."

      pdf.move_down 10
      pdf.text "(b) To the maximum extent permitted by the relevant law, You grant to Us a perpetual, worldwide, non-exclusive, transferable, royalty-free, irrevocable license under the Copyright covering the Contribution, with the right to sublicense such rights through multiple tiers of sublicensees, to reproduce, modify, display, perform and distribute the Contribution as part of the Material; provided that this license is conditioned upon compliance with Section 2.3."

      elsif self.grant == "caa"
      pdf.text "2.1 Copyright Assignment"

      pdf.move_down 10
      pdf.text "(a) At the time the Contribution is Submitted, You assign to Us all right, title, and interest worldwide in all Copyright covering the Contribution; provided that this transfer is conditioned upon compliance with Section 2.3."

      pdf.move_down 10
      pdf.text "(b) To the extent that any of the rights in Section 2.1(a) cannot be assigned by You to Us, You grant to Us a perpetual, worldwide, exclusive, royalty-free, transferable, irrevocable license under such non-assigned rights, with rights to sublicense through multiple tiers of sublicensees, to practice such non-assigned rights, including, but not limited to, the right to reproduce, modify, display, perform and distribute the Contribution; provided that this license is conditioned upon compliance with Section 2.3."

      pdf.move_down 10
      pdf.text "(c) To the extent that any of the rights in Section 2.1(a) can neither be assigned nor licensed by You to Us, You irrevocably waive and agree never to assert such rights against Us, any of our successors in interest, or any of our licensees, either direct or indirect; provided that this agreement not to assert is conditioned upon compliance with Section 2.3."

      pdf.move_down 10
      pdf.text "(d) Upon such transfer of rights to Us, to the maximum extent possible, We immediately grant to You a perpetual, worldwide, non-exclusive, royalty-free, transferable, irrevocable license under such rights covering the Contribution, with rights to sublicense through multiple tiers of sublicensees, to reproduce, modify, display, perform, and distribute the Contribution. The intention of the parties is that this license will be as broad as possible and to provide You with rights as similar as possible to the owner of the rights that You transferred. This license back is limited to the Contribution and does not provide any rights to the Material."
      end

      pdf.move_down 10
      pdf.text "2.2 Patent License"

      pdf.move_down 10
      pdf.text "For patent claims including, without limitation, method, process, and apparatus claims which You" + affiliates + " own, control or have the right to grant, now or in the future, You grant to Us a perpetual, worldwide, non-exclusive, transferable, royalty-free, irrevocable patent license, with the right to sublicense these rights to multiple tiers of sublicensees, to make, have made, use, sell, offer for sale, import and otherwise transfer the Contribution and the Contribution in combination with the Material (and portions of such combination). This license is granted only to the extent that the exercise of the licensed rights infringes such patent claims; and provided that this license is conditioned upon compliance with Section 2.3."

      pdf.move_down 10
      pdf.text "2.3 Outbound License"

      pdf.move_down 10
      if self.option == 1
      pdf.text "As a condition on the grant of rights in Sections 2.1 and 2.2, We agree to license the Contribution only under the terms of the license or licenses which We are using on the Submission Date for the Material (including any rights to adopt any future version of a license if permitted)."

      elsif self.option == 2
      pdf.text "As a condition on the grant of rights in Sections 2.1 and 2.2, We agree to license the Contribution only under the terms of the license or licenses which We are using on the Submission Date for the Material or the following additional licenses " + self.format_outbound + " (including any right to adopt any future version of a license if permitted)."

      elsif self.option == 3
      pdf.text "As a condition on the grant of rights in Sections 2.1 and 2.2, We agree to license the Contribution only under the terms of the license or licenses which We are using on the Submission Date for the Material or any licenses which are approved by the Open Source Initiative on or after the Effective Date, including both permissive and copyleft licenses, whether or not such licenses are subsequently disapproved (including any right to adopt any future version of a license if permitted)."

      elsif self.option == 4
      pdf.text "As a condition on the grant of rights in Sections 2.1 and 2.2, We agree to license the Contribution only under the terms of the license or licenses which We are using on the Submission Date for the Material or any licenses on the Free Software Foundation's list of \"Recommended copyleft licenses\" on or after the Effective Date, whether or not such licenses are subsequently disapproved (including any right to adopt any future version of a license if permitted)."

      elsif self.option == 5
      pdf.text "Based on the grant of rights in Sections 2.1 and 2.2, if We include Your Contribution in a Material, We may license the Contribution under any license, including copyleft, permissive, commercial, or proprietary licenses. As a condition on the exercise of this right, We agree to also license the Contribution under the terms of the license or licenses which We are using for the Material on the Submission Date."
      end

      pdf.move_down 10
      pdf.text "In addition, We may use the following licenses for Media in the Contribution: " + self.format_media + " (including any right to adopt any future version of a license if permitted)."

      pdf.move_down 10
      pdf.text "2.4 Moral Rights. If moral rights apply to the Contribution, to the maximum extent permitted by law, You waive and agree not to assert such moral rights against Us or our successors in interest, or any of our licensees, either direct or indirect."

      pdf.move_down 10
      pdf.text "2.5 Our Rights. You acknowledge that We are not obligated to use Your Contribution as part of the Material and may decide to include any Contribution We consider appropriate."

      pdf.move_down 10
      assigned = ""
      if self.grant = "caa"
        assigned = "assigned or "
      end
      pdf.text "2.6 Reservation of Rights. Any rights not expressly " + assigned + "licensed under this section are expressly reserved by You."

      pdf.move_down 10
      pdf.text "3. Agreement", :style => :bold

      pdf.move_down 10
      pdf.text "You confirm that:"

      pdf.move_down 10
      pdf.text "(a) You have the legal authority to enter into this Agreement."

      pdf.move_down 10
      pdf.text "(b) You" + affiliates + " own the Copyright and patent claims covering the Contribution which are required to grant the rights under Section 2."

      pdf.move_down 10
      if entity
          pdf.text "(c) The grant of rights under Section 2 does not violate any grant of rights which You or Your Affiliates have made to third parties."
      else
          pdf.text "(c) The grant of rights under Section 2 does not violate any grant of rights which You have made to third parties, including Your employer.  If You are an employee, You have had Your employer approve this Agreement or sign the Entity version of this document.  If You are less than eighteen years old, please have Your parents or guardian sign the Agreement."
      end

      pdf.move_down 10
      pdf.text "(d) You have followed the instructions in " + self.nonowner + ", if You do not own the Copyright in the entire work of authorship Submitted."

      pdf.move_down 10
      pdf.text "4. Disclaimer", :style => :bold

      pdf.move_down 10
      if self.grant = "caa"
        assigned = " AND BY US TO YOU"
      end
      pdf.text "EXCEPT FOR THE EXPRESS WARRANTIES IN SECTION 3, THE CONTRIBUTION IS PROVIDED \"AS IS\". MORE PARTICULARLY, ALL EXPRESS OR IMPLIED WARRANTIES INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE EXPRESSLY DISCLAIMED BY YOU TO US" + assigned + ". TO THE EXTENT THAT ANY SUCH WARRANTIES CANNOT BE DISCLAIMED, SUCH WARRANTY IS LIMITED IN DURATION TO THE MINIMUM PERIOD PERMITTED BY LAW."

      pdf.move_down 10
      pdf.text "5. Consequential Damage Waiver", :style => :bold

      pdf.move_down 10
      if self.grant = "caa"
        assigned = "OR US "
      end
      pdf.text "TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT WILL YOU " + assigned + "BE LIABLE FOR ANY LOSS OF PROFITS, LOSS OF ANTICIPATED SAVINGS, LOSS OF DATA, INDIRECT, SPECIAL, INCIDENTAL, CONSEQUENTIAL AND EXEMPLARY DAMAGES ARISING OUT OF THIS AGREEMENT REGARDLESS OF THE LEGAL OR EQUITABLE THEORY (CONTRACT, TORT OR OTHERWISE) UPON WHICH THE CLAIM IS BASED."

      pdf.move_down 10
      pdf.text "6. Miscellaneous", :style => :bold

      pdf.move_down 10
      pdf.text "6.1 This Agreement will be governed by and construed in accordance with the laws of " + self.jurisdiction + " excluding its conflicts of law provisions. Under certain circumstances, the governing law in this section might be superseded by the United Nations Convention on Contracts for the International Sale of Goods (\"UN Convention\") and the parties intend to avoid the application of the UN Convention to this Agreement and, thus, exclude the application of the UN Convention in its entirety to this Agreement."

      pdf.move_down 10
      pdf.text "6.2 This Agreement sets out the entire agreement between You and Us for Your Contributions to Us and overrides all other agreements or understandings."

      pdf.move_down 10
      pdf.text "6.3  If You or We assign the rights or obligations received through this Agreement to a third party, as a condition of the assignment, that third party must agree in writing to abide by all the rights and obligations in the Agreement."

      pdf.move_down 10
      pdf.text "6.4 The failure of either party to require performance by the other party of any provision of this Agreement in one situation shall not affect the right of a party to require such performance at any time in the future. A waiver of performance under a provision in one situation shall not be considered a waiver of the performance of the provision in the future or a waiver of the provision in its entirety."

      pdf.move_down 10
      pdf.text "6.5 If any provision of this Agreement is found void and unenforceable, such provision will be replaced to the extent possible with a provision that comes closest to the meaning of the original provision and which is enforceable.  The terms and conditions set forth in this Agreement shall apply notwithstanding any failure of essential purpose of this Agreement or any limited remedy to the maximum extent possible under law."

      pdf.move_down 10
      pdf.text "You"
      pdf.text "________________________"
      pdf.text "Name: __________________"
      if entity
      pdf.text "Title: ___________________"
      end
      pdf.text "Address: ________________"
      pdf.text "________________________"

      pdf.move_down 10
      pdf.text "Us"
      pdf.text "________________________"
      pdf.text "Name: __________________"
      pdf.text "Title: ___________________"
      pdf.text "Address: ________________"
      pdf.text "________________________"

      pdf.number_pages "<page> of <total>", { :page_filter => :all,
                                              :at => [pdf.bounds.right - 50, pdf.bounds.bottom - 10],
                                              :align => :right,
                                              :width => 50,
                                              :size => 8}

      # footer
      pdf.page_count.times do |i|
          pdf.go_to_page(i+1)
          pdf.stamp("footer")
      end #footer

      return pdf
  end

end
