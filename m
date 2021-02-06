Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDF2311AA9
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 05:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhBFEFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 23:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhBFEC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 23:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A9A264FB3
        for <kvm@vger.kernel.org>; Sat,  6 Feb 2021 04:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612584094;
        bh=ayqm0r3cKo8uH1ONDGkJx6e6Wh8VRDsJq+hYZWkgOgQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IC4/Ghn4yW94bABEUj7KfJj4PDZAC/RsepXZX29u81xbUdofR399I+gjsqWe2qTuM
         7TMItPowLUbxHMN3eSTda9WOkEZSKr5U1LUNXzgIaYCQGB2WtbhoSUf5izYn6uZWcq
         dANcTRVW1+FnaQ+dsWLu4eK7DpRCKkfjwJG0Oyw6/OyJx7vENYuf+20cLZz44Tkcdg
         zUR5MpHQVNnxypH+YvY3ld2OYueXG5ga642K00NEv9Sa30Fv2NetbcyG62uZp5E3pZ
         SXaa4O1pPk8gj5MeeGTCzNkWVMK4zqE8f8Qks+XzCzBAjdq1bXUvI8OPC3PpPhDn+P
         QYNV06wJ+/FCQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 407406533F; Sat,  6 Feb 2021 04:01:34 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Sat, 06 Feb 2021 04:01:33 +0000
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
Message-ID: <bug-201753-28872-9eu5nLR26K@https.bugzilla.kernel.org/>
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

--- Comment #5 from Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) -=
--
Created attachment 295091
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295091&action=3Dedit
(RFCv3) Proposed workaround for the IOMMU PMC issue

RFCv3 patch adds the logic to retry checking after 20msec wait for each ret=
ry
loop since I have founded that certain platform takes about 10msec for the
power gating to disable.

Please give this a try to see if this works better on your platform.

Thanks,
Suravee

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
