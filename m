Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A31342208
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhCSQh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhCSQhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 846EB6198E
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616171843;
        bh=zmTb9dIhUSk0kD66jFhHnlnJTveUVyigOog5ciyssJM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aETtL6s8loFiSsTAZrms1IswjhffZ5vBn+EEHZ8FJjdS6wDrySSd5kTVMrAK2AdJw
         2tEsk0czItIiJNfAEvKjjv21+qYgZiotAZAPlNGDUuUGY6Nf78QADnrLbnIgWoegDs
         FgUbOE2AEcRbAyk/aeJjMwv1p0CeWwx9AAiMBGNvZfavghJ6pdeAfY4HEY+FkrKX2Z
         ZLFHy2aSIlSiedO2b1MB79JSIKuzhrlZdmaG0ZDTKWEShj4yByl2KB/Hzd8ZGHFrEC
         VZGwvzQ2UOxKz02XFiP2pWsk7ZI4SncR51SCrj2HBwrC0zB8GVmSyHC8WLRMgfozl+
         iwZv9rQ4tpZVQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 815A662A52; Fri, 19 Mar 2021 16:37:23 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 19 Mar 2021 16:37:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ledufff@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-zkpQ1tnLfr@https.bugzilla.kernel.org/>
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

--- Comment #31 from Neil (ledufff@hotmail.com) ---
Hah.  It's true,  cold booted and IOMMU was implemented, but after the seco=
nd
reboot, I got:

[    0.857880] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU perf
counter.

my system: linux 5.10.23-200.fc33.x86_64,  thinkpad e495 / AMD Ryzen 3500u

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
