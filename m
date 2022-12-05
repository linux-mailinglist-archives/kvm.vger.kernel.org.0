Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC7642A79
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiLEOiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLEOiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:38:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B510C1A81C
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670251035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vV9PMDL+KA0rIpH4IuTajPJGN9XJ8EJIKaDHOdvt+Rk=;
        b=RnUkiUX609/thskEINT3IerzkXHwLrDX+DNuDMRhF9CTYU1MI+75G3e4S8SsO6vQO5GbRj
        4yKJ8jlxW2tVMxhWnCU0N84MQ9OTBjPmpcqtKeQGRWdq44Dw5IRCNfppgTjn9nVNHcTP9a
        USQqWcERY1KTw+S9Je8SEKbEAAwmS5A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-yXYBiN0SOweKd3xpku7l_w-1; Mon, 05 Dec 2022 09:37:10 -0500
X-MC-Unique: yXYBiN0SOweKd3xpku7l_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1C43185A794;
        Mon,  5 Dec 2022 14:37:09 +0000 (UTC)
Received: from pinwheel (unknown [10.39.195.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25D8140C6EC3;
        Mon,  5 Dec 2022 14:37:07 +0000 (UTC)
Date:   Mon, 5 Dec 2022 15:37:03 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        rust-vmm@lists.opendev.org, libvir-list@redhat.com
Cc:     Mahmoud Abdelghany <blackbeard334@protonmail.com>,
        stefanha@gmail.com
Subject: Re: Call for FOSDEM presentations on QEMU, KVM, and rust-vmm
Message-ID: <Y44CD6zmU0G3vrEu@pinwheel>
References: <CAJSP0QXc9MOUuU9amBorzV4hf9A9HWFZrtn3sZzJ-OkWMwvNPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXc9MOUuU9amBorzV4hf9A9HWFZrtn3sZzJ-OkWMwvNPw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(Cc also: libvirt upstream maling list)

Gentle reminder ...

tl;dr: please submit the proposals by *10th Dec 2022*

On Tue, Nov 08, 2022 at 10:45:33AM -0500, Stefan Hajnoczi wrote:
> Hi,
> The yearly FOSDEM open source conference is now accepting talk
> proposals. FOSDEM '23 will be held in Brussels, Belgium on 4 & 5
> February.
> 
> FOSDEM is a huge free conference about all things open source and an
> opportunity for anyone to present QEMU or KVM topics. Both in-person
> and pre-recorded talks are being accepted this year.
> 
> Please consider submitting your talks to the following devrooms:
> 
> Emulator Development Room:
> https://blackbeard334.github.io/fosdem23-emulator-devroom-cfp/
> 
> Virtualization and IaaS devroom:
> https://fosdem.org/2023/schedule/track/virtualization_and_iaas/
> 
> Rust devroom:
> https://rust-fosdem.github.io/

(I've re-posted the official announcement[0] along the way, I manually
fixed the broken text formatting, a URL, and moved the "important dates"
section to the top.

[0] https://lists.fosdem.org/pipermail/fosdem/2022q4/003473.html)

-----------------------------------------------------------------------
We are excited to announce that the call for proposals is now open for
the Virtualization & IaaS devroom at the upcoming FOSDEM 2023, to be
hosted on February 4th 2023.

This devroom is a collaborative effort, and is organized by dedicated
folks from projects such as OpenStack, Xen Project, KubeVirt, QEMU, KVM,
and Foreman. We would like to invite all those who are involved in these
fields to submit your proposals by December 10th, 2022.

Important Dates
---------------

Submission deadline: 10th December 2022

Acceptance notifications: 15th December 2022

Final schedule announcement: 20th December 2022

Conference devroom: first half of 4th February 2023


About the Devroom
-----------------

The Virtualization & IaaS devroom will feature session topics such as
open source hypervisors or virtual machine managers such as Xen Project,
KVM, bhyve and VirtualBox as well as Infrastructure-as-a-Service
projects such as KubeVirt, Apache CloudStack, OpenStack, QEMU and
OpenNebula.

This devroom will host presentations that focus on topics of shared
interest, such as KVM; libvirt; shared storage; virtualized networking;
cloud security; clustering and high availability; interfacing with multiple
hypervisors; hyperconverged deployments; and scaling across hundreds or
thousands of servers.

Presentations in this devroom will be aimed at developers working on these
platforms who are looking to collaborate and improve shared infrastructure
or solve common problems. We seek topics that encourage dialog between
projects and continued work post-FOSDEM.


Submit Your Proposal
--------------------

All submissions must be made via the Pentabarf event planning site[1]. If
you have not used Pentabarf before, you will need to create an account. If
you submitted proposals for FOSDEM in previous years, you can use your
existing account.

After creating the account, select Create Event to start the submission
process. Make sure to select Virtualization and IaaS devroom from the Track
list. Please fill out all the required fields, and provide a meaningful
abstract and description of your proposed session.

Submission Guidelines
---------------------

We expect more proposals than we can possibly accept, so it is vitally
important that you submit your proposal on or before the deadline. Late
submissions are unlikely to be considered.

All presentation slots are 30 minutes, with 20 minutes planned for
presentations, and 10 minutes for Q&A.

All presentations will be recorded and made available under Creative
Commons licenses. In the Submission notes field, please indicate that you
agree that your presentation will be licensed under the CC-By-SA-4.0 or
CC-By-4.0 license and that you agree to have your presentation recorded.

For example:

"If my presentation is accepted for FOSDEM, I hereby agree to license all
recordings, slides, and other associated materials under the Creative
Commons Attribution Share-Alike 4.0 International License. Sincerely,
<NAME>."

In the Submission notes field, please also confirm that if your talk is
accepted, you will be able to attend FOSDEM and deliver your presentation.
We will not consider proposals from prospective speakers who are unsure
whether they will be able to secure funds for travel and lodging to attend
FOSDEM. (Sadly, we are not able to offer travel funding for prospective
speakers.)

Submission Guidelines
---------------------

Mentored presentations will have 25-minute slots, where 20 minutes will
include the presentation and 5 minutes will be reserved for questions.
The number of newcomer session slots is limited, so we will probably not be
able to accept all applications.

You must submit your talk and abstract to apply for the mentoring program,
our mentors are volunteering their time and will happily provide feedback
but won't write your presentation for you!

If you are experiencing problems with Pentabarf, the proposal submission
interface, or have other questions, you can email our devroom mailing
list[2] and we will try to help you.

How to Apply
------------

In addition to agreeing to video recording and confirming that you can
attend FOSDEM in case your session is accepted, please write "speaker
mentoring program application" in the "Submission notes" field, and list
any prior speaking experience or other relevant information for your
application.

Code of Conduct
---------------

Following the release of the updated code of conduct for FOSDEM, we'd like
to remind all speakers and attendees that all of the presentations and
discussions in our devroom are held under the guidelines set in the CoC and
we expect attendees, speakers, and volunteers to follow the CoC at all
times.

If you submit a proposal and it is accepted, you will be required to
confirm that you accept the FOSDEM CoC. If you have any questions about the
CoC or wish to have one of the devroom organizers review your presentation
slides or any other content for CoC compliance, please email us and we will
do our best to assist you.

Call for Volunteers
-------------------

We are also looking for volunteers to help run the devroom. We need
assistance watching time for the speakers, and helping with video for the
devroom. Please contact devroom mailing list[2] for more information.

Questions?
----------

If you have any questions about this devroom, please send your questions to
our devroom mailing list. You can also subscribe to the list to receive
updates about important dates, session announcements, and to connect with
other attendees.

See you all at FOSDEM!

[1] https://penta.fosdem.org/submission
[2] iaas-virt-devroom at lists.fosdem.org
-----------------------------------------------------------------------

-- 
/kashyap

