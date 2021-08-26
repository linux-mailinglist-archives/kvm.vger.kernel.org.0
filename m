Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B083F83E2
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 10:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240630AbhHZInl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 04:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhHZInl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 04:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 443A5610E6
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 08:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629967374;
        bh=PJuWbYzMcpwQb45ovlfJe5giEQ7UBx2LhUc4BQbbHng=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Zy+voZTfkoURsSY+Mnb/3gPpKfqIKvNGcAoJ+flp4rwjP9QISdOgpnRTNEV8E4+nX
         YMwiIyt5qsHzcFXeuVQ6uDYFeLaWidEXdVuvqZbpJbSWhQAQ/1iajYspDjIoOO7eAH
         lLFAFjxzCZL86PWYurisyRXcywNnu1V/qPvG3rQjJqStDOvApy6yGVGbpNkduT0OAo
         fh/6VYJA489BpaSI/SJuzSBIH9vbgX9uHNAKYDnqA9BjHHcwixTT6/KbXVCvnCwzxt
         iHS6tjj4dLxlGdVsCYFM++uGTVycT+4xWRAcMhiyZxRylYI5upq0t42ibTU87NJLND
         wVO3SONz0evcw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 41B9A60E16; Thu, 26 Aug 2021 08:42:54 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 26 Aug 2021 08:42:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pmenzel+bugzilla.kernel.org@molgen.mpg.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-z91nNqnSn6@https.bugzilla.kernel.org/>
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

--- Comment #35 from Paul Menzel (pmenzel+bugzilla.kernel.org@molgen.mpg.de=
) ---
Commit 994d6608 (iommu/amd: Remove performance counter pre-initialization t=
est)
[1] fixes this, and was added to Linux 5.13.

[1]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D994d6608efe4a4c8834bdc5014c86f4bc6aceea6

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
