Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876663DA03C
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhG2J3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235459AbhG2J3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 05:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E021361052
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627550977;
        bh=047uMSBQFhOKp8RlhIhnfwJy6SzwSZyH9IGGr/+CXsI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IDLIY9Gcj/2Zr6WHvlE8zFs7fFb3oJyMa4BLJo/+WrfH06D8N/SCPAuXBhmwCKbrE
         64r4MDePBXKX10/9xYGTDPcPG7Q4Z+wA8mwBquyJ9MUMNh4FFsPsfINVeBLtXrb+C4
         3WQo+Ef2WXpGnAFla0ymKUG4fDYJS6cPF+6Qs87JKKyDopX00tTMJVpmjTmrNGMbgR
         8916Hj0xW0Qq5GQt1v4+uEWFYCKzYNgb1gFfiH190HeXYDvvUpXoNZ5WBeaRfka2am
         +dqpMjsqEPjJXqqdKWMJaPZ7UtpoK2w4QtsZmOqAVyQC+V4fjUygge+ZU8hNEhS6yz
         NKFGpJtm0/MQg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id D745460EE2; Thu, 29 Jul 2021 09:29:37 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213781] KVM: x86/svm: The guest (#vcpu>1) can't boot up with
 QEMU "-overcommit cpu-pm=on"
Date:   Thu, 29 Jul 2021 09:29:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: maximlevitsky@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213781-28872-oSmTIGyhQT@https.bugzilla.kernel.org/>
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

--- Comment #3 from Maxim Levitsky (maximlevitsky@gmail.com) ---
For all practical purposes you can just revert this commit.
The fix for root cause is not simple, and I will work on it when I get to i=
t.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
