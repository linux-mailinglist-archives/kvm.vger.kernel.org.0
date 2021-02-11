Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07CE3191D5
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhBKSGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 13:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231477AbhBKSDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 13:03:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9442864DF3
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613066585;
        bh=seazP6u09eQMkDa/mO+XCCCWc9j3J9Gbeg0MY8zFolI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bbfDAy7WjZlB8e2WRarGWda8dSTSCzLTsJISd7xF4L304qxAVq45SrEarf8oGACCG
         QHop7UCjFTf0YLkWj27w7NqZ+8KhK7Y/BPQLNBGP5xNIJml1793Yril96FdNnFsEf+
         Ye4DICTsuAODrV3EfEn2u34MeWKOac6jwrmLW3AjJGSTSZU4z6LrHtJ/XR41IcO6IG
         /qyazo2GVpWdzDmGDzKDIgD6xo9VlKxJVXCm87coUWYOGcCZHuEQp7Pt8qWAZ5dQLx
         3YCARav3dXljRFHNRuNBph4dSzrked/uC6PjNlvwJwbIe+7oHevtyHm5YEI7hvQGXN
         AkwXWzpgOn9ww==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 861216530F; Thu, 11 Feb 2021 18:03:05 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 11 Feb 2021 18:03:05 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-kqF6iYcLPA@https.bugzilla.kernel.org/>
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

--- Comment #8 from Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) -=
--
RFC v2 and v3 should be similar. I have modified the retry loop a bit in V3=
 to
be more efficient.

Patch has been submitted here (https://lkml.org/lkml/2021/2/8/486)

Thanks,
Suravee

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
