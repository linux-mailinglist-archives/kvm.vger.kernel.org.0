Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAFA30B4BA
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 02:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhBBBed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 20:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBBBec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 20:34:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1811864ED6
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612229632;
        bh=LWIyhtb9DVRztRTgl07GVmkWtvemtwkkWWzBBR4Dh8U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jkDn5pnBUHPMZdUqe4XD+p1PbiPznSk0yN2RynrtSSLvOoZMWzfdIpqmgcwmAGYPW
         x3WtRZaigyJqmdoBObMZWxFiscZFbsucUoz1RK6XLLSiRfbo4Jzd7X0Gne8CDqwJeM
         MVNMvK/W2kOtf8eF4pi4YIFDftHniB1ORnZ4phk5FKG7ykF7rHjvIXCUsp7Er+Zi0v
         N/KuQUzdZBR0RRz8LpxqpfGSButvHJbrjWdg7hPvIuaEd5xPpX+NdAPxlxZi2bsASd
         9Znjky4h02qqhzs7FkeZIvsQ9JioJaOnwVO9p+L8Jblbhash2MDtrYS9oTnyHWUw7W
         sG5ZSqSTgAttg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 14EC765300; Tue,  2 Feb 2021 01:33:52 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Tue, 02 Feb 2021 01:33:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: suravee.suthikulpanit@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-201753-28872-BtmQhwXMjO@https.bugzilla.kernel.org/>
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

Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |suravee.suthikulpanit@amd.c
                   |                            |om

--- Comment #3 from Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) -=
--
Created attachment 295035
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295035&action=3Dedit
Proposed workaround for the IOMMU PMC issue

Could you please try the attached patch to see if this help fix the issue on
your platform?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
