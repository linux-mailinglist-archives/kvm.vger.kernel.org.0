Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FBA349BFE
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 22:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCYVwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 17:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231233AbhCYVvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 17:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28D0761A49
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 21:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616709115;
        bh=bwFIOzzkPaRKsaCL9jS1JDpgiNCXMLMTYXZxa/QVGf8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XXeq7FemFZmXOlTMvcW8iIeTqqHC9jwUkNvyRf0RPqdMBY4K7hywiVMHRWXEf39ZN
         r80YISCLeDd8AFpXghuK9Iq6RYbGlB1py6NhHh+lrOf/OWmCgrQ6BJJ2cEKmD3IsGJ
         LFrmraJkcKlvq7gGC1jwc1PP8WIu7o3CwFR8dyfJMHRpDs5i5OwNhVTh8VR3OYGv9J
         aTf66nfd8U8Y246Fr0uIGJcjSytWl1pVXmqY20GGA5qO1UVvc5MkRCYx/Pvk/dVx/z
         hl5laiyVmud3gM3WcKS0c6RvSQ4IlSFPGayTh8flVvxg6zLLhaVKuwKIX+sbCK3f1h
         Upe8BsBBxkUBA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 2589262AC2; Thu, 25 Mar 2021 21:51:55 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 25 Mar 2021 21:51:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david.coe@live.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-3vaqHzRI1Y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #33 from David Coe (david.coe@live.co.uk) ---
Good evening all!

Herewith a summary of our various results, including my latest for the Ryze=
n 7
4700U (Acer Swift 3).

20 msec wait with logged retrys

Ryzen     Kernel            Cold    Warm

4700U   5.11.0-11            6      1
3500U   5.11.7               5      6
2500U   5.8.0-45                    5
        5.12.0 RC3           5    > 5
2400G   5.11.0-11            6      6
        5.8.0-45             5      6
2200G       ?                     >10

Two points are clear:

1. there are differences between cold and warm boot, mostly marginal but ma=
rked
and very consistent with my 4700U.

2. the choice of 5 as the maximum retry number is (sorry, Suravee) unfortun=
ate.
Mostly, it guarantees that all our Ryzens just fail the IOMMU write test!

Paul's experiences with the 2200G are the exception and I can appreciate his
unease about just increasing the number of retrys. I'm sure he, Suravee, Al=
ex
and the AMD engineers will find an elegant solution to the problem :-).

In the meantime, could you formally patch-the-patch, Suravee? I'll pass on =
the
above data to Alex Hung, our "cherry-picker" at Ubuntu.

Best regards

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
