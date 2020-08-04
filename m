Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC5523B1A5
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 02:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgHDAZV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 3 Aug 2020 20:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbgHDAZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 20:25:21 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208767] kernel stack overflow due to Lazy update IOAPIC on an
 x86_64 *host*, when gpu is passthrough to macos guest vm
Date:   Tue, 04 Aug 2020 00:25:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yaweb@mail.bg
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208767-28872-Y6VSHtcuoi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
References: <bug-208767-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208767

--- Comment #5 from Yani Stoyanov (yaweb@mail.bg) ---
(In reply to Jim Mattson from comment #4)
> On Sun, Aug 2, 2020 at 2:01 AM <bugzilla-daemon@bugzilla.kernel.org> wrote:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=208767
> >
> >             Bug ID: 208767
> >            Summary: kernel stack overflow due to Lazy update IOAPIC on an
> >                     x86_64 *host*, when gpu is passthrough to macos guest
> >                     vm
> >            Product: Virtualization
> >            Version: unspecified
> >     Kernel Version: 5.6 up to and including 5.7
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: kvm
> >           Assignee: virtualization_kvm@kernel-bugs.osdl.org
> >           Reporter: yaweb@mail.bg
> >         Regression: No
> >
> > I have fedora 32 host with latest kernel on a double xeon v5 2630
> workstation
> > asus board and few vm with assigned gpus to them (linux windows and macos).
> 
> I didn't think the Mac OS X license agreement permitted running it on
> non-Apple hardware. Has this changed?

Jim Mattson, I guess official it is not support by as I wrote in the
description of the issue the problem is in the mentioned function. I tested it
and if comment the lines 

if (edge && kvm_apicv_activated(ioapic->kvm))
ioapic_lazy_update_eoi(ioapic, irq);

It boots fine, if the function invocation is not commented I kernel stack
overflow so the bug is for it it should not matter what case it right?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
