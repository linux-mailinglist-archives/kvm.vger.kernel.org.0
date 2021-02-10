Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4923170B3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 20:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhBJTzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 14:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhBJTzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 14:55:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EC13A64EF0
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 19:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612986867;
        bh=t3YTvJCmNlBvz6doktX5isug1DWOzLVAidQyqWq93Q4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BB0YPHTzRNPUQmUwka6vHZ122G6JdTlIFtTSMQxgwFD/3n3I+IUleozKrf20hBWl7
         ybQniq1voyGrhYRum45iZykG5fZf7J8BxZjLAvhP312R18uhpv6heAvd2PMvwsJqi2
         COxWz/VCHNqqwVYXaZwItzIkAvZK8ZLpMkBEUrahkgzmGTp0iu7wsnw6EJiRtONwoY
         ZJZActre2s16T/42IXUv69e6G5dLGPsCyZqSluUnLF1MwsifeVxPkDKE0ei38KRloN
         pSauvoTFH2iV6ZYyGaqcesVhljTEFjxTJ8NSy8jcPvo4bH9iP/gahfsWCw9CNslkq+
         7F/e1tpf/mtzA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id E56BF65259; Wed, 10 Feb 2021 19:54:26 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Wed, 10 Feb 2021 19:54:26 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-201753-28872-qA78AzFWLH@https.bugzilla.kernel.org/>
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

--- Comment #7 from Neil (ledufff@hotmail.com) ---
Created attachment 295199
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295199&action=3Dedit
Thinkpad E495 with RFCv2 patch.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
