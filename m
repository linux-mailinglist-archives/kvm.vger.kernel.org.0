Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FED2CBBEE
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 12:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgLBLvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 06:51:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgLBLvU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 06:51:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606909793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=ZQDXqIHaIwz7hDh/GUJUdYz39C6ttyfHLyYmff3IP0w=;
        b=BhlCWJ00vgEZKbgqG9ZhVaAst5cchXAbdDt+bQrcbDMltz0r5btFDHmOWPnPMXKEJY/ZxO
        gk8fGIcaDgH0XOrpwvCakN4jJSnup9s/Mieeb+XhNLIFm0KMDxigeqj2nuTfHz06EEa0AY
        RHfcMuVzN/gmHD0iID1deV+sRgUvZ98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-u7Kn-zBGNZSCZjpYHDA4jQ-1; Wed, 02 Dec 2020 06:49:49 -0500
X-MC-Unique: u7Kn-zBGNZSCZjpYHDA4jQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7444817B9F;
        Wed,  2 Dec 2020 11:49:48 +0000 (UTC)
Received: from paraplu.localdomain (ovpn-115-26.ams2.redhat.com [10.36.115.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84C7460BFA;
        Wed,  2 Dec 2020 11:49:41 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id D502C3E0495; Wed,  2 Dec 2020 12:49:39 +0100 (CET)
Date:   Wed, 2 Dec 2020 12:49:39 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org, libvir-list@redhat.com
Subject: [Call for Presentations] FOSDEM 2021: Virt & IaaS Devroom
Message-ID: <20201202114939.GJ918328@paraplu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cross-posting to KVM, QEMU, and libvirt lists]

The Call For Papers for FOSDEM's Virt & IaaS Devroom went out
yesterday[1].  Here's the text (slightly formatted for readability):

=======================================================================
We are excited to announce that the call for proposals is now open for
the Virtualization & IaaS devroom at the upcoming FOSDEM 2021, to be
hosted virtually on February 6th 2021.

This year will mark FOSDEM's 21th anniversary as one of the
longest-running free and open source software developer events,
attracting thousands of developers and users from all over the world.
Due to Covid-19, FOSDEM will be held virtually this year on February 6th
& 7th, 2021.

Important Dates
---------------

* Submission deadline: 20th of December

* Acceptance notifications: 25th of December

* Final schedule announcement: 31st of December

* Recorded presentations upload deadline: 15th of January

* Devroom: 6th February 2021

About the Devroom
-----------------

The Virtualization & IaaS devroom will feature session topics such as
open source hypervisors and virtual machine managers such as Xen
Project, KVM, bhyve, and VirtualBox, and Infrastructure-as-a-Service
projects such as KubeVirt, Apache CloudStack, Foreman, OpenStack, oVirt,
QEMU and OpenNebula.

This devroom will host presentations that focus on topics of shared
interest, such as KVM; libvirt; shared storage; virtualized networking;
cloud security; clustering and high availability; interfacing with
multiple hypervisors; hyperconverged deployments; and scaling across
hundreds or thousands of servers.

Presentations in this devroom will be aimed at users or developers
working on these platforms who are looking to collaborate and improve
shared infrastructure or solve common problems. We seek topics that
encourage dialog between projects and continued work post-FOSDEM.

Submit Your Proposal
--------------------

All submissions must be made via the Pentabarf event planning site[1].
If you have not used Pentabarf before, you will need to create an
account. If you submitted proposals for FOSDEM in previous years, you
can use your existing account.

After creating the account, select Create Event to start the submission
process. Make sure to select Virtualization and IaaS devroom from the
Track list. Please fill out all the required fields, and provide a
meaningful abstract and description of your proposed session.

Submission Guidelines
---------------------

We expect more proposals than we can possibly accept, so it is vitally
important that you submit your proposal on or before the deadline. Late
submissions are unlikely to be considered.

All presentation slots are 30 minutes, with 20 minutes planned for
presentations, and 10 minutes for Q&A.

All presentations will need to be pre-recorded and put into our system
at least a couple of weeks before the event.

The presentations should be uploaded by 15th of January and made
available under Creative Commons licenses. In the Submission notes
field, please indicate that you agree that your presentation will be
licensed under the CC-By-SA-4.0 or CC-By-4.0 license and that you agree
to have your presentation recorded.  For example:

"If my presentation is accepted for FOSDEM, I hereby agree to license
all recordings, slides, and other associated materials under the
Creative Commons Attribution Share-Alike 4.0 International License.
Sincerely, <NAME>."

In the Submission notes field, please also confirm that if your talk is
accepted, you will be able to attend the virtual FOSDEM event for the
Q&A.  We will not consider proposals from prospective speakers who are
unsure whether they will be able to attend the FOSDEM virtual event.

If you are experiencing problems with Pentabarf, the proposal submission
interface, or have other questions, you can email our devroom mailing
list[2] and we will try to help you.

Code of Conduct
---------------

Following the release of the updated code of conduct for FOSDEM, we'd
like to remind all speakers and attendees that all of the presentations
and discussions in our devroom are held under the guidelines set in the
CoC and we expect attendees, speakers, and volunteers to follow the CoC
at all times.

If you submit a proposal and it is accepted, you will be required to
confirm that you accept the FOSDEM CoC. If you have any questions about
the CoC or wish to have one of the devroom organizers review your
presentation slides or any other content for CoC compliance, please
email us and we will do our best to assist you.

Call for Volunteers
-------------------

We are also looking for volunteers to help run the devroom. We need
assistance with helping speakers to record the presentation as well as
helping with streaming and chat moderation for the devroom. Please
contact devroom mailing list [2] for more information.

Questions?
----------

If you have any questions about this devroom, please send your questions
to our devroom mailing list. You can also subscribe to the list to
receive updates about important dates, session announcements, and to
connect with other attendees.

See you all at FOSDEM!

[1] https://penta.fosdem.org/submission/FOSDEM21 
[2] iaas-virt-devroom at lists.fosdem.org
=======================================================================

[+] https://lists.fosdem.org/pipermail/fosdem/2020q4/003109.html


-- 
/kashyap

