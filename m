Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BE33F83E3
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 10:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbhHZIoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 04:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhHZIoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 04:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CAED6108D
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 08:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629967418;
        bh=kgRaT8vRIMxbg6yZzEBCp+C86dyKhlrbMPxdlRo0RXg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ChWJqFEC2pJISStzBW68WYcl3iAQRJc+PIuxoXcvUHRpc6loObFFDotb8QnHfvHKW
         59Ub9+Ex6Xvecz4Kj1CjUt5aSSevjHAutjODlxau57mFblKxjbd0XBnuB6dEU7NtRq
         tCp78wyBVznb2ZOKEFemuZKxxcaDs/iCnfTnWWuyiXEiNbR+n3cGgnbqQlqXdi6Chu
         U9JarkW58DV31dliu2MzcGLGzXVG5NAMlPkDJifbb1ryz1wyzI2BkvudBtUH8j+GmR
         lXgucPchfimrXEVvzScOTJu0/lqTv7pmceyTDkFtF1Sccd+dq0jNCfxaBE8jxJZwbC
         OA/6YJrahqRwQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 099D460E17; Thu, 26 Aug 2021 08:43:38 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 26 Aug 2021 08:43:37 +0000
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
Message-ID: <bug-201753-28872-yQCtRJG8oN@https.bugzilla.kernel.org/>
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

--- Comment #36 from Paul Menzel (pmenzel+bugzilla.kernel.org@molgen.mpg.de=
) ---
@00oo00, can you please close the issue?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
