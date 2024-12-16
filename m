Return-Path: <kvm+bounces-33882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A7929F3E75
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FD57169556
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67EA1DB34B;
	Mon, 16 Dec 2024 23:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E6UVNIDI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCEF42A9B
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393180; cv=none; b=iK6QEP+1tUnONO2XFQv9J3XhCktePhevBC6JohLKOXB6gZ2Y5CwKAb3jiLQ7SSQYzs5Q3iPY0ynmwzf40hsMKgx/wM08Bs2Z8s/DYQ5Y2v4n6MSPh1/7G41jO50wgnBIPYy+Ztq3w34xFGO4cCw0WRiwx+CuKYzFL0k+ts+PSr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393180; c=relaxed/simple;
	bh=AfOPcoQe2pEyruAVaqv4rRRskdF5u7zmuaRJlxWnMn4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mXjALpwyONFyX9vumzHCjbgeoNsHezL4bBgvK+K4HTn1flfOLyj62ZMgVy/iJ2fNfyIgIa2SlsUcgeDKdoJ0jxKZ6QWHYmoUORByldLd7+qduCMIG9A4+FYakJxo+DQpB1nH+Lf/kUEPRfvPhzAeC/NF5PO0IdwGMqdLM4d8n9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E6UVNIDI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51460C4CEDE
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734393180;
	bh=AfOPcoQe2pEyruAVaqv4rRRskdF5u7zmuaRJlxWnMn4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=E6UVNIDIi0eAX7kmhRj6bp9Lp6WfgqijHWWeE2B+bGcYd0vcV8aS1NaMVxHNwf7YJ
	 +rgQBhLjtBYe1KajUwM+7eMEsNghQkpERpiyuFDdU2SxamyVlT3xgEB91/S/D3VjQ8
	 QrapDJoZeFitbaLYRb/9SmKiHIG74Y6Xw8vOsHQeNjgHsELyeNXTLsLLG09g954WcU
	 SgJa8iKMRPKHhbGtggsGft9KALFRWzygqothNtMXztGWxJMBXQZQRV8GmKaomxR3aE
	 jliWfKGV273qsNNdvLYCEDedOb2ZJBnyQJ+hNgGwcNkmUTfmE9R0LoFgpMOzlu2SVK
	 DO6AdAsxc0Bsg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4670CC41615; Mon, 16 Dec 2024 23:53:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Mon, 16 Dec 2024 23:53:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219588-28872-7tUg8CMueR@https.bugzilla.kernel.org/>
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

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
On Mon, Dec 16, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219588
>=20
> --- Comment #2 from leiyang@redhat.com ---
> (In reply to Sean Christopherson from comment #1)
> > On Wed, Dec 11, 2024, bugzilla-daemon@kernel.org wrote:
> > > I hit a bug on the intel host, this problem occurs randomly:
> > > [  406.127925] ------------[ cut here ]------------
> > > [  406.132572] WARNING: CPU: 52 PID: 12253 at
> > arch/x86/kvm/mmu/tdp_mmu.c:1001
> > > tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
> >=20
> > Can you describe the host activity at the time of the WARN?  E.g. is it
> under
> > memory pressure and potentially swapping, is KSM or NUMA balancing acti=
ve?
> I
> > have a sound theory for how the scenario occurs on KVM's end, but I sti=
ll
> > think
> > it's wrong for KVM to overwrite a writable SPTE with a read-only SPTE in
> this
> > situation.
>=20
> I spent some time for this problem so late reply. When host dmesg print t=
his
> error messages which running install a new guest via automation. And I fo=
und
> this bug's reproducer is run this install case after the mchine first time
> running(Let me introduce more to avoid ambiguity=EF=BC=9A 1. Must to test=
 it when the
> machine first time running this kernel,that mean's if I hit this problem =
then
> reboot host, it can not reproduced again even if I run the same tests.

Yeah, WARN_ON_ONCE() suppresses the splat after a single occurrence.  If KV=
M is
built as a module, you can can unload and reload kvm.ko (and whatever vendor
you're using) instead of rebooting.  The flag that controls the "once" beha=
vior
is tied to the lifetime of kvm.ko.

> 2.  Based on 1, I also must test this installation guest case, it can not
> reporduced on other cases.). But through compare, this installation cases
> only used pxe install based on a internal KS cfg is different other cases.

Mostly out of curiosity, what's "KS cfg"?

> Sure, I think it's running under memory pressure and swapping. Based on
> automation log, KSM is disable and I don't add NUMA in qemu command line.=
=20
>=20
> If you have a machine can clone avocado and run tp-qemu tests, you can
> prepare
> env then run this case:
> unattended_install.cdrom.extra_cdrom_ks.default_install.aio_threads
>=20
> >=20
> > And does the VM have device memory or any other type of VM_PFNMAP or VM=
_IO
> > memory exposed to it?  E.g. an assigned device?  If so, can you provide=
 the
> > register
> > state from the other WARNs?  If the PFNs are all in the same range, then
> > maybe
> > this is something funky with the VM_PFNMAP | VM_IO path.
>=20
> I can confirm it has VM_IO because it runing installation case, VM is
> constantly performing I/O operations

Heh, VM_IO and emulated I/O for the guest are two very different things.  V=
M_IO
would typically only be present if you're doing some form of device
passthrough.

Regardless, I don't know that it's worth trying to figure out exactly what's
happening in the primary MMU.  What's happening is perfectly legal, and the
odds
of there being an underlying bug *and* it not having any other symptoms is =
very
low.  And it definitely doesn't make sense to withold a fix just because I'm
paranoid :-)

So, assuming you can test custom kernels, can you test this and confirm it
makes
the WARN go away?  If it does, or if you can't test it, I'll post a proper
patch.
If it doesn't fix the issue, then something completely unexpected is happen=
ing
and we'll have to dig deeper.

---
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 16 Dec 2024 13:18:01 -0800
Subject: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access is
 already allowed

Treat slow-path TDP MMU faults as spurious if the access is allowed given
the existing SPTE to fix a benign warning (other than the WARN itself)
due to replacing a writable SPTE with a read-only SPTE, and to avoid the
unnecessary LOCK CMPXCHG and subsequent TLB flush.

If a read fault races with a write fault, fast GUP fails for any reason
when trying to "promote" the read fault to a writable mapping, and KVM
resolves the write fault first, then KVM will end up trying to install a
read-only SPTE (for a !map_writable fault) overtop a writable SPTE.

Note, it's not entirely clear why fast GUP fails, or if that's even how
KVM ends up with a !map_writable fault with a writable SPTE.  If something
else is going awry, e.g. due to a bug in mmu_notifiers, then treating read
faults as spurious in this scenario could effectively mask the underlying
problem.

However, retrying the faulting access instead of overwriting an existing
SPTE is functionally correct and desirable irrespective of the WARN, and
fast GUP _can_ legitimately fail with a writable VMA, e.g. if the Accessed
bit in primary MMU's PTE is toggled and causes a PTE value mismatch.  The
WARN was also recently added, specifically to track down scenarios where
KVM is unnecessarily overwrites SPTEs, i.e. treating the fault as spurious
doesn't regress KVM's bug-finding capabilities in any way.  In short,
letting the WARN linger because there's a tiny chance it's due to a bug
elsewhere would be excessively paranoid.

Fixes: 1a175082b190 ("KVM: x86/mmu: WARN and flush if resolving a TDP MMU f=
ault
clears MMU-writable")
Reported-by: leiyang@redhat.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D219588
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 12 ------------
 arch/x86/kvm/mmu/spte.h    | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c |  5 +++++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22e7ad235123..2401606db260 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3364,18 +3364,6 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu
*vcpu,
        return true;
 }

-static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
-{
-       if (fault->exec)
-               return is_executable_pte(spte);
-
-       if (fault->write)
-               return is_writable_pte(spte);
-
-       /* Fault was on Read access */
-       return spte & PT_PRESENT_MASK;
-}
-
 /*
  * Returns the last level spte pointer of the shadow page walk for the giv=
en
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If =
no
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index f332b33bc817..6285c45fa56d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -461,6 +461,23 @@ static inline bool is_mmu_writable_spte(u64 spte)
        return spte & shadow_mmu_writable_mask;
 }

+/*
+ * Returns true if the access indiciated by @fault is allowed by the exist=
ing
+ * SPTE protections.  Note, the caller is responsible for checking that the
+ * SPTE is a shadow-present, leaf SPTE (either before or after).
+ */
+static inline bool is_access_allowed(struct kvm_page_fault *fault, u64 spt=
e)
+{
+       if (fault->exec)
+               return is_executable_pte(spte);
+
+       if (fault->write)
+               return is_writable_pte(spte);
+
+       /* Fault was on Read access */
+       return spte & PT_PRESENT_MASK;
+}
+
 /*
  * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected f=
or
  * write-tracking, remote TLBs must be flushed, even if the SPTE was
read-only,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4508d868f1cd..2f15e0e33903 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -985,6 +985,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_=
vcpu
*vcpu,
        if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
                return RET_PF_SPURIOUS;

+       if (is_shadow_present_pte(iter->old_spte) &&
+           is_access_allowed(fault, iter->old_spte) &&
+           is_last_spte(iter->old_spte, iter->level))
+               return RET_PF_SPURIOUS;
+
        if (unlikely(!fault->slot))
                new_spte =3D make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
        else

base-commit: 3522c419758ee8dca5a0e8753ee0070a22157bc1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

