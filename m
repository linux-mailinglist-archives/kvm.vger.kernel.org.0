Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D133FCA6
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 02:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCRBXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 21:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCRBWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 21:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3183B64F5E
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 01:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616030572;
        bh=t4jf2oRX+1pTbQ28haR+KVrY/u9mSWWExT6m90CdiiU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KTEpobjhs/H8GEb06SqswaR4102nWGd18cUH/ZbW0BiE+bfj02Dkzg4wkZ4OE0u35
         6izvI0jWvqgkhwMwnUZRtxY+00IthqAT204BlwvrkeAkziagKpID7i6kldh1zUXPby
         rxDuGAc+zio8rJxi3rpI4sZNh6x/ogLD3AC8DaW5q8Y0NOtstv+s8RVKmR5H2INTg0
         uCeHmyhqZ0fzjPa1kaP4kFWVinrbSOWgmHmaPZ1jSd5SSg5BrwI5ZfRlc5i9OtDkYE
         A4Ehai6G6yEnV3rrn2HU2CF0npCbfiXFW0VapALYKZW0B3gNBkdpm5zx8G16BADYr0
         flVJU02Z5zMOA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 27843653C7; Thu, 18 Mar 2021 01:22:52 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 18 Mar 2021 01:22:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kitchm@tutanota.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201753-28872-RdZc6ZE6ap@https.bugzilla.kernel.org/>
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

kitchm@tutanota.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kitchm@tutanota.com

--- Comment #25 from kitchm@tutanota.com ---
I do not know if this will help your testing, but I am using MSI 450-A Pro =
and
AMD Ryzen 3 2200G with Radeon Vega Graphics.  When booting into Debian 10 I
have always seen the error message that states:
"Unable to write to  IOMMU perf counter"
It flashes at the top of the screen as the first item then goes away only t=
o be
rewritten at the top of the boot process steps.  It only last a moment and =
then
everything boots normally.

However, I just updated to the latest BIOS version and it hung at that point
every time.  The BIOS version was Beta, so re-flashing to the older version
solved the problem.  It is now back to its normal behavior.

I'm not into manual kernel changes or configuring from source, so I'm sorry=
 if
I can't help more.

Hope this info helps your research, and thanks for it.  Keep up the great w=
ork.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
