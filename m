Return-Path: <kvm+bounces-41572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26CA5A6A8FC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1A203B9739
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768411DE4F0;
	Thu, 20 Mar 2025 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAp5jWsW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00561876
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742482087; cv=none; b=YhxdnRMP/uyRUySC8EzwzHwpJttBaWwAk9DTVwqqAjUyVYo5a6BCaJFO7xpvSoayHZHT7C7oTZpwJDgfkKdLAhBHWijqoatwyRjm8CJmkkz0HYZoUVA+rLnggJw0LP/6XR4qU6rysGIWyH+pj1S+SIpqEeWShadM2mLCpJjjP3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742482087; c=relaxed/simple;
	bh=d8q5h/67CPZya8DCfrs98Ox5tqKpTzf92v7OI9flnbQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FuOF96v/Ym2PIXd1HLrqonCvstnUJGEoRFpJZvrY5DgJh/f6kgOBWdayLbJCVXz5Ixw8wzrdhKu+N3SMbSmRVE5rqlZGtS8XXaOtHrHMdFRA9nR7jd00AJk2OZZQFSKuxlXf2LoZwH4In4tZ49FDrVzn7RHLCt+NQTFmgF+HDUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAp5jWsW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11704C4CEEC
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742482086;
	bh=d8q5h/67CPZya8DCfrs98Ox5tqKpTzf92v7OI9flnbQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZAp5jWsW9igjaUo+KYjKHW6iwyhDqAMVTrzGznGh8UHvurp9S65MVXM83aWTs70nh
	 uRCzPqEQr1Y3kj1bpXGvDq+OXXVlMhknvk03gcu/kIfj5556JWSbgxjW3zTfrRbXDD
	 KjZOBscOpVCHnSHnp4N3V/xLY0RRzfK/7VRMBibu9q/lVnys5tg7x2qyquD5RFKNdJ
	 Dyx1r0UP9FaXF0whbRFnRkF9VcLDPoYkDPcE46sv+mhP592LCJdKe/QNUEJFoNtbL5
	 3oiOv9AHfN2fu8Hzga5RktrdXhSJypJlMFI6SRLi+uyJQsmxcPAD8MwXxRHfFWN+rE
	 vtjoswOAxe2BA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0A4F7C53BBF; Thu, 20 Mar 2025 14:48:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Thu, 20 Mar 2025 14:48:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: leiyang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219588-28872-eXbiKnwTHU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219588-28872@https.bugzilla.kernel.org/>
References: <bug-219588-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219588

--- Comment #5 from leiyang@redhat.com ---
Due to the fixed patch has been merge into the upstream master branch, so c=
lose
done this bug.

commit 386d69f9f29b0814881fa4f92ac7b8dfa9b4f44a
Author: Sean Christopherson <seanjc@google.com>
Date:   Wed Dec 18 13:36:11 2024 -0800

    KVM: x86/mmu: Treat TDP MMU faults as spurious if access is already all=
owed

    Treat slow-path TDP MMU faults as spurious if the access is allowed giv=
en
    the existing SPTE to fix a benign warning (other than the WARN itself)
    due to replacing a writable SPTE with a read-only SPTE, and to avoid the
    unnecessary LOCK CMPXCHG and subsequent TLB flush.

    If a read fault races with a write fault, fast GUP fails for any reason
    when trying to "promote" the read fault to a writable mapping, and KVM
    resolves the write fault first, then KVM will end up trying to install a
    read-only SPTE (for a !map_writable fault) overtop a writable SPTE.

    Note, it's not entirely clear why fast GUP fails, or if that's even how
    KVM ends up with a !map_writable fault with a writable SPTE.  If someth=
ing
    else is going awry, e.g. due to a bug in mmu_notifiers, then treating r=
ead
    faults as spurious in this scenario could effectively mask the underlyi=
ng
    problem.

    However, retrying the faulting access instead of overwriting an existing
    SPTE is functionally correct and desirable irrespective of the WARN, and
    fast GUP _can_ legitimately fail with a writable VMA, e.g. if the Acces=
sed
    bit in primary MMU's PTE is toggled and causes a PTE value mismatch.  T=
he
    WARN was also recently added, specifically to track down scenarios where
    KVM is unnecessarily overwrites SPTEs, i.e. treating the fault as spuri=
ous
    doesn't regress KVM's bug-finding capabilities in any way.  In short,
    letting the WARN linger because there's a tiny chance it's due to a bug
    elsewhere would be excessively paranoid.

    Fixes: 1a175082b190 ("KVM: x86/mmu: WARN and flush if resolving a TDP M=
MU
fault clears MMU-writable")
    Reported-by: Lei Yang <leiyang@redhat.com>
    Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D219588

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

