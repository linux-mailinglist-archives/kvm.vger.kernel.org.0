Return-Path: <kvm+bounces-33911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 273989F46CB
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 10:04:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B4CC1695ED
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 09:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955951DDC05;
	Tue, 17 Dec 2024 09:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Umeq10OH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D12148314
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 09:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734426237; cv=none; b=U4sDrVIKy2Pg7hc20ShRvI36CWMoa7k9Bl2R1FLxt/yLckO+/knM14T+T2vXPRcYlcVoUj3h1v3+6gS8RdtLXA2/ET2CLvoq/FU0byO39uGkxogZoT4sXSbRiU12CZhx1MV/bazkDmqKbW/x+Axs+pkliFpFX4SH959HY+/7YOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734426237; c=relaxed/simple;
	bh=f/28oFaFHnkNr2ymHp7HHvdWG1FLWjTkGH53dyUGeNk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BkzLms+M17tQW8mJdMPTLEy/f3MxGly0TZFKPu51olpGeLL5GYmMwY7cYwbU4fEfvgbYIA8G6kCHf75aUDSZP31DcfL8yhrSP0dEP8kEJMrcDQMBCzJeFBZdY3ABoZshr77B2p7a2kzCIiUhOIg4j13XxKbRFop6hctAy0T1R18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Umeq10OH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 534A0C4CED7
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 09:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734426237;
	bh=f/28oFaFHnkNr2ymHp7HHvdWG1FLWjTkGH53dyUGeNk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Umeq10OHddIaQy21mCV/aQpyLsjjQfSntinjcuwAa3H5s7hz3+dJEsRKvr8GAI1kt
	 0uzavHZxybdSbcnM5+YBhxRJG+CocIVt4eATCTNALYGTXJabeM3X0kgXwgIHotokzX
	 qlgdS4zN3yHB7J/VSDiYTjiJRP+jGCQy9N/FIxnchsWjob8V2kJG7rsybxbo/t9txC
	 ZPeovNo+ZECzfoxiQRtTP3GjtluUXDWUKhR8IeELXqsftE1HDhv60XhDclDp/8ziaZ
	 pq5m922dG+dxQeZCMIBuc47JWusRUicdpxpKOIQIVA0fEMcH8JjiNs5QMwTwfVlPUB
	 6V3/cmpy8uQCg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 462AEC41612; Tue, 17 Dec 2024 09:03:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Tue, 17 Dec 2024 09:03:57 +0000
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
Message-ID: <bug-219588-28872-vBYzS6RG62@https.bugzilla.kernel.org/>
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

--- Comment #4 from leiyang@redhat.com ---
Hi (In reply to Sean Christopherson from comment #3)
> On Mon, Dec 16, 2024, bugzilla-daemon@kernel.org wrote
> However, retrying the faulting access instead of overwriting an existing
> SPTE is functionally correct and desirable irrespective of the WARN, and
> fast GUP _can_ legitimately fail with a writable VMA, e.g. if the Accessed
> bit in primary MMU's PTE is toggled and causes a PTE value mismatch.  The
> WARN was also recently added, specifically to track down scenarios where
> KVM is unnecessarily overwrites SPTEs, i.e. treating the fault as spurious
> doesn't regress KVM's bug-finding capabilities in any way.  In short,
> letting the WARN linger because there's a tiny chance it's due to a bug
> elsewhere would be excessively paranoid.
>=20
> Fixes: 1a175082b190 ("KVM: x86/mmu: WARN and flush if resolving a TDP MMU
> fault clears MMU-writable")
> Reported-by: leiyang@redhat.com
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D219588
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 12 ------------
>  arch/x86/kvm/mmu/spte.h    | 17 +++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c |  5 +++++
>  3 files changed, 22 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 22e7ad235123..2401606db260 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3364,18 +3364,6 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu
> *vcpu,
>       return true;
>  }
>=20=20
> -static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
> -{
> -     if (fault->exec)
> -             return is_executable_pte(spte);
> -
> -     if (fault->write)
> -             return is_writable_pte(spte);
> -
> -     /* Fault was on Read access */
> -     return spte & PT_PRESENT_MASK;
> -}
> -
>  /*
>   * Returns the last level spte pointer of the shadow page walk for the g=
iven
>   * gpa, and sets *spte to the spte value. This spte may be non-preset. I=
f no
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index f332b33bc817..6285c45fa56d 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -461,6 +461,23 @@ static inline bool is_mmu_writable_spte(u64 spte)
>       return spte & shadow_mmu_writable_mask;
>  }
>=20=20
> +/*
> + * Returns true if the access indiciated by @fault is allowed by the
> existing
> + * SPTE protections.  Note, the caller is responsible for checking that =
the
> + * SPTE is a shadow-present, leaf SPTE (either before or after).
> + */
> +static inline bool is_access_allowed(struct kvm_page_fault *fault, u64 s=
pte)
> +{
> +     if (fault->exec)
> +             return is_executable_pte(spte);
> +
> +     if (fault->write)
> +             return is_writable_pte(spte);
> +
> +     /* Fault was on Read access */
> +     return spte & PT_PRESENT_MASK;
> +}
> +
>  /*
>   * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected=
 for
>   * write-tracking, remote TLBs must be flushed, even if the SPTE was
> read-only,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4508d868f1cd..2f15e0e33903 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -985,6 +985,11 @@ static int tdp_mmu_map_handle_target_level(struct
> kvm_vcpu *vcpu,
>       if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
>               return RET_PF_SPURIOUS;
>=20=20
> +     if (is_shadow_present_pte(iter->old_spte) &&
> +         is_access_allowed(fault, iter->old_spte) &&
> +         is_last_spte(iter->old_spte, iter->level))
> +             return RET_PF_SPURIOUS;
> +
>       if (unlikely(!fault->slot))
>               new_spte =3D make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>       else
>=20
> base-commit: 3522c419758ee8dca5a0e8753ee0070a22157bc1

Hi Sean

This problem has gone after applied your provide patch.

Thanks
Lei

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

