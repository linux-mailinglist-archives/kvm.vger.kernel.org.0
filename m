Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB48C311A6A
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 04:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhBFDpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 22:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231354AbhBFDnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 22:43:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BA71664FCA
        for <kvm@vger.kernel.org>; Sat,  6 Feb 2021 03:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612582969;
        bh=wIiESrxc/PIERF0GHuXNu+sI+91ydoVNJyMSwbFAh0I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oxwJ0SdQfiwSXfEldOAX1pD0x7AAXHhEUSpc3iLVynMXhKURqF2FCqa/r0yFR+Eol
         lQb0g0OsSeXsQANZ/3hFBihWj+rQABtqQHpNP3KIyyQwMBSbrwDtEVQ1GXlb7QCAMY
         93y+o5Ly5//nq73/8BVwd7ETX6yxkNysmhbIDCzer23HJvHT/twZQSIBJbIn57TPk0
         6LntsWFrIsdTciBMbsJRZg9tbRjxHihLPLYDgn+NWwfvS+Sjx1GZBUgNSFIZ+4vdko
         ux95oQuwWaN5zSvpn7NxQ4rX5kxPQObM6CCaw56jCZG2AsYNDyqsicbNbkhc2qJbKd
         J2egVqoo7D8Iw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id B22CF65338; Sat,  6 Feb 2021 03:42:49 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Sat, 06 Feb 2021 03:42:49 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-201753-28872-F3DbQokuZC@https.bugzilla.kernel.org/>
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

--- Comment #4 from Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) -=
--
Created attachment 295089
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295089&action=3Dedit
(RFCv2) Proposed workaround for the IOMMU PMC issue

RFCv2 patch adds the logic to retry after 10msec wait for each retry loop. I
have founded that certain platform takes about 10msec for the power gating =
to
disable.

Please give this a try to see if this works better on your platform.

Thanks,
Suravee

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
