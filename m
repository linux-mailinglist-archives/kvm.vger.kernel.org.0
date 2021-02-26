Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60D3326953
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 22:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhBZVSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 16:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhBZVR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 16:17:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C24EE64F26
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 21:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614374234;
        bh=6hjPDaWAzzG/U3xcNVLKJg8iviBNtdcM+5P0QYQACno=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RQHLm4ehuCYIkEMFymcX11vrJXlnuecqg2pa3QaXTISpYMIf8Y63Fcfygu5u4Bqm4
         Fk1JjuSjB7oDIeij/UGhhQgT65QxT+JKB4sOWRDFCclWyYs5BKYt6G/6N+OjWMGmLR
         rh4rbWj3Z5HI65Ln0sJjggtYr3q7EytCA2Se+oeFHbQLuZOelyIXr1mpeVR08p3yG7
         JsQiTZ09pZYRj7wBtAX7OLgizTcQlZul3oZCD3e7IptluypuIJPtTbviBYjBgO0uF5
         qT/FZvGqDspP0BkVh+r7WWLbjINn7dNC2N7xqMSW8JPrm3o2D1Gkaw3oKXbNViHiTb
         leAc2v9QowdMA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id BF655652D0; Fri, 26 Feb 2021 21:17:14 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 26 Feb 2021 21:17:14 +0000
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
Message-ID: <bug-201753-28872-ZAjVJx388D@https.bugzilla.kernel.org/>
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

--- Comment #14 from David Coe (david.coe@live.co.uk) ---
Good evening, all!

Two extra results from the Ryzen 2400G:

1. 5 x 25 msec loop on Ubuntu 21.04, kernel 5.10.11 and Suravee's original
patch.  Works fine!

2. 10x 20 msec loop on Ubuntu 20.10, kernel 5.8.18 with both Suravee and Al=
ex's
patches. Also fine!

   As expected,
      AMD-Vi: IOMMU performance counters supported
   moves to after
      Adding to iommu group ...

This means that, for this CPU, the power-gating needs between 100 - 125 mse=
c to
disable. A logging printf would have got me there faster (not overly fond of
kernel rebuilds) but the missing information is the maximum settling-time
needed across the full Ryzen range. Paul's suggestion of increasing the loop
count to 10 gives 200 msec maximum headroom. Surely must be enough?

Now, all we need is a work-around for the PCI INT A: not connected diagnost=
ic
:-).

Many thanks good people. Keep safe.

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
