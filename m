Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B313D9B5A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 03:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhG2B5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 21:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhG2B5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 21:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F39CB6103B
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 01:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627523852;
        bh=gUZAThDOjCYPLhIJmnyogHl5F0+zIHrZ0V4rLI0+tQ0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vCueQg+Y0vA7+h3sPEQX90JdHF+BhRHQwH8qw67kvWexVoa5IAp+I4m0UMQOGPvNi
         gBHkenAh5nR7RQzN+XT9AKq1pxpB+Hx+k4xf0tUzX2En8DI08rPcefo+ePt7ATBBQ9
         IKJ52kXsRt0FT5000vn1fTuFPv7tYmYjDusey39B9qCt1BnG+hSrbvlUR81SrCa6Us
         l5rvCnvEglzsxnzuUOQfTjv7JNFQid7Qg5124+4hnaTRw39t+DwT38U7XVYUJkDJM8
         /lFy2/2byftOqIUKXL8C1cP45KiCF5tCKYRxRFSpju1aFh/O/W/lkkDLMbozaNl2AN
         UR6U77iVrTv9Q==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id EBC9760EE0; Thu, 29 Jul 2021 01:57:31 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213781] KVM: x86/svm: The guest (#vcpu>1) can't boot up with
 QEMU "-overcommit cpu-pm=on"
Date:   Thu, 29 Jul 2021 01:57:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: like.xu.linux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213781-28872-BriNkrB4vZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213781-28872@https.bugzilla.kernel.org/>
References: <bug-213781-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213781

--- Comment #2 from Like Xu (like.xu.linux@gmail.com) ---
Hi Maxim,

Do we have any updates on this issue? Can you help provide more details
about "non-atomic memslot update made by qemu" so I can try to fix it?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
