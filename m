Return-Path: <kvm+bounces-2647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 686A37FBE5C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9976D1C20ECA
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0924F1E4A9;
	Tue, 28 Nov 2023 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UaeZtjUC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAE310DF
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701186183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yrCoDS9MUG1priUGb3Q/37WaBBDo23c1ylxj95tSakw=;
	b=UaeZtjUCmyrI2O/DiGdOxNsRcKzDYL8gNJhw/sZKwZD71EQsQkCPmVGpGwjz3sz9H4V852
	ophRhsdoXef1AlZGPT5/ywDooKtgkwd6KbL1aEQdGR8SZeBdYL1G9tcEZ83qZZfiKBPo7z
	RpwNEi+ix4TstPvpVf6Cf/qWckoyTFw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-LSUyNFYgOfOZs6DG0AF3fg-1; Tue, 28 Nov 2023 10:42:58 -0500
X-MC-Unique: LSUyNFYgOfOZs6DG0AF3fg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15DF6185A790;
	Tue, 28 Nov 2023 15:42:58 +0000 (UTC)
Received: from pinwheel (unknown [10.39.195.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC7C51121308;
	Tue, 28 Nov 2023 15:42:56 +0000 (UTC)
Date: Tue, 28 Nov 2023 16:42:54 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, rust-vmm@lists.opendev.org,
	devel@lists.libvirt.org
Subject: [Call for Presentations] FOSDEM 2024: Virt & IaaS Devroom
Message-ID: <ZWYKfu48zxiAlbFq@pinwheel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

[Cross-posted to KVM, Rust-VMM, QEMU, and libvirt lists)

Hi, the CFP for the "Virt & IaaS" DevRoom is out[+].

Something new this year is a new talk-submission system: so you need to
create a new account, even if you've had an account with the older
talk-submission system.  Details in the "Submit Your Proposal" section
below.

========================================================================
We are excited to announce that the call for proposals is now open for
the Virtualization and Cloud infrastructure devroom at the upcoming
FOSDEM 2024, to be hosted on February 3rd 2024.

This devroom is a collaborative effort, and is organized by dedicated
folks from projects such as OpenStack, Xen Project, KubeVirt, QEMU, KVM,
and Foreman. We would like to invite all those who are involved in these
fields to submit your proposals by December 8th, 2023.

Important Dates
---------------

Submission deadline: 8th December 2023

Acceptance notifications: 10th December 2023

Final schedule announcement: 15th December 2023

Devroom: 3rd February 2024

About the Devroom
-----------------

The Virtualization & IaaS devroom will feature session topics such as
open source hypervisors or virtual machine managers such as Xen Project,
KVM, bhyve and VirtualBox as well as Infrastructure-as-a-Service
projects such as KubeVirt, Apache CloudStack, OpenStack, QEMU and
OpenNebula.

This devroom will host presentations that focus on topics of shared
interest, such as KVM; libvirt; shared storage; virtualized networking;
cloud security; clustering and high availability; interfacing with
multiple hypervisors; hyperconverged deployments; and scaling across
hundreds or thousands of servers.

Presentations in this devroom will be aimed at developers working on
these platforms who are looking to collaborate and improve shared
infrastructure or solve common problems. We seek topics that encourage
dialog between projects and continued work post-FOSDEM.

Submit Your Proposal
--------------------

All submissions must be made via the Pretalx event planning site[1]. It
is a new submission system so you will need to create an account. If you
submitted proposals for FOSDEM in previous years, you won’t be able to
use your existing account.

During submission please make sure to select Virtualization and Cloud
infrastructure from the Track list. Please fill out all the required
fields, and provide a meaningful abstract and description of your
proposed session.

Submission Guidelines
---------------------

We expect more proposals than we can possibly accept, so it is vitally
important that you submit your proposal on or before the deadline. Late
submissions are unlikely to be considered.

All presentation slots are 30 minutes, with 20 minutes planned for
presentations, and 10 minutes for Q&A.

All presentations will be recorded and made available under Creative
Commons licenses. In the Submission notes field, please indicate that
you agree that your presentation will be licensed under the CC-By-SA-4.0
or CC-By-4.0 license and that you agree to have your presentation
recorded.  For example:

"If my presentation is accepted for FOSDEM, I hereby agree to license
all recordings, slides, and other associated materials under the
Creative Commons Attribution Share-Alike 4.0 International License.

Sincerely,

<NAME>."

In the Submission notes field, please also confirm that if your talk is
accepted, you will be able to attend FOSDEM and deliver your
presentation.  We will not consider proposals from prospective speakers
who are unsure whether they will be able to secure funds for travel and
lodging to attend FOSDEM. (Sadly, we are not able to offer travel
funding for prospective speakers.)

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

Questions?
----------

If you have any questions about this devroom, please send your questions
to our devroom mailing list[2]. You can also subscribe to the list to
receive updates about important dates, session announcements, and to
connect with other attendees.

See you all at FOSDEM!

[1] https://pretalx.fosdem.org/fosdem-2024/cfp
[2] virtualization-devroom-manager at fosdem.org
=======================================================================

[+] This email is a slightly formatted version of the official announce:
    https://lists.fosdem.org/pipermail/fosdem/2023q4/003481.html

-- 
/kashyap


