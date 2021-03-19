Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB104341809
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCSJNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhCSJNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 05:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6398A64F74
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 09:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616145198;
        bh=qVykVAxU37xXlT6Qq0Ug1vhZf3b54qroEW32wi0GU/8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=h38HUdSjyGwNIXx2BHaivJaD2PObtsOWPB7lojmlcRFOu/x8N7Uc2ycbwXo/N79lG
         WMmLKF7KACA2o/+au5YjLrl6+z8sAXJImGhyWyKKPj2R1r7/2vM2cVWUeImOPfTwk6
         jhtVzAaJE211XfxurAmrg23vCTkNWs0sBSeN1thYsXhBkyrnft4FA9Jg1p+zJaCp0c
         9eXW1MsTAge14n6FZ4om3cjbNSuFKzZOrli4n7YqvOCdzKx2kgY/AxnrpblU7cn39U
         Q9mV6URIU5P4njH71Wd8Qey2uWHBwV4tDVBw2fiP6oVtKtzzWyH10sJDrYX9pS+Ppc
         dj2WChEXX/8BA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 609C4653CF; Fri, 19 Mar 2021 09:13:18 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 19 Mar 2021 09:13:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yigitates52h@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201753-28872-Jyi9zifcxR@https.bugzilla.kernel.org/>
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

Yigit (yigitates52h@outlook.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |yigitates52h@outlook.com

--- Comment #29 from Yigit (yigitates52h@outlook.com) ---
Not fixed for me either.

I'm using a Huawei MateBook D 14 AMD Ryzen 3500u. 5.11.7 kernel on Void Lin=
ux.
Same on cold boot.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
